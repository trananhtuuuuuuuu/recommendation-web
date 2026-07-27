package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobApplicantResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.response.job.RecruiterApplicantMatchResponse;
import DATN.backend.response.job.RecruiterCandidateMatchResponse;
import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.response.applicant.CvJobMatchResponse;
import DATN.backend.response.PageResponse;

import java.util.List;

import org.springframework.data.domain.Pageable;

public interface InterfaceJobService {

    List<JobResponse> getAllJobs();

    PageResponse<JobResponse> getAllJobs(Pageable pageable);

    JobResponse getJobById(Long jobId);

    JobApplicantsResponse getJobApplicantsCount(Long jobId, Long recruiterId);

    List<JobApplicantResponse> getJobApplicants(Long jobId, Long recruiterId);

    /**
     * Scores every applicant for a recruiter-owned job and returns a descending
     * ranking by the unmodified AI match score.
     *
     * @param jobId job identifier
     * @param recruiterId posting recruiter identifier
     * @param request AI matching options
     * @return candidates sorted from highest to lowest match percentage
     */
    List<RecruiterApplicantMatchResponse> matchJobApplicants(Long jobId, Long recruiterId,
            CvJobMatchRequest request);

    /**
     * Scores one submitted applicant for a recruiter-owned job.
     *
     * @param jobId job identifier
     * @param recruiterId posting recruiter identifier
     * @param applicantId submitted applicant identifier
     * @param request AI matching options
     * @return match result with the stable application order
     */
    RecruiterApplicantMatchResponse matchJobApplicant(Long jobId, Long recruiterId, Long applicantId,
            CvJobMatchRequest request);

    /**
     * Scores open-to-work applicants with CVs against a published job.
     *
     * @param jobId job identifier
     * @param recruiterId posting recruiter identifier
     * @param request AI matching options
     * @param limit maximum number of ranked candidates to return
     * @return candidates sorted from highest to lowest match percentage
     */
    List<RecruiterCandidateMatchResponse> recommendCandidates(Long jobId, Long recruiterId,
            CvJobMatchRequest request, int limit);

    /**
     * Generates an explainable AI match for one eligible recommended candidate.
     *
     * @param jobId job identifier
     * @param recruiterId posting recruiter identifier
     * @param applicantId recommended applicant identifier
     * @param request AI matching options
     * @return match score, reason, field scores, and suggestions
     */
    CvJobMatchResponse getRecommendedCandidateSuggestion(
            Long jobId, Long recruiterId, Long applicantId, CvJobMatchRequest request);

    List<JobResponse> getJobsByRecruiter(Long recruiterId);

    JobResponse createJob(Long recruiterId, RecruiterJobRequest request);

    JobResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request);
}
