package DATN.backend.request.applicant;

import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UpdateApplicantRequest {

    private String address;

    private String email;

    @Pattern(regexp = "^$|^\\+?[0-9]{8,15}$", message = "Invalid phone number")
    private String phone;

    private String userName;

    private String fullName;

    private String gender;
    private String status;
}
