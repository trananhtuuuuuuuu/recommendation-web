package DATN.backend.request.recruiter;

import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * One language requirement entered by a recruiter.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "A language, its required proficiency, skills, and optional certificates")
public class LanguageRequirementRequest {

    @NotBlank(message = "Language name cannot be blank")
    @Schema(example = "Japanese")
    private String languageName;

    @NotBlank(message = "Required language proficiency cannot be blank")
    @Schema(example = "JLPT N2 or business conversational")
    private String proficiencyLevel;

    @NotEmpty(message = "At least one language skill is required")
    @Schema(example = "[\"Speaking\", \"Reading technical documents\"]")
    private List<@NotBlank(message = "Language skill cannot be blank") String> skills;

    @NotNull(message = "Language certificates must be provided, or use an empty list")
    private List<@Valid LanguageCertificateRequirementRequest> certificates;
}
