package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobApplicantResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.response.job.RecruiterApplicantMatchResponse;
import DATN.backend.request.applicant.CvJobMatchRequest;
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

    List<JobResponse> getJobsByRecruiter(Long recruiterId);

    JobResponse createJob(Long recruiterId, RecruiterJobRequest request);

    JobResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request);
}
