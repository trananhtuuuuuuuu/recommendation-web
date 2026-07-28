package DATN.backend.request.recruiter;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * English certificate requirement entered by a recruiter.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "An accepted English certificate and its required score")
public class EnglishCertificateRequirementRequest {

    @NotBlank(message = "English certificate name cannot be blank")
    @Schema(example = "IELTS Academic")
    private String certificateName;

    @NotBlank(message = "English certificate score cannot be blank")
    @Schema(example = "6.5 overall, no band below 6.0")
    private String minimumScore;
}
