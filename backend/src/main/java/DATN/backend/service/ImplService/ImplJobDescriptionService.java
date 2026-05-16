package DATN.backend.service.ImplService;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.JobDescriptionMapper;
//import DATN.backend.model.ApplicantJobDescription;
import DATN.backend.model.JobDescription;
import DATN.backend.model.Recruiter;
import DATN.backend.repository.ApplicantJobDescriptionRepository;
import DATN.backend.repository.JobDescriptionRepository;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobDescriptionResponse;
import DATN.backend.service.InterfaceService.InterfaceJobDescriptionService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplJobDescriptionService implements InterfaceJobDescriptionService {

        private final JobDescriptionRepository jobDescriptionRepository;
        private final RecruiterRepository recruiterRepository;
        private final ApplicantJobDescriptionRepository applicantJobDescriptionRepository;
        private final JobDescriptionMapper jobDescriptionMapper = new JobDescriptionMapper();

        @Override
        public ApiResponse getAllJobs() {
                List<JobDescriptionResponse> response = jobDescriptionRepository.findAll().stream()
                                .map(jobDescriptionMapper::toResponse)
                                .toList();
                return new ApiResponse("Jobs found", HttpStatus.OK.value(), null, null, response);
        }

        @Override
        public ApiResponse getJobById(Long jobId) {
                JobDescription jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                return new ApiResponse("Job found", HttpStatus.OK.value(), null, null,
                                jobDescriptionMapper.toResponse(jobDescription));
        }

        @Override
        public ApiResponse getJobApplicantsCount(Long jobId, Long recruiterId) {
                JobDescription jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (recruiterId != null && (jobDescription.getRecruiter() == null
                                || !jobDescription.getRecruiter().getId().equals(recruiterId))) {
                        throw new AlreadyExistException("Only posting recruiter can access this resource");
                }
                Long count = applicantJobDescriptionRepository.findAll().stream()
                                .filter(relation -> relation.getJobDescription() != null
                                                && relation.getJobDescription().getId().equals(jobId))
                                .count();
                JobApplicantsResponse response = jobDescriptionMapper.toApplicantsResponse(jobId, count);
                return new ApiResponse("Applicant count found", HttpStatus.OK.value(), null, null, response);
        }

        @Override
        public ApiResponse getJobsByRecruiter(Long recruiterId) {
                if (!recruiterRepository.existsById(recruiterId)) {
                        throw new ResourcesNotFoundException("Recruiter not found");
                }
                List<JobDescriptionResponse> response = jobDescriptionRepository.findByRecruiter_Id(recruiterId)
                                .stream()
                                .map(jobDescriptionMapper::toResponse)
                                .toList();
                return new ApiResponse("Recruiter jobs found", HttpStatus.OK.value(), null, null, response);
        }

        @Override
        @Transactional
        public ApiResponse createJob(Long recruiterId, RecruiterJobRequest request) {
                Recruiter recruiter = recruiterRepository.findById(recruiterId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
                JobDescription jobDescription = jobDescriptionMapper.toNewJobDescription(recruiter, request);
                JobDescription savedJob = jobDescriptionRepository.save(jobDescription);
                return new ApiResponse("Job created successfully", HttpStatus.CREATED.value(), null, null,
                                jobDescriptionMapper.toResponse(savedJob));
        }

        @Override
        @Transactional
        public ApiResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request) {
                Recruiter recruiter = recruiterRepository.findById(recruiterId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
                JobDescription jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (jobDescription.getRecruiter() != null
                                && !jobDescription.getRecruiter().getId().equals(recruiter.getId())) {
                        throw new AlreadyExistException("Only posting recruiter can edit this job");
                }
                jobDescriptionMapper.updateJobDescription(jobDescription, request);
                jobDescription.setRecruiter(recruiter);
                JobDescription savedJob = jobDescriptionRepository.save(jobDescription);
                return new ApiResponse("Job updated successfully", HttpStatus.OK.value(), null, null,
                                jobDescriptionMapper.toResponse(savedJob));
        }
}