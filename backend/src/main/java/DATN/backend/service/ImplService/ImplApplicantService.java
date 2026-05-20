package DATN.backend.service.ImplService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

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

    private static final String SAVED_ACTION = "SAVED";
    private static final String APPLIED_ACTION = "APPLIED";
    private static final Path CV_UPLOAD_DIR = Path.of("uploads", "cvs");

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

        applicantJobDescriptionRepository.findByApplicant_IdAndJobDescription_IdAndActionType(request.getApplicantId(),
                request.getJobDescriptionId(), SAVED_ACTION)
                .ifPresent(existing -> {
                    throw new AlreadyExistException("Job already saved by this applicant");
                });

        ApplicantJobDescription relation = applicantJobDescriptionRepository
                .save(new ApplicantJobDescription(applicant, jobDescription, SAVED_ACTION));

        return new SavedJobResponse(
                relation.getId(),
                applicant.getId(),
                jobDescription.getId(),
                jobDescription.getJobTitle(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getCompanyName(),
                jobDescription.getLocation());
    }

    @Override
    @Transactional
    public SavedJobResponse applyJob(SaveJobRequest request) {
        Applicant applicant = applicantRepository.findById(request.getApplicantId())
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        JobDescription jobDescription = jobDescriptionRepository.findById(request.getJobDescriptionId())
                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));

        applicantJobDescriptionRepository.findByApplicant_IdAndJobDescription_IdAndActionType(request.getApplicantId(),
                request.getJobDescriptionId(), APPLIED_ACTION)
                .ifPresent(existing -> {
                    throw new AlreadyExistException("Applicant already applied for this job");
                });

        ApplicantJobDescription relation = applicantJobDescriptionRepository
                .save(new ApplicantJobDescription(applicant, jobDescription, APPLIED_ACTION));
        relation.setCoverLetter(request.getCoverLetter());
        relation.setPortfolioUrl(request.getPortfolioUrl());
        relation.setApplicationAnswers(request.getApplicationAnswers());

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
        return applicantJobDescriptionRepository.findByApplicant_IdAndActionType(applicantId, SAVED_ACTION).stream()
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
    public List<SavedJobResponse> getAppliedJobs(Long applicantId) {
        if (!applicantRepository.existsById(applicantId)) {
            throw new ResourcesNotFoundException("Applicant not found");
        }
        return applicantJobDescriptionRepository.findByApplicant_IdAndActionType(applicantId, APPLIED_ACTION).stream()
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
        MultipartFile cvFile = request.getCvFile();
        if (cvFile != null && !cvFile.isEmpty()) {
            request.setCvFileUrl(storeCvFile(cvFile));
        } else if ((request.getCvFileUrl() == null || request.getCvFileUrl().isBlank()) && applicant.getCv() != null) {
            request.setCvFileUrl(applicant.getCv().getCvFileUrl());
        }
        Cv cv = ApplicantMapper.toCv(request);
        Cv savedCv = cvRepository.save(cv);
        applicant.setCv(savedCv);
        applicantRepository.save(applicant);
        return ApplicantMapper.toCvResponse(savedCv);
    }

    private String storeCvFile(MultipartFile cvFile) {
        String originalName = StringUtils.cleanPath(cvFile.getOriginalFilename() == null ? "cv" : cvFile.getOriginalFilename());
        if (originalName.contains("..")) {
            throw new IllegalArgumentException("Invalid CV file name");
        }

        String contentType = cvFile.getContentType();
        if (contentType != null && !List.of(
                "application/pdf",
                "application/msword",
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
                .contains(contentType)) {
            throw new IllegalArgumentException("CV file must be a PDF, DOC, or DOCX file");
        }

        String extension = "";
        int dotIndex = originalName.lastIndexOf('.');
        if (dotIndex >= 0) {
            extension = originalName.substring(dotIndex);
        }
        String fileName = UUID.randomUUID() + extension;

        try {
            Files.createDirectories(CV_UPLOAD_DIR);
            Files.copy(cvFile.getInputStream(), CV_UPLOAD_DIR.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
            return "/uploads/cvs/" + fileName;
        } catch (IOException exception) {
            throw new IllegalArgumentException("Unable to store CV file");
        }
    }
}
