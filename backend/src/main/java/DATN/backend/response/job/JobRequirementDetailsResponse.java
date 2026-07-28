package DATN.backend.response.job;

import java.util.List;

import DATN.backend.Enum.JobDegreeEnum;
import DATN.backend.Enum.JobEducationRequirementModeEnum;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Structured job requirements returned to clients and the matching pipeline.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Structured job requirements used for CV matching")
public class JobRequirementDetailsResponse {
    private JobEducationRequirementModeEnum educationMode;
    private List<JobDegreeEnum> degrees;
    private String noDegreeRequirement;
    private List<String> educationMajors;
    private List<String> preferredInstitutions;
    private Integer minimumYearsExperience;
    private List<String> experienceRequirements;
    private List<String> requiredSkills;
    private List<String> techStack;
    private Boolean englishRequired;
    private String englishLevel;
    private List<String> englishSkills;
    private List<EnglishCertificateRequirementResponse> englishCertificates;
    private List<String> tools;
    private List<String> technicalKnowledge;
}
