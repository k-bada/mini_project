package domain;

import java.io.IOException;
import java.util.*;
import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@ServerEndpoint(
    value = "/room",
    configurator = HttpSessionConfigurator.class
)
public class RoomWebSocket {

    private static Map<String, Room> roomMap = new HashMap<>();
    private static Set<Session> sessions = new HashSet<>();
    private static Gson gson = new Gson();

    /* ===== 접속 ===== */
    @OnOpen
    public void onOpen(Session session, EndpointConfig config) throws IOException {
        sessions.add(session);

        HttpSession httpSession =
            (HttpSession) config.getUserProperties().get("httpSession");

        User user = (User) httpSession.getAttribute("user");
        if (user == null) {
            user = new User();
            user.setUserId(UUID.randomUUID().toString()); 
            user.setNickname("게스트-" + user.getUserId().substring(0, 4));
            user.setAvatar("/img/default-avatar.jpg");
            httpSession.setAttribute("user", user);
        }
        
        // 혹시 기존 유저인데 avatar 없는 경우도 대비
        if (user.getAvatar() == null) {
        	user.setAvatar("/img/default-avatar.jpg");
        }

        session.getUserProperties().put("user", user);
        sendRoomList(session);
    }

    /* ===== 종료 ===== */
    @OnClose
    public void onClose(Session session) throws IOException {
        sessions.remove(session);
        // ❌ 방 관련 로직 절대 하지 말 것
        System.out.println("🔌 WebSocket closed (방 유지)");
    }


    /* ===== 메시지 ===== */
    @OnMessage
    public void onMessage(String msg, Session session) throws IOException {
        JsonObject json = JsonParser.parseString(msg).getAsJsonObject();
        String type = json.get("type").getAsString();
        User user = (User) session.getUserProperties().get("user");

        switch (type) {
            case "CREATE_ROOM": {
                String roomId = createRoom(json, user);

                JsonObject res = new JsonObject();
                res.addProperty("type", "ROOM_CREATED");
                res.addProperty("roomId", roomId);

                session.getBasicRemote().sendText(res.toString());
                broadcastRooms();
                break;
            }
            case "JOIN_ROOM": {
                String roomId = json.get("roomId").getAsString();

                boolean joined = joinRoom(roomId, user);

                JsonObject res = new JsonObject();

                if (joined) {
                    res.addProperty("type", "JOIN_OK");
                    res.addProperty("roomId", roomId);
                } else {
                    res.addProperty("type", "JOIN_DENY");
                    res.addProperty("roomId", roomId);
                    res.addProperty("reason", "이미 꽉 찬 방입니다.");
                }

                session.getBasicRemote().sendText(res.toString());
                broadcastRooms();
                break;
            }

            case "LEAVE_ROOM": {
                String roomId = json.get("roomId").getAsString();

                leaveRoom(roomId, user);

                // ✅ 나간 직후 반드시 전체 브로드캐스트
                broadcastRooms();
                break;
            }

        }
    }


    /* ===== 방 생성 ===== */
    private String createRoom(JsonObject json, User user) {
        Room room = new Room();
        room.setRoomId(UUID.randomUUID().toString());
        room.setTitle(json.get("title").getAsString());
        room.setMode(json.get("mode").getAsString());

        room.setBlackPlayer(user);
        room.setWhitePlayer(null);
        room.setGameStatus(false);

        roomMap.put(room.getRoomId(), room);
        return room.getRoomId(); // ⭐ 핵심
    }

    /* ===== 방 입장 ===== */
    private synchronized boolean joinRoom(String roomId, User user) {
        Room room = roomMap.get(roomId);
        if (room == null) return false;

        if (user.equals(room.getBlackPlayer()) ||
            user.equals(room.getWhitePlayer())) {
            return true;
        }

        if (room.getWhitePlayer() != null) {
            return false; // ❌ 이미 2명
        }

        room.setWhitePlayer(user);
        room.setGameStatus(true);
        return true;
    }

    
    /* ===== 방에 나가기 ===== */
    private synchronized void leaveRoom(String roomId, User user) {
        Room room = roomMap.get(roomId);
        if (room == null) return;

        // 방장이 나가는 경우
        if (user.equals(room.getBlackPlayer())) {

            // 흰돌이 있으면 방장 승격
            if (room.getWhitePlayer() != null) {
                room.setBlackPlayer(room.getWhitePlayer());
                room.setWhitePlayer(null);
                room.setGameStatus(false);
            } else {
                // 아무도 없으면 방 삭제
                roomMap.remove(roomId);
                return;
            }

        }
        // 두 번째 플레이어가 나가는 경우
        else if (user.equals(room.getWhitePlayer())) {
            room.setWhitePlayer(null);
            room.setGameStatus(false);
        }

        // 안전 장치
        if (room.getBlackPlayer() == null && room.getWhitePlayer() == null) {
            roomMap.remove(roomId);
        }
    }



    private void sendRoomList(Session session) throws IOException {
        session.getBasicRemote().sendText(gson.toJson(roomMap.values()));
    }

    private void broadcastRooms() throws IOException {
    	System.out.println("📢 broadcastRooms 호출됨, 방 개수 = " + roomMap.size());
    	
        String json = gson.toJson(roomMap.values());
        for (Session s : sessions) {
            s.getBasicRemote().sendText(json);
        }
    }
}
