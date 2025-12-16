package domain;

public class Room {
    private String roomId;
    private String title;
    private Player blackPlayer;
    private Player whitePlayer;
    private String mode;        //30s, 60s 추가
    private String[][] board; // 15x15
    private String currentTurn;
    private String gameStatus;
}
