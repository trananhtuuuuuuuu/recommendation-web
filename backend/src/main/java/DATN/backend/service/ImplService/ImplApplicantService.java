package DATN.backend.service.ImplService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.ApplicantMapper;
import DATN.backend.model.Applicant;
import DATN.backend.model.ApplicantJob;
import DATN.backend.model.Cv;
import DATN.backend.model.Job;
import DATN.backend.model.Role;
import DATN.backend.repository.ApplicantJobRepository;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.CertificateRepository;
import DATN.backend.repository.CvRepository;
import DATN.backend.repository.EducationRepository;
import DATN.backend.repository.ExperienceRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.repository.RoleRepository;
import DATN.backend.repository.UserRepository;
import DATN.backend.request.applicant.RegistrationApplicantRequest;
import DATN.backend.request.applicant.SaveJobRequest;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UpdateApplicantPrivacyRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.response.applicant.ApplicantResponse;
import DATN.backend.response.applicant.SavedJobResponse;
import DATN.backend.response.applicant.RegistrationApplicantResponse;
import DATN.backend.response.cv.CvResponse;
import DATN.backend.response.PageResponse;
import DATN.backend.service.InterfaceService.InterfaceApplicantService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplApplicantService implements InterfaceApplicantService {

    private static final String SAVED_ACTION = "SAVED";
    private static final String APPLIED_ACTION = "APPLIED";
    private static final Path CV_UPLOAD_DIR = Path.of("uploads", "cvs");

    private final ApplicantRepository applicantRepository;
    private final ApplicantJobRepository applicantJobRepository;
    private final JobRepository jobDescriptionRepository;
    private final CvRepository cvRepository;
    private final ExperienceRepository experienceRepository;
    private final EducationRepository educationRepository;
    private final CertificateRepository certificateRepository;
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

        String roleName = request.getRoleName() == null || request.getRoleName().isBlank()
                ? "APPLICANT"
                : request.getRoleName();
        Role role = roleRepository.findByRoleName(roleName)
                .orElseGet(() -> roleRepository.save(new Role(roleName, roleName)));

        Applicant applicant = ApplicantMapper.toNewApplicant(request);
        applicant.setPassword(passwordEncoder.encode(request.getPassword()));
        applicant.setRole(role);

        Applicant savedApplicant = applicantRepository.save(applicant);
        return ApplicantMapper.toRegistrationResponse(savedApplicant);
    }

    @Override
    public ApplicantResponse getApplicantById(Long applicantId, boolean fullAccess) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        return ApplicantMapper.toApplicantResponse(applicant, fullAccess);
    }

    @Override
    public List<ApplicantResponse> getAllApplicants(boolean fullAccess) {
        return applicantRepository.findAll().stream()
                .map(applicant -> ApplicantMapper.toApplicantResponse(applicant, fullAccess))
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
    public ApplicantResponse updateApplicantPrivacy(Long applicantId, UpdateApplicantPrivacyRequest request) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        ApplicantMapper.updateApplicantPrivacy(applicant, request);
        return ApplicantMapper.toApplicantResponse(applicantRepository.save(applicant));
    }

    @Override
    @Transactional
    public SavedJobResponse saveJob(SaveJobRequest request) {
        if (request.getApplicantId() == null || request.getJobId() == null) {
            throw new IllegalArgumentException("Applicant id and job id are required");
        }
        Applicant applicant = applicantRepository.findById(request.getApplicantId())
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        Job job = jobDescriptionRepository.findById(request.getJobId())
                .orElseThrow(() -> new ResourcesNotFoundException("Job not found"));

        applicantJobRepository.findByApplicant_IdAndJob_IdAndActionType(request.getApplicantId(),
                request.getJobId(), SAVED_ACTION)
                .ifPresent(existing -> {
                    throw new AlreadyExistException("Job already saved by this applicant");
                });

        ApplicantJob relation = applicantJobRepository
                .save(new ApplicantJob(applicant, job, SAVED_ACTION));

        return new SavedJobResponse(
                relation.getId(),
                applicant.getId(),
                job.getId(),
                job.getJobTitle(),
                job.getRecruiter() == null ? null : job.getRecruiter().getCompanyName(),
                job.getLocation(),
                job.getJobType(),
                SAVED_ACTION,
                toDateText(relation.getCreatedAt()),
                null);
    }

    @Override
    @Transactional
    public SavedJobResponse applyJob(SaveJobRequest request) {
        if (request.getApplicantId() == null || request.getJobId() == null) {
            throw new IllegalArgumentException("Applicant id and job id are required");
        }
        Applicant applicant = applicantRepository.findById(request.getApplicantId())
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        Job job = jobDescriptionRepository.findById(request.getJobId())
                .orElseThrow(() -> new ResourcesNotFoundException("Job not found"));

        applicantJobRepository.findByApplicant_IdAndJob_IdAndActionType(request.getApplicantId(),
                request.getJobId(), APPLIED_ACTION)
                .ifPresent(existing -> {
                    throw new AlreadyExistException("Applicant already applied for this job");
                });

        ApplicantJob relation = applicantJobRepository
                .save(new ApplicantJob(applicant, job, APPLIED_ACTION));

        return new SavedJobResponse(
                relation.getId(),
                applicant.getId(),
                job.getId(),
                job.getJobTitle(),
                job.getRecruiter() == null ? null : job.getRecruiter().getCompanyName(),
                job.getLocation(),
                job.getJobType(),
                APPLIED_ACTION,
                null,
                toDateText(relation.getCreatedAt()));
    }

    @Override
    public PageResponse<SavedJobResponse> getSavedJobs(Long applicantId, Pageable pageable) {
        if (!applicantRepository.existsById(applicantId)) {
            throw new ResourcesNotFoundException("Applicant not found");
        }
        return PageResponse.from(applicantJobRepository
                .findByApplicant_IdAndActionType(applicantId, SAVED_ACTION, pageable)
                .map(this::toSavedJobResponse));
    }

    @Override
    public PageResponse<SavedJobResponse> getAppliedJobs(Long applicantId, Pageable pageable) {
        if (!applicantRepository.existsById(applicantId)) {
            throw new ResourcesNotFoundException("Applicant not found");
        }
        return PageResponse.from(applicantJobRepository
                .findByApplicant_IdAndActionType(applicantId, APPLIED_ACTION, pageable)
                .map(this::toSavedJobResponse));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public SavedJobResponse removeSavedJob(Long applicantId, Long applicantJobId) {
        return removeApplicantJobRelation(applicantId, applicantJobId, SAVED_ACTION, "Saved job not found");
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public SavedJobResponse withdrawApplication(Long applicantId, Long applicantJobId) {
        return removeApplicantJobRelation(applicantId, applicantJobId, APPLIED_ACTION, "Job application not found");
    }

    @Override
    @Transactional
    public CvResponse uploadCv(Long applicantId, UploadCvRequest request) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));

        MultipartFile cvFile = request.getCvFile();
        String replacedCvFileUrl = applicant.getCv() == null ? null : applicant.getCv().getCvFileUrl();
        if (cvFile != null && !cvFile.isEmpty()) {
            request.setCvFileUrl(storeCvFile(cvFile));
        } else if ((request.getCvFileUrl() == null || request.getCvFileUrl().isBlank())
                && applicant.getCv() != null) {
            // Keep the previously stored file URL when no new file is provided
            request.setCvFileUrl(applicant.getCv().getCvFileUrl());
            replacedCvFileUrl = null;
        } else {
            replacedCvFileUrl = null;
        }

        Cv cv = applicant.getCv();
        if (cv == null) {
            // First upload — create and link a new CV entity
            cv = ApplicantMapper.toCv(request);
            saveCvRelations(cv);
            Cv savedCv = cvRepository.save(cv);
            applicant.setCv(savedCv);
            applicantRepository.save(applicant);
            return ApplicantMapper.toCvResponse(savedCv);
        }

        // Subsequent upload — update the existing CV row in-place (no new INSERT)
        ApplicantMapper.updateCv(cv, request);
        saveCvRelations(cv);
        Cv savedCv = cvRepository.save(cv);
        deleteStoredCvFile(replacedCvFileUrl);
        return ApplicantMapper.toCvResponse(savedCv);
    }

    @Override
    @Transactional
    public CvResponse deleteUploadedCvFile(Long applicantId) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        Cv cv = applicant.getCv();
        if (cv == null || cv.getCvFileUrl() == null || cv.getCvFileUrl().isBlank()) {
            throw new ResourcesNotFoundException("Uploaded CV file not found");
        }

        String storedCvFileUrl = cv.getCvFileUrl();
        deleteStoredCvFile(storedCvFileUrl);
        cv.setCvFileUrl(null);
        return ApplicantMapper.toCvResponse(cvRepository.save(cv));
    }

    private void saveCvRelations(Cv cv) {
        if (cv.getExperienceObj() != null && cv.getExperienceObj().getId() == null) {
            cv.setExperienceObj(experienceRepository.save(cv.getExperienceObj()));
        }
        if (cv.getEducationObj() != null && cv.getEducationObj().getId() == null) {
            cv.setEducationObj(educationRepository.save(cv.getEducationObj()));
        }
        if (cv.getCertificate() != null && cv.getCertificate().getId() == null) {
            cv.setCertificate(certificateRepository.save(cv.getCertificate()));
        }
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
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                "image/png",
                "image/jpeg",
                "image/webp",
                "image/bmp",
                "image/tiff")
                .contains(contentType)) {
            throw new IllegalArgumentException(
                    "CV file must be a PDF, DOC, DOCX, PNG, JPG, WebP, BMP, or TIFF file");
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

    private void deleteStoredCvFile(String cvFileUrl) {
        if (cvFileUrl == null || cvFileUrl.isBlank()) {
            return;
        }
        String normalizedUrl = cvFileUrl.startsWith("/") ? cvFileUrl.substring(1) : cvFileUrl;
        if (!normalizedUrl.startsWith("uploads/cvs/")) {
            return;
        }

        Path fileName = Path.of(normalizedUrl).getFileName();
        if (fileName == null) {
            return;
        }
        Path filePath = CV_UPLOAD_DIR.resolve(fileName).normalize();
        if (!filePath.startsWith(CV_UPLOAD_DIR.normalize())) {
            throw new IllegalArgumentException("Invalid CV file path");
        }

        try {
            Files.deleteIfExists(filePath);
        } catch (IOException exception) {
            throw new IllegalArgumentException("Unable to delete CV file");
        }
    }

    private SavedJobResponse removeApplicantJobRelation(Long applicantId, Long applicantJobId, String actionType,
            String notFoundMessage) {
        if (!applicantRepository.existsById(applicantId)) {
            throw new ResourcesNotFoundException("Applicant not found");
        }

        ApplicantJob relation = applicantJobRepository
                .findByIdAndApplicant_IdAndActionType(applicantJobId, applicantId, actionType)
                .orElseThrow(() -> new ResourcesNotFoundException(notFoundMessage));
        SavedJobResponse response = toSavedJobResponse(relation);
        applicantJobRepository.delete(relation);
        return response;
    }

    private SavedJobResponse toSavedJobResponse(ApplicantJob relation) {
        Job job = relation.getJob();
        return new SavedJobResponse(
                relation.getId(),
                relation.getApplicant().getId(),
                job.getId(),
                job.getJobTitle(),
                job.getRecruiter() == null ? null : job.getRecruiter().getCompanyName(),
                job.getLocation(),
                job.getJobType(),
                relation.getActionType(),
                SAVED_ACTION.equals(relation.getActionType()) ? toDateText(relation.getCreatedAt()) : null,
                APPLIED_ACTION.equals(relation.getActionType()) ? toDateText(relation.getCreatedAt()) : null);
    }

    private String toDateText(java.sql.Date date) {
        return date == null ? null : date.toString();
    }
}
