package DATN.backend.request.applicant;

import jakarta.validation.constraints.NotBlank;
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

    @NotBlank(message = "Address is required")
    private String address;

    @NotBlank(message = "Email is required")
    private String email;

    @Pattern(regexp = "^$|^\\+[1-9]\\d{1,14}$", message = "Invalid phone number")
    private String phone;

    @NotBlank(message = "User name is required")
    private String userName;

    @NotBlank(message = "Full name is required")
    private String fullName;

    private String gender;
    private String status;
}