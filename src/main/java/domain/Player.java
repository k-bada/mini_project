package domain;

import lombok.Data;

@Data
public class Player {
    private User userId;   // session or userid
    private String nickname;
    private String avatar; 
    private String stone;   // BLACK / WHITE

    
}
