@ServerEndpoint("/room")
public class RoomWebSocket {

    @onOpen
    public void onOpen(Session session) {

        Player player = new Player();
        player.set

        session.getUserProperties().put("player", player);
    }
}
