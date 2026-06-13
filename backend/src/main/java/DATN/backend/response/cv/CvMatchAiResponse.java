package DATN.backend.response.cv;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Maps the snake_case JSON returned by the AI service POST /match endpoint.
 */
@Getter
@Setter
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class CvMatchAiResponse {

    @JsonProperty("passed_filter")
    private boolean passedFilter;

    @JsonProperty("match_score")
    private double matchScore;

    @JsonProperty("scoring_method")
    private String scoringMethod;

    private String reason;

    @JsonProperty("model_used")
    private String modelUsed;

    private List<String> suggestions;

    @JsonProperty("per_field_scores")
    private Map<String, Double> perFieldScores;

    @JsonProperty("hard_filter")
    private HardFilter hardFilter;

    @Getter
    @Setter
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class HardFilter {
        private boolean passed;
        private List<String> reasons;

        @JsonProperty("candidate_years")
        private double candidateYears;

        @JsonProperty("required_years")
        private double requiredYears;
    }
}
