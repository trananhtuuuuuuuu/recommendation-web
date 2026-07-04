package DATN.backend.response.applicant;

import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * CV-to-job match result returned to the client (score + explainable suggestions).
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CvJobMatchResponse {

    private Long applicantId;
    private Long jobId;
    private boolean passedFilter;
    private double matchScore;
    private int matchPercent;
    private String reason;
    private List<String> suggestions;
    private Map<String, Double> perFieldScores;
    private List<String> hardFilterReasons;
    private String scoringMethod;
    private String modelUsed;
    private boolean differentialPrivacyApplied;
    private Double privacyEpsilon;
    private Double scoreSensitivity;
    private String privacyMechanism;
}
