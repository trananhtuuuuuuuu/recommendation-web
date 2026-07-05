package DATN.backend.response.job;

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
}
