package DATN.backend.service.ImplService;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.ApplicantMapper;
import DATN.backend.mapper.JobMapper;
//import DATN.backend.model.ApplicantJob;
import DATN.backend.model.Job;
import DATN.backend.model.Recruiter;
import DATN.backend.repository.ApplicantJobRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobApplicantResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.service.InterfaceService.InterfaceJobService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplJobService implements InterfaceJobService {

        private static final String APPLIED_ACTION = "APPLIED";

        private final JobRepository jobDescriptionRepository;
        private final RecruiterRepository recruiterRepository;
        private final ApplicantJobRepository applicantJobRepository;

        @Override
        public List<JobResponse> getAllJobs() {
                return jobDescriptionRepository.findAll().stream()
                                .map(JobMapper::toResponse)
                                .toList();
        }

        @Override
        public JobResponse getJobById(Long jobId) {
                Job jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                return JobMapper.toResponse(jobDescription);
        }

        @Override
        public JobApplicantsResponse getJobApplicantsCount(Long jobId, Long recruiterId) {
                Job jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (recruiterId != null && (jobDescription.getRecruiter() == null
                                || !jobDescription.getRecruiter().getId().equals(recruiterId))) {
                        throw new AlreadyExistException("Only posting recruiter can access this resource");
                }
                Long count = applicantJobRepository.countByJob_IdAndActionType(jobId,
                                APPLIED_ACTION);
                return JobMapper.toApplicantsResponse(jobId, count);
        }

        @Override
        public List<JobApplicantResponse> getJobApplicants(Long jobId, Long recruiterId) {
                Job jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (recruiterId != null && (jobDescription.getRecruiter() == null
                                || !jobDescription.getRecruiter().getId().equals(recruiterId))) {
                        throw new AlreadyExistException("Only posting recruiter can access this resource");
                }
                return applicantJobRepository.findByJob_IdAndActionType(jobId, APPLIED_ACTION)
                                .stream()
                                .map(relation -> new JobApplicantResponse(
                                                relation.getId(),
                                                jobId,
                                                ApplicantMapper.toApplicantResponse(relation.getApplicant()),
                                                null,
                                                null,
                                                null))
                                .toList();
        }

        @Override
        public List<JobResponse> getJobsByRecruiter(Long recruiterId) {
                if (!recruiterRepository.existsById(recruiterId)) {
                        throw new ResourcesNotFoundException("Recruiter not found");
                }
                return jobDescriptionRepository.findByRecruiter_Id(recruiterId)
                                .stream()
                                .map(JobMapper::toResponse)
                                .toList();
        }

        @Override
        @Transactional
        public JobResponse createJob(Long recruiterId, RecruiterJobRequest request) {
                Recruiter recruiter = recruiterRepository.findById(recruiterId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
                Job jobDescription = JobMapper.toNewJob(recruiter, request);
                Job savedJob = jobDescriptionRepository.save(jobDescription);
                return JobMapper.toResponse(savedJob);
        }

        @Override
        @Transactional
        public JobResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request) {
                Recruiter recruiter = recruiterRepository.findById(recruiterId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
                Job jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (jobDescription.getRecruiter() != null
                                && !jobDescription.getRecruiter().getId().equals(recruiter.getId())) {
                        throw new AlreadyExistException("Only posting recruiter can edit this job");
                }
                JobMapper.updateJob(jobDescription, request);
                jobDescription.setRecruiter(recruiter);
                Job savedJob = jobDescriptionRepository.save(jobDescription);
                return JobMapper.toResponse(savedJob);
        }
}
