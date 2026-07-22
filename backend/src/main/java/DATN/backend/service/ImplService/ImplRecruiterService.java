package DATN.backend.service.ImplService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.RecruiterMapper;
import DATN.backend.model.Recruiter;
import DATN.backend.model.Role;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.repository.RoleRepository;
import DATN.backend.repository.UserRepository;
import DATN.backend.request.recruiter.RegistrationRecruiterRequest;
import DATN.backend.request.recruiter.UpdateRecruiterRequest;
import DATN.backend.response.recruiter.RecruiterResponse;
import DATN.backend.response.recruiter.RegistrationRecruiterResponse;
import DATN.backend.service.InterfaceService.InterfaceRecruiterService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplRecruiterService implements InterfaceRecruiterService {

    private static final long MAX_PROFILE_IMAGE_SIZE = 5L * 1024 * 1024;
    private static final Path RECRUITER_IMAGE_UPLOAD_DIR = Path.of("uploads", "recruiters");
    private static final Map<String, String> IMAGE_EXTENSIONS = Map.of(
            "image/png", ".png",
            "image/jpeg", ".jpg",
            "image/webp", ".webp",
            "image/gif", ".gif");

    private final RecruiterRepository recruiterRepository;
    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public RegistrationRecruiterResponse registerRecruiter(RegistrationRecruiterRequest request) {
        if (userRepository.findByUserName(request.getUserName()).isPresent()) {
            throw new AlreadyExistException("User name already exists");
        }
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new AlreadyExistException("Email already exists");
        }

        String roleName = request.getRoleName() == null || request.getRoleName().isBlank()
                ? "RECRUITER"
                : request.getRoleName();
        Role role = roleRepository.findByRoleName(roleName)
                .orElseGet(() -> roleRepository.save(new Role(roleName, roleName)));

        Recruiter recruiter = RecruiterMapper.toNewRecruiter(request);
        recruiter.setPassword(passwordEncoder.encode(request.getPassword()));
        recruiter.setRole(role);
        Recruiter savedRecruiter = recruiterRepository.save(recruiter);
        return RecruiterMapper.toRegistrationResponse(savedRecruiter);
    }

    @Override
    public RecruiterResponse getRecruiterById(Long recruiterId) {
        Recruiter recruiter = recruiterRepository.findById(recruiterId)
                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
        return RecruiterMapper.toRecruiterResponse(recruiter);
    }

    @Override
    public List<RecruiterResponse> getAllRecruiters() {
        return recruiterRepository.findAll().stream()
                .map(RecruiterMapper::toRecruiterResponse)
                .toList();
    }

    @Override
    @Transactional
    public RecruiterResponse updateRecruiter(Long recruiterId, UpdateRecruiterRequest request) {
        Recruiter recruiter = recruiterRepository.findById(recruiterId)
                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
        RecruiterMapper.updateRecruiter(recruiter, request);
        Recruiter savedRecruiter = recruiterRepository.save(recruiter);
        return RecruiterMapper.toRecruiterResponse(savedRecruiter);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public RecruiterResponse uploadProfileImage(Long recruiterId, String imageType, MultipartFile image) {
        Recruiter recruiter = recruiterRepository.findById(recruiterId)
                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
        String normalizedType = normalizeImageType(imageType);
        validateImage(image);

        String previousUrl = "logo".equals(normalizedType)
                ? recruiter.getLogoUrl()
                : recruiter.getCoverImageUrl();
        String imageUrl = storeImage(recruiterId, normalizedType, image);
        if ("logo".equals(normalizedType)) {
            recruiter.setLogoUrl(imageUrl);
            recruiter.setAvatarUrl(imageUrl);
        } else {
            recruiter.setCoverImageUrl(imageUrl);
        }

        Recruiter savedRecruiter = recruiterRepository.save(recruiter);
        deletePreviousImage(recruiterId, previousUrl, imageUrl);
        return RecruiterMapper.toRecruiterResponse(savedRecruiter);
    }

    private String normalizeImageType(String imageType) {
        String normalizedType = imageType == null ? "" : imageType.trim().toLowerCase(Locale.ROOT);
        if (!"logo".equals(normalizedType) && !"cover".equals(normalizedType)) {
            throw new IllegalArgumentException("Image type must be logo or cover");
        }
        return normalizedType;
    }

    private void validateImage(MultipartFile image) {
        if (image == null || image.isEmpty()) {
            throw new IllegalArgumentException("Image file is required");
        }
        if (image.getSize() > MAX_PROFILE_IMAGE_SIZE) {
            throw new IllegalArgumentException("Image file must not exceed 5 MB");
        }
        if (!IMAGE_EXTENSIONS.containsKey(image.getContentType())) {
            throw new IllegalArgumentException("Image must be a PNG, JPG, WebP, or GIF file");
        }
    }

    private String storeImage(Long recruiterId, String imageType, MultipartFile image) {
        String extension = IMAGE_EXTENSIONS.get(image.getContentType());
        String fileName = imageType + "-" + UUID.randomUUID() + extension;
        Path recruiterDirectory = RECRUITER_IMAGE_UPLOAD_DIR.resolve(recruiterId.toString());
        try {
            Files.createDirectories(recruiterDirectory);
            Files.copy(image.getInputStream(), recruiterDirectory.resolve(fileName),
                    StandardCopyOption.REPLACE_EXISTING);
            return "/uploads/recruiters/" + recruiterId + "/" + fileName;
        } catch (IOException exception) {
            throw new IllegalArgumentException("Unable to store recruiter image");
        }
    }

    private void deletePreviousImage(Long recruiterId, String previousUrl, String currentUrl) {
        if (previousUrl == null || previousUrl.isBlank() || previousUrl.equals(currentUrl)) {
            return;
        }
        String expectedPrefix = "/uploads/recruiters/" + recruiterId + "/";
        if (!previousUrl.startsWith(expectedPrefix)) {
            return;
        }
        Path fileName = Path.of(previousUrl).getFileName();
        if (fileName == null) {
            return;
        }
        Path recruiterDirectory = RECRUITER_IMAGE_UPLOAD_DIR.resolve(recruiterId.toString()).normalize();
        Path previousFile = recruiterDirectory.resolve(fileName).normalize();
        if (!previousFile.startsWith(recruiterDirectory)) {
            throw new IllegalArgumentException("Invalid recruiter image path");
        }
        try {
            Files.deleteIfExists(previousFile);
        } catch (IOException exception) {
            throw new IllegalArgumentException("Unable to replace recruiter image");
        }
    }
}
