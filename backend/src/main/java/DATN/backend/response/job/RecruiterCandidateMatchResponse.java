package DATN.backend.response.job;

import DATN.backend.response.applicant.ApplicantResponse;
import DATN.backend.response.applicant.CvJobMatchResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Represents one candidate in a recruiter-owned job recommendation ranking.
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RecruiterCandidateMatchResponse {

    private int rank;
    private ApplicantResponse applicant;
    private CvJobMatchResponse match;
}
