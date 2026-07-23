package DATN.backend.request.applicant;

import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Carries editable applicant profile fields.
 *
 * <p>Phone numbers may retain common human-readable formatting, including a
 * leading zero, country or area codes, spaces, parentheses, dots, and
 * hyphens.</p>
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UpdateApplicantRequest {

    private static final String PHONE_NUMBER_PATTERN =
            "^$|^(?=(?:\\D*\\d){7,15}\\D*$)[+\\d(][\\d\\s()+.\\-]*$";

    private String address;

    private String email;

    @Pattern(regexp = PHONE_NUMBER_PATTERN, message = "Invalid phone number")
    private String phone;

    private String userName;

    private String fullName;

    private String gender;
    private String status;
}
