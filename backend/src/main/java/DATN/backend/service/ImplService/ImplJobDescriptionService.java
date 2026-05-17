package DATN.backend.service.ImplService;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.ApplicantMapper;
import DATN.backend.mapper.JobDescriptionMapper;
//import DATN.backend.model.ApplicantJobDescription;
import DATN.backend.model.JobDescription;
import DATN.backend.model.Recruiter;
import DATN.backend.repository.ApplicantJobDescriptionRepository;
import DATN.backend.repository.JobDescriptionRepository;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobApplicantResponse;
import DATN.backend.response.job.JobDescriptionResponse;
import DATN.backend.service.InterfaceService.InterfaceJobDescriptionService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplJobDescriptionService implements InterfaceJobDescriptionService {

        private static final String APPLIED_ACTION = "APPLIED";

        private final JobDescriptionRepository jobDescriptionRepository;
        private final RecruiterRepository recruiterRepository;
        private final ApplicantJobDescriptionRepository applicantJobDescriptionRepository;

        @Override
        public List<JobDescriptionResponse> getAllJobs() {
                return jobDescriptionRepository.findAll().stream()
                                .map(JobDescriptionMapper::toResponse)
                                .toList();
        }

        @Override
        public JobDescriptionResponse getJobById(Long jobId) {
                JobDescription jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                return JobDescriptionMapper.toResponse(jobDescription);
        }

        @Override
        public JobApplicantsResponse getJobApplicantsCount(Long jobId, Long recruiterId) {
                JobDescription jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (recruiterId != null && (jobDescription.getRecruiter() == null
                                || !jobDescription.getRecruiter().getId().equals(recruiterId))) {
                        throw new AlreadyExistException("Only posting recruiter can access this resource");
                }
                Long count = applicantJobDescriptionRepository.countByJobDescription_IdAndActionType(jobId,
                                APPLIED_ACTION);
                return JobDescriptionMapper.toApplicantsResponse(jobId, count);
        }

        @Override
        public List<JobApplicantResponse> getJobApplicants(Long jobId, Long recruiterId) {
                JobDescription jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (recruiterId != null && (jobDescription.getRecruiter() == null
                                || !jobDescription.getRecruiter().getId().equals(recruiterId))) {
                        throw new AlreadyExistException("Only posting recruiter can access this resource");
                }
                return applicantJobDescriptionRepository.findByJobDescription_IdAndActionType(jobId, APPLIED_ACTION)
                                .stream()
                                .map(relation -> new JobApplicantResponse(
                                                relation.getId(),
                                                jobId,
                                                ApplicantMapper.toApplicantResponse(relation.getApplicant()),
                                                relation.getCoverLetter(),
                                                relation.getPortfolioUrl(),
                                                relation.getApplicationAnswers()))
                                .toList();
        }

        @Override
        public List<JobDescriptionResponse> getJobsByRecruiter(Long recruiterId) {
                if (!recruiterRepository.existsById(recruiterId)) {
                        throw new ResourcesNotFoundException("Recruiter not found");
                }
                return jobDescriptionRepository.findByRecruiter_Id(recruiterId)
                                .stream()
                                .map(JobDescriptionMapper::toResponse)
                                .toList();
        }

        @Override
        @Transactional
        public JobDescriptionResponse createJob(Long recruiterId, RecruiterJobRequest request) {
                Recruiter recruiter = recruiterRepository.findById(recruiterId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
                JobDescription jobDescription = JobDescriptionMapper.toNewJobDescription(recruiter, request);
                JobDescription savedJob = jobDescriptionRepository.save(jobDescription);
                return JobDescriptionMapper.toResponse(savedJob);
        }

        @Override
        @Transactional
        public JobDescriptionResponse updateJob(Long recruiterId, Long jobId, RecruiterJobRequest request) {
                Recruiter recruiter = recruiterRepository.findById(recruiterId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
                JobDescription jobDescription = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (jobDescription.getRecruiter() != null
                                && !jobDescription.getRecruiter().getId().equals(recruiter.getId())) {
                        throw new AlreadyExistException("Only posting recruiter can edit this job");
                }
                JobDescriptionMapper.updateJobDescription(jobDescription, request);
                jobDescription.setRecruiter(recruiter);
                JobDescription savedJob = jobDescriptionRepository.save(jobDescription);
                return JobDescriptionMapper.toResponse(savedJob);
        }
}
