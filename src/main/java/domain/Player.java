package domain;


public class Player {
    private String playerId;   // session or uuid
    private String nickname;
    private String avatar;
    private String stone;   // BLACK / WHITE

    public String getPlayerId() {
        return playerId;
    }
    public void setPlayerId(String playerId) {
        this.playerId = playerId;
    }
    public String getNickname() {
        return nickname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
    public String getAvatar() {
        return avatar;
    }
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    public String getStone() {
        return stone;
    }
    public void setStone(String stone) {
        this.stone = stone;
    }
}
