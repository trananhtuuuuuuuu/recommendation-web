package DATN.backend.response.job;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * English certificate requirement displayed for a job.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "An accepted English certificate and its required score")
public class EnglishCertificateRequirementResponse {
    private String certificateName;
    private String minimumScore;
}
