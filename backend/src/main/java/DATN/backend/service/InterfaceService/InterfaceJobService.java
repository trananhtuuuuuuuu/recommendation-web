package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobApplicantResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.response.PageResponse;

import java.util.List;

import org.springframework.data.domain.Pageable;

public interface InterfaceJobService {

    List<JobResponse> getAllJobs();

    PageResponse<JobResponse> getAllJobs(Pageable pageable);

    JobResponse getJobById(Long jobId);

    JobApplicantsResponse getJobApplicantsCount(Long jobId, Long recruiterId);

    List<JobApplicantResponse> getJobApplicants(Long jobId, Long recruiterId);

    List<JobResponse> getJobsByRecruiter(Long recruiterId);

    JobResponse createJob(Long recruiterId, RecruiterJobRequest request);

    JobResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request);
}
