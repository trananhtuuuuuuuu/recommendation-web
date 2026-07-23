package DATN.backend.request.applicant;

import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Carries editable applicant profile fields.
 *
 * <p>Phone numbers retain common display formatting, including a leading zero,
 * country or area labels, spaces, parentheses, dots, and hyphens.</p>
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UpdateApplicantRequest {

    private String address;

    private String email;

    @Size(max = 50, message = "Phone number must not exceed 50 characters")
    @Pattern(
        regexp = "^$|^(?=(?:\\D*\\d){7,15}\\D*$)(?:[A-Za-z]{2,3}\\s+)?[+()\\d][+()\\d\\s.-]*$",
        message = "Invalid phone number")
    private String phone;

    private String userName;

    private String fullName;

    private String gender;
    private String status;
}
