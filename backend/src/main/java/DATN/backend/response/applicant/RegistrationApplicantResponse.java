package DATN.backend.response.applicant;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RegistrationApplicantResponse {
    private String userName;
    private String email;
    private String fullName;
    private String phone;
    private String address;
    private String gender;
    private String status;
    private String roleName;
    private String cvUrl;
}
