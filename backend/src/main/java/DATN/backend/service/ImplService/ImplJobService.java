package DATN.backend.service.ImplService;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.ApplicantMapper;
import DATN.backend.mapper.JobMapper;
import DATN.backend.model.ApplicantJob;
import DATN.backend.model.Job;
import DATN.backend.model.Recruiter;
import DATN.backend.repository.ApplicantJobRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.response.applicant.CvJobMatchResponse;
import DATN.backend.response.PageResponse;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobApplicantResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.response.job.RecruiterApplicantMatchResponse;
import DATN.backend.service.InterfaceService.InterfaceCvMatchService;
import DATN.backend.service.InterfaceService.InterfaceJobService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplJobService implements InterfaceJobService {

        private static final String APPLIED_ACTION = "APPLIED";

        private final JobRepository jobDescriptionRepository;
        private final RecruiterRepository recruiterRepository;
        private final ApplicantJobRepository applicantJobRepository;
        private final InterfaceCvMatchService cvMatchService;

        @Override
        public List<JobResponse> getAllJobs() {
                return jobDescriptionRepository.findAll().stream()
                                .map(JobMapper::toResponse)
                                .toList();
        }

        @Override
        public PageResponse<JobResponse> getAllJobs(Pageable pageable) {
                return PageResponse.from(jobDescriptionRepository.findAll(pageable)
                                .map(JobMapper::toResponse));
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
                List<ApplicantJob> applications = applicantJobRepository.findByJob_IdAndActionTypeOrderByIdAsc(jobId,
                                APPLIED_ACTION);
                return java.util.stream.IntStream.range(0, applications.size())
                                .mapToObj(index -> toJobApplicantResponse(applications.get(index), jobId, index + 1))
                                .toList();
        }

        private JobApplicantResponse toJobApplicantResponse(ApplicantJob relation, Long jobId, int applicationOrder) {
                return new JobApplicantResponse(
                                relation.getId(),
                                applicationOrder,
                                jobId,
                                ApplicantMapper.toRecruiterVisibleApplicantResponse(relation.getApplicant()),
                                relation.getCoverLetter(),
                                relation.getPortfolioUrl(),
                                relation.getApplicationAnswers());
        }

        /**
         * {@inheritDoc}
         */
        @Override
        @Transactional(readOnly = true)
        public List<RecruiterApplicantMatchResponse> matchJobApplicants(Long jobId, Long recruiterId,
                        CvJobMatchRequest request) {
                verifyPostingRecruiter(jobId, recruiterId);
                List<ApplicantJob> applications = applicantJobRepository
                                .findByJob_IdAndActionTypeOrderByIdAsc(jobId, APPLIED_ACTION);
                CvJobMatchRequest options = request == null ? new CvJobMatchRequest() : request;

                return java.util.stream.IntStream.range(0, applications.size())
                                .mapToObj(index -> toRecruiterMatch(applications.get(index), jobId, index + 1, options))
                                .sorted(java.util.Comparator
                                                .comparingInt((RecruiterApplicantMatchResponse item) -> item.getMatch()
                                                                .getMatchPercent())
                                                .reversed()
                                                .thenComparingInt(RecruiterApplicantMatchResponse::getApplicationOrder))
                                .toList();
        }

        private RecruiterApplicantMatchResponse toRecruiterMatch(ApplicantJob relation, Long jobId,
                        int applicationOrder, CvJobMatchRequest request) {
                CvJobMatchResponse match;
                if (relation.getApplicant().getCv() == null) {
                        match = new CvJobMatchResponse(
                                        relation.getApplicant().getId(), jobId, false, 0.0, 0,
                                        "This candidate has not uploaded a CV for AI matching.",
                                        List.of(), java.util.Map.of(), List.of("CV is not available"),
                                        request.getMethod(), null, false, null, null, null);
                } else {
                        match = cvMatchService.matchApplicantToJob(relation.getApplicant().getId(), jobId, request);
                }
                return new RecruiterApplicantMatchResponse(
                                relation.getId(),
                                applicationOrder,
                                ApplicantMapper.toRecruiterVisibleApplicantResponse(relation.getApplicant()),
                                match);
        }

        private Job verifyPostingRecruiter(Long jobId, Long recruiterId) {
                Job job = jobDescriptionRepository.findById(jobId)
                                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
                if (job.getRecruiter() == null || !job.getRecruiter().getId().equals(recruiterId)) {
                        throw new AlreadyExistException("Only posting recruiter can access this resource");
                }
                return job;
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
