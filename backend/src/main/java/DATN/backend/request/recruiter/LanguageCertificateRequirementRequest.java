package DATN.backend.request.recruiter;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Certificate and recruiter-defined minimum result for a language requirement.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "An accepted language certificate and its required result")
public class LanguageCertificateRequirementRequest {

    @NotBlank(message = "Language certificate name cannot be blank")
    @Schema(example = "JLPT")
    private String certificateName;

    @NotBlank(message = "Language certificate score or requirement cannot be blank")
    @Schema(example = "N2")
    private String minimumScore;
}
