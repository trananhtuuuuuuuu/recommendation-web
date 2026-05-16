package DATN.backend.service.ImplService;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.ApplicantMapper;
import DATN.backend.model.Applicant;
import DATN.backend.model.ApplicantJobDescription;
import DATN.backend.model.Cv;
import DATN.backend.model.JobDescription;
import DATN.backend.model.Role;
import DATN.backend.repository.ApplicantJobDescriptionRepository;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.CvRepository;
import DATN.backend.repository.JobDescriptionRepository;
import DATN.backend.repository.RoleRepository;
import DATN.backend.repository.UserRepository;
import DATN.backend.request.applicant.RegistrationApplicantRequest;
import DATN.backend.request.applicant.SaveJobRequest;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.response.applicant.ApplicantResponse;
import DATN.backend.response.applicant.SavedJobResponse;
import DATN.backend.response.applicant.RegistrationApplicantResponse;
import DATN.backend.response.cv.CvResponse;
import DATN.backend.service.InterfaceService.InterfaceApplicantService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplApplicantService implements InterfaceApplicantService {

    private final ApplicantRepository applicantRepository;
    private final ApplicantJobDescriptionRepository applicantJobDescriptionRepository;
    private final JobDescriptionRepository jobDescriptionRepository;
    private final CvRepository cvRepository;
    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public RegistrationApplicantResponse registerApplicant(RegistrationApplicantRequest request) {
        if (userRepository.findByUserName(request.getUserName()).isPresent()) {
            throw new AlreadyExistException("User name already exists");
        }
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new AlreadyExistException("Email already exists");
        }

        Role role = roleRepository.findByRoleName(request.getRoleName())
                .orElseGet(() -> roleRepository.save(new Role(request.getRoleName(), request.getRoleName())));

        Applicant applicant = ApplicantMapper.toNewApplicant(request);
        applicant.setPassword(passwordEncoder.encode(request.getPassword()));
        applicant.setRole(role);

        Applicant savedApplicant = applicantRepository.save(applicant);
        return ApplicantMapper.toRegistrationResponse(savedApplicant);
    }

    @Override
    public ApplicantResponse getApplicantById(Long applicantId) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        return ApplicantMapper.toApplicantResponse(applicant);
    }

    @Override
    public List<ApplicantResponse> getAllApplicants() {
        return applicantRepository.findAll().stream()
                .map(ApplicantMapper::toApplicantResponse)
                .toList();
    }

    @Override
    @Transactional
    public ApplicantResponse updateApplicant(Long applicantId, UpdateApplicantRequest request) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        ApplicantMapper.updateApplicant(applicant, request);
        Applicant savedApplicant = applicantRepository.save(applicant);
        return ApplicantMapper.toApplicantResponse(savedApplicant);
    }

    @Override
    @Transactional
    public SavedJobResponse saveJob(SaveJobRequest request) {
        Applicant applicant = applicantRepository.findById(request.getApplicantId())
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        JobDescription jobDescription = jobDescriptionRepository.findById(request.getJobDescriptionId())
                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));

        applicantJobDescriptionRepository.findByApplicant_IdAndJobDescription_Id(request.getApplicantId(),
                request.getJobDescriptionId())
                .ifPresent(existing -> {
                    throw new AlreadyExistException("Job already saved by this applicant");
                });

        ApplicantJobDescription relation = applicantJobDescriptionRepository
                .save(new ApplicantJobDescription(applicant, jobDescription));

        return new SavedJobResponse(
                relation.getId(),
                applicant.getId(),
                jobDescription.getId(),
                jobDescription.getJobTitle(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getCompanyName(),
                jobDescription.getLocation());
    }

    @Override
    public List<SavedJobResponse> getSavedJobs(Long applicantId) {
        if (!applicantRepository.existsById(applicantId)) {
            throw new ResourcesNotFoundException("Applicant not found");
        }
        return applicantJobDescriptionRepository.findByApplicant_Id(applicantId).stream()
                .map(relation -> new SavedJobResponse(
                        relation.getId(),
                        relation.getApplicant().getId(),
                        relation.getJobDescription().getId(),
                        relation.getJobDescription().getJobTitle(),
                        relation.getJobDescription().getRecruiter() == null ? null
                                : relation.getJobDescription().getRecruiter().getCompanyName(),
                        relation.getJobDescription().getLocation()))
                .toList();
    }

    @Override
    @Transactional
    public CvResponse uploadCv(Long applicantId, UploadCvRequest request) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        Cv cv = ApplicantMapper.toCv(request);
        Cv savedCv = cvRepository.save(cv);
        applicant.setCv(savedCv);
        applicantRepository.save(applicant);
        return ApplicantMapper.toCvResponse(savedCv);
    }
}
