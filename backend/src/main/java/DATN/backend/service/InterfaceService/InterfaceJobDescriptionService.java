package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.ApiResponse;

public interface InterfaceJobDescriptionService {

    ApiResponse getAllJobs();

    ApiResponse getJobById(Long jobId);

    ApiResponse getJobApplicantsCount(Long jobId, Long recruiterId);

    ApiResponse getJobsByRecruiter(Long recruiterId);

    ApiResponse createJob(Long recruiterId, RecruiterJobRequest request);

    ApiResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request);
}