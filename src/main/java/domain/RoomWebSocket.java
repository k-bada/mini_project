package domain;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
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

	    @OnOpen
	    public void onOpen(Session session, EndpointConfig config)
	            throws IOException {

	        sessions.add(session);

	        HttpSession httpSession =
	            (HttpSession) config.getUserProperties().get("httpSession");

	        User user = (User) httpSession.getAttribute("user");
	        session.getUserProperties().put("user", user);

	        sendRoomList(session);
	    }

	    @OnClose
	    public void onClose(Session session) throws IOException {
	        sessions.remove(session);
	        removeUserFromRooms(session);
	        broadcastRooms();
	    }

	    @OnMessage
	    public void onMessage(String msg, Session session)
	            throws IOException {

	        JsonObject json = JsonParser.parseString(msg).getAsJsonObject();
	        String type = json.get("type").getAsString();

	        User user = (User) session.getUserProperties().get("user");

	        if ("CREATE_ROOM".equals(type)) {
	            createRoom(json, user);
	        }

	        if ("JOIN_ROOM".equals(type)) {
	            joinRoom(json.get("roomId").getAsString(), user);
	        }

	        broadcastRooms();
	    }

	    /* ===== 规 积己 ===== */
	    private void createRoom(JsonObject json, User user) {
	        Room room = new Room();
	        room.setRoomId(UUID.randomUUID().toString());
	        room.setTitle(json.get("title").getAsString());
	        room.setMode(json.get("mode").getAsString());
	        room.setBlackPlayer(user);
	        room.setGameStatus(false);

	        roomMap.put(room.getRoomId(), room);
	    }

	    /* ===== 规 涝厘 ===== */
	    private void joinRoom(String roomId, User user) {
	        Room room = roomMap.get(roomId);
	        if (room != null && room.getWhiteUser() == null) {
	            room.setWhiteUser(user);
	            room.setGameStatus(true);
	        }
	    }

	    /* ===== 规 硼厘 / 昏力 ===== */
	    private void removeUserFromRooms(Session session) {
	        User user = (User) session.getUserProperties().get("user");

	        roomMap.values().removeIf(room -> {
	            if (user.equals(room.getBlackUser())) {
	                room.setBlackUser(null);
	            }
	            if (user.equals(room.getWhiteUser())) {
	                room.setWhiteUser(null);
	            }
	            return room.getBlackUser() == null
	                && room.getWhiteUser() == null;
	        });
	    }

	    private void sendRoomList(Session session) throws IOException {
	        session.getBasicRemote().sendText(
	            new Gson().toJson(roomMap.values())
	        );
	    }

	    private void broadcastRooms() throws IOException {
	        String json = new Gson().toJson(roomMap.values());
	        for (Session s : sessions) {
	            s.getBasicRemote().sendText(json);
	        }
	    }
	}
