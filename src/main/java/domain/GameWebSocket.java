package domain;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(
	    value = "/game/{roomId}",
	    configurator = HttpSessionConfigurator.class
	)
	public class GameWebSocket {

	    private static Map<String, GameRoom> gameRoomMap = new HashMap<>();

	    @OnOpen
	    public void onOpen(
	        Session session,
	        @PathParam("roomId") String roomId,
	        EndpointConfig config
	    ) {

	        HttpSession httpSession =
	            (HttpSession) config.getUserProperties().get("httpSession");

	        User user = (User) httpSession.getAttribute("user");

	        GameRoom gameRoom =
	            gameRoomMap.computeIfAbsent(roomId, GameRoom::new);

	        gameRoom.addUser(session, user);
	        session.getUserProperties().put("roomId", roomId);
	    }

	    @OnClose
	    public void onClose(Session session) {

	        String roomId =
	            (String) session.getUserProperties().get("roomId");

	        GameRoom gameRoom = gameRoomMap.get(roomId);
	        if (gameRoom != null) {
	            gameRoom.removeUser(session);
	            if (gameRoom.isEmpty()) {
	                gameRoomMap.remove(roomId);
	            }
	        }
	    }

	    @OnMessage
	    public void onMessage(String msg, Session session)
	            throws IOException {

	        String roomId =
	            (String) session.getUserProperties().get("roomId");

	        GameRoom gameRoom = gameRoomMap.get(roomId);

	        for (Session s : gameRoom.getUsers().keySet()) {
	            s.getBasicRemote().sendText(msg);
	        }
	    }
	}
