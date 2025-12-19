package domain;

import java.util.Objects;

import lombok.Data;

@Data
public class User {
    private String userId;
    private String nickname;
    private String avatar;

    // getter / setter »ý·«

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User)) return false;
        User user = (User) o;
        return Objects.equals(userId, user.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId);
    }
    
    
}
