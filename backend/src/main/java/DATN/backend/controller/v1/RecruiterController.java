package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;

import DATN.backend.exception.ForbiddenException;
import DATN.backend.request.recruiter.UploadRecruiterImageRequest;
import DATN.backend.request.recruiter.UpdateRecruiterRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.security.InforInsideToken;
import DATN.backend.service.InterfaceService.InterfaceRecruiterService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/recruiters")
@RequiredArgsConstructor
@Validated
@Tag(name = "Recruiter", description = "Recruiter profile APIs")
public class RecruiterController {

    private final InterfaceRecruiterService recruiterService;

    @Operation(summary = "Get all recruiters")
    @GetMapping
    public ResponseEntity<ApiResponse> getAllRecruiters() {
        return ResponseEntity.ok(ApiResponse.success("Recruiters found", HttpStatus.OK,
                recruiterService.getAllRecruiters()));
    }

    @Operation(summary = "Get recruiter profile")
    @GetMapping("/{recruiterId}")
    public ResponseEntity<ApiResponse> getRecruiterById(@PathVariable Long recruiterId) {
        return ResponseEntity.ok(ApiResponse.success("Recruiter found", HttpStatus.OK,
                recruiterService.getRecruiterById(recruiterId)));
    }

    @Operation(summary = "Update recruiter profile")
    @PutMapping("/{recruiterId}")
    public ResponseEntity<ApiResponse> updateRecruiter(@PathVariable Long recruiterId,
            @Valid @RequestBody UpdateRecruiterRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Recruiter updated successfully", HttpStatus.OK,
                recruiterService.updateRecruiter(recruiterId, request)));
    }

    /**
     * Uploads a persistent logo or cover image for the authenticated recruiter.
     *
     * @param recruiterId recruiter owner identifier
     * @param imageType supported type: logo or cover
     * @param request multipart image request
     * @param authentication current JWT authentication
     * @return updated profile in the standard API envelope
     */
    @Operation(summary = "Upload recruiter logo or cover image")
    @PostMapping(value = "/{recruiterId}/images/{imageType}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ApiResponse> uploadRecruiterImage(@PathVariable Long recruiterId,
            @PathVariable String imageType, @Valid @ModelAttribute UploadRecruiterImageRequest request,
            Authentication authentication) {
        verifyRecruiterAccess(recruiterId, authentication);
        return ResponseEntity.ok(ApiResponse.success("Recruiter image uploaded successfully", HttpStatus.OK,
                recruiterService.uploadProfileImage(recruiterId, imageType, request.getImage())));
    }

    private void verifyRecruiterAccess(Long recruiterId, Authentication authentication) {
        if (authentication == null
                || !(authentication.getPrincipal() instanceof InforInsideToken tokenInformation)
                || !"RECRUITER".equalsIgnoreCase(tokenInformation.getRoleName())
                || !recruiterId.equals(tokenInformation.getUserId())) {
            throw new ForbiddenException("You can only update images in your own recruiter profile");
        }
    }
}
