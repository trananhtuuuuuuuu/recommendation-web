package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobDescriptionResponse;

import java.util.List;

public interface InterfaceJobDescriptionService {

    List<JobDescriptionResponse> getAllJobs();

    JobDescriptionResponse getJobById(Long jobId);

    JobApplicantsResponse getJobApplicantsCount(Long jobId, Long recruiterId);

    List<JobDescriptionResponse> getJobsByRecruiter(Long recruiterId);

    JobDescriptionResponse createJob(Long recruiterId, RecruiterJobRequest request);

    JobDescriptionResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request);
}
