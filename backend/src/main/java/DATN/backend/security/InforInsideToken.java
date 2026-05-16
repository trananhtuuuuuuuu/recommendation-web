package DATN.backend.security;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class InforInsideToken {
    private Long userId;
    private String userName;
    private String email;
    private String roleName;
}