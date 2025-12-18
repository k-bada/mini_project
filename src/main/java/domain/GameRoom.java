package domain;

import java.util.HashMap;
import java.util.Map;

import javax.websocket.Session;

public class GameRoom {

    private String roomId;
    private Map<Session, User> users = new HashMap<>();
    private String[][] board = new String[15][15];
    private String currentTurn = "BLACK";

    public GameRoom(String roomId) {
        this.roomId = roomId;
    }

    public void addUser(Session session, User user) {
        users.put(session, user);
    }

    public void removeUser(Session session) {
        users.remove(session);
    }

    public boolean isEmpty() {
        return users.isEmpty();
    }

    public Map<Session, User> getUsers() {
        return users;
    }
}
