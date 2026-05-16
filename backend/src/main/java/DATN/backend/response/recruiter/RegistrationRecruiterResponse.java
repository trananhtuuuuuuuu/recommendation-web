package DATN.backend.response.recruiter;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RegistrationRecruiterResponse {
    private Long id;
    private String userName;
    private String email;
    private String companyName;
    private String phone;
    private String address;
    private String roleName;
}