package DATN.backend.service.InterfaceService;

import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.response.applicant.CvJobMatchResponse;

/**
 * Matches an applicant's stored CV against a job description via the AI service.
 */
public interface InterfaceCvMatchService {

    /**
     * Scores the applicant's CV against a job and returns suggestions.
     *
     * @param applicantId applicant owner identifier
     * @param jobId job description identifier
     * @param request matching options (LLM toggle, scoring method)
     * @return match score, reason, and improvement suggestions
     */
    CvJobMatchResponse matchApplicantToJob(Long applicantId, Long jobId, CvJobMatchRequest request);
}
