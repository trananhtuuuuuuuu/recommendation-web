package DATN.backend.response.job;

import DATN.backend.response.applicant.ApplicantResponse;
import DATN.backend.response.applicant.CvJobMatchResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Represents one applied candidate in a recruiter-owned AI ranking.
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RecruiterApplicantMatchResponse {

    private Long applicationId;
    private int applicationOrder;
    private ApplicantResponse applicant;
    private CvJobMatchResponse match;
}
