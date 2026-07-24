package DATN.backend.request.applicant;

import jakarta.validation.constraints.NotBlank;
//import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RegistrationApplicantRequest {
    private String address;

    private String email;

    @NotBlank(message = "Password is required")
    private String password;

    // @Pattern(regexp = "^$|^\\+[1-9]\\d{1,14}$", message = "Invalid phone number.
    // Must start with '+' followed by the country code and number.")
    private String phone;

    @NotBlank(message = "User name is required")
    private String userName;

    private String fullName;

    private String gender = null;
    private String status = null;

    private String roleName = "APPLICANT";
}
