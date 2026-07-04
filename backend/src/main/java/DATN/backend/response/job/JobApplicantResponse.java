package DATN.backend.response.job;

import com.fasterxml.jackson.annotation.JsonProperty;

import DATN.backend.response.applicant.ApplicantResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class JobApplicantResponse {
    private Long applicationId;
    private Long jobDescriptionId;
    private ApplicantResponse applicant;
    private String coverLetter;
    private String portfolioUrl;
    private String applicationAnswers;
    @JsonProperty("kAnonymityApplied")
    private boolean kAnonymityApplied;
    @JsonProperty("kAnonymitySatisfied")
    private boolean kAnonymitySatisfied;
    private Integer anonymityGroupSize;
    private Integer anonymityK;
    private String privacyNotice;
}
