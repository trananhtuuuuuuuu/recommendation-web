package DATN.backend.service.ImplService;

import java.util.List;

import org.springframework.http.HttpStatus;
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
import DATN.backend.response.ApiResponse;
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
    private final ApplicantMapper applicantMapper = new ApplicantMapper();

    @Override
    @Transactional
    public ApiResponse registerApplicant(RegistrationApplicantRequest request) {
        if (userRepository.findByUserName(request.getUserName()).isPresent()) {
            throw new AlreadyExistException("User name already exists");
        }
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new AlreadyExistException("Email already exists");
        }

        Role role = roleRepository.findByRoleName(request.getRoleName())
                .orElseGet(() -> roleRepository.save(new Role(request.getRoleName(), request.getRoleName())));

        Applicant applicant = applicantMapper.toNewApplicant(request);
        applicant.setPassword(passwordEncoder.encode(request.getPassword()));
        applicant.setRole(role);

        Applicant savedApplicant = applicantRepository.save(applicant);
        RegistrationApplicantResponse response = applicantMapper.toRegistrationResponse(savedApplicant);
        return new ApiResponse("Applicant registered successfully", HttpStatus.CREATED.value(), null, null, response);
    }

    @Override
    public ApiResponse getApplicantById(Long applicantId) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        ApplicantResponse response = applicantMapper.toApplicantResponse(applicant);
        return new ApiResponse("Applicant found", HttpStatus.OK.value(), null, null, response);
    }

    @Override
    public ApiResponse getAllApplicants() {
        List<ApplicantResponse> response = applicantRepository.findAll().stream()
                .map(applicantMapper::toApplicantResponse)
                .toList();
        return new ApiResponse("Applicants found", HttpStatus.OK.value(), null, null, response);
    }

    @Override
    @Transactional
    public ApiResponse updateApplicant(Long applicantId, UpdateApplicantRequest request) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        applicantMapper.updateApplicant(applicant, request);
        Applicant savedApplicant = applicantRepository.save(applicant);
        ApplicantResponse response = applicantMapper.toApplicantResponse(savedApplicant);
        return new ApiResponse("Applicant updated successfully", HttpStatus.OK.value(), null, null, response);
    }

    @Override
    @Transactional
    public ApiResponse saveJob(SaveJobRequest request) {
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

        SavedJobResponse response = new SavedJobResponse(
                relation.getId(),
                applicant.getId(),
                jobDescription.getId(),
                jobDescription.getJobTitle(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getCompanyName(),
                jobDescription.getLocation());
        return new ApiResponse("Job saved successfully", HttpStatus.CREATED.value(), null, null, response);
    }

    @Override
    public ApiResponse getSavedJobs(Long applicantId) {
        if (!applicantRepository.existsById(applicantId)) {
            throw new ResourcesNotFoundException("Applicant not found");
        }
        List<SavedJobResponse> response = applicantJobDescriptionRepository.findByApplicant_Id(applicantId).stream()
                .map(relation -> new SavedJobResponse(
                        relation.getId(),
                        relation.getApplicant().getId(),
                        relation.getJobDescription().getId(),
                        relation.getJobDescription().getJobTitle(),
                        relation.getJobDescription().getRecruiter() == null ? null
                                : relation.getJobDescription().getRecruiter().getCompanyName(),
                        relation.getJobDescription().getLocation()))
                .toList();
        return new ApiResponse("Saved jobs found", HttpStatus.OK.value(), null, null, response);
    }

    @Override
    @Transactional
    public ApiResponse uploadCv(Long applicantId, UploadCvRequest request) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        Cv cv = applicantMapper.toCv(request);
        Cv savedCv = cvRepository.save(cv);
        applicant.setCv(savedCv);
        applicantRepository.save(applicant);
        CvResponse response = applicantMapper.toCvResponse(savedCv);
        return new ApiResponse("CV uploaded successfully", HttpStatus.CREATED.value(), null, null, response);
    }
}