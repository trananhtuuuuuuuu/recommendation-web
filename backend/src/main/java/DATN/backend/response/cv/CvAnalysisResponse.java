package DATN.backend.response.cv;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Applicant profile fields suggested by the CV analysis service.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CvAnalysisResponse {
    private String fullName;
    private String detectedEmail;
    private String phone;
    private String address;
    private String objective;
    private List<String> skills;
    private List<CvExperienceResponse> experience;
    private List<String> education;
    private List<String> certifications;
    private String extractionMode;
    private Double confidence;
    private List<String> warnings;
}
