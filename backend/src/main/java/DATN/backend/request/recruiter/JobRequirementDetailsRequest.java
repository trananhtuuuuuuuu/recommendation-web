package DATN.backend.request.recruiter;

import java.util.List;

import DATN.backend.Enum.JobDegreeEnum;
import DATN.backend.Enum.JobEducationRequirementModeEnum;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Structured matching requirements supplied by a recruiter for a job.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Structured job requirements used for CV matching")
public class JobRequirementDetailsRequest {

    @NotNull(message = "Education requirement mode must be selected")
    @Schema(example = "ANY_OF")
    private JobEducationRequirementModeEnum educationMode;

    @NotNull(message = "Degrees must be provided, or use an empty list when education is not required")
    @Schema(example = "[\"BACHELOR\", \"MASTER\"]")
    private List<JobDegreeEnum> degrees;

    @Schema(example = "Currently studying or has equivalent professional training")
    private String noDegreeRequirement;

    @NotNull(message = "Education majors must be provided, or use an empty list when education is not required")
    @Schema(example = "[\"Computer Science\", \"Software Engineering\"]")
    private List<@NotBlank(message = "Education major cannot be blank") String> educationMajors;

    @NotNull(message = "Preferred institutions must be provided, or use an empty list")
    @Schema(example = "[\"HCMUS\"]")
    private List<@NotBlank(message = "Preferred institution cannot be blank") String> preferredInstitutions;

    @NotNull(message = "Minimum years of experience is required")
    @PositiveOrZero(message = "Minimum years of experience cannot be negative")
    @Schema(example = "3")
    private Integer minimumYearsExperience;

    @NotEmpty(message = "At least one expected experience item is required")
    @Schema(example = "[\"Built production REST APIs\", \"Worked in a cross-functional team\"]")
    private List<@NotBlank(message = "Expected experience item cannot be blank") String> experienceRequirements;

    @NotEmpty(message = "At least one required skill is required")
    @Schema(example = "[\"Java\", \"System design\", \"Debugging\"]")
    private List<@NotBlank(message = "Required skill cannot be blank") String> requiredSkills;

    @NotEmpty(message = "At least one technology in the tech stack is required")
    @Schema(example = "[\"Spring Boot\", \"PostgreSQL\", \"Docker\"]")
    private List<@NotBlank(message = "Tech stack item cannot be blank") String> techStack;

    @NotNull(message = "English requirement must be explicitly selected")
    @Schema(example = "true")
    private Boolean englishRequired;

    @Schema(example = "Upper-intermediate")
    private String englishLevel;

    @NotNull(message = "English skills must be provided, or use an empty list")
    @Schema(example = "[\"Speaking\", \"Reading technical documentation\"]")
    private List<@NotBlank(message = "English skill cannot be blank") String> englishSkills;

    @Valid
    @NotNull(message = "English certificates must be provided, or use an empty list")
    private List<EnglishCertificateRequirementRequest> englishCertificates;

    @NotNull(message = "Tools must be provided, or use an empty list")
    @Schema(example = "[\"Git\", \"Jira\", \"Postman\"]")
    private List<@NotBlank(message = "Tool cannot be blank") String> tools;

    @NotNull(message = "Technical knowledge must be provided, or use an empty list")
    @Schema(example = "[\"REST API\", \"CI/CD\", \"Microservices\"]")
    private List<@NotBlank(message = "Technical knowledge item cannot be blank") String> technicalKnowledge;

    /**
     * Checks the selected degrees and majors for the chosen education mode.
     *
     * @return {@code true} when the education selection is internally consistent
     */
    @AssertTrue(message = "Provide a no-degree applicant expectation, or select valid degrees and at least one major")
    @Schema(hidden = true)
    public boolean isEducationRequirementValid() {
        if (educationMode == null || degrees == null) {
            return true;
        }
        if (educationMode == JobEducationRequirementModeEnum.NOT_REQUIRED) {
            return degrees.isEmpty()
                    && noDegreeRequirement != null
                    && !noDegreeRequirement.isBlank();
        }
        if (educationMajors == null || educationMajors.isEmpty()) {
            return false;
        }
        return educationMode == JobEducationRequirementModeEnum.ANY_OF
                ? !degrees.isEmpty()
                : degrees.size() == 1;
    }

    /**
     * Checks the conditional English level and skill requirements.
     *
     * @return {@code true} when English is not required or its details are complete
     */
    @AssertTrue(message = "English level and at least one English skill are required when English is required")
    @Schema(hidden = true)
    public boolean isEnglishRequirementValid() {
        return englishRequired == null
                || !englishRequired
                || (englishLevel != null && !englishLevel.isBlank()
                        && englishSkills != null && !englishSkills.isEmpty());
    }

    /**
     * Checks that the recruiter explicitly supplies at least one tool or technical
     * area.
     *
     * @return {@code true} when a tool or technical knowledge item exists
     */
    @AssertTrue(message = "At least one tool or technical knowledge item is required")
    @Schema(hidden = true)
    public boolean isToolsAndTechnicalKnowledgeValid() {
        return (tools != null && !tools.isEmpty())
                || (technicalKnowledge != null && !technicalKnowledge.isEmpty());
    }
}
