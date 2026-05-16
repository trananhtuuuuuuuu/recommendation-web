package DATN.backend.response.auth;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LoginResponse {
    private String token;
    private String tokenType = "Bearer";
    private Long userId;
    private String userName;
    private String email;
    private String roleName;
}