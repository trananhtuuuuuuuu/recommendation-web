package DATN.backend.response.job;

import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Structured language requirement returned for a job.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "A language, its required proficiency, skills, and optional certificates")
public class LanguageRequirementResponse {
    private String languageName;
    private String proficiencyLevel;
    private List<String> skills;
    private List<LanguageCertificateRequirementResponse> certificates;
}
