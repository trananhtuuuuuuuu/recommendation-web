package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobApplicantResponse;
import DATN.backend.response.job.JobResponse;

import java.util.List;

public interface InterfaceJobService {

    List<JobResponse> getAllJobs();

    JobResponse getJobById(Long jobId);

    JobApplicantsResponse getJobApplicantsCount(Long jobId, Long recruiterId);

    List<JobApplicantResponse> getJobApplicants(Long jobId, Long recruiterId);

    List<JobResponse> getJobsByRecruiter(Long recruiterId);

    JobResponse createJob(Long recruiterId, RecruiterJobRequest request);

    JobResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request);
}
