package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.exception.ForbiddenException;
import DATN.backend.response.ApiResponse;
import DATN.backend.security.InforInsideToken;
import DATN.backend.service.InterfaceService.InterfaceApplicantPrivacyService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/jobs")
@RequiredArgsConstructor
@Validated
@Tag(name = "Applicant Job Privacy", description = "Applicant-facing private aggregate and anonymous preview APIs")
public class JobPrivacyController {

    private final InterfaceApplicantPrivacyService applicantPrivacyService;

    @Operation(summary = "Get differentially private applicant count for a job")
    @GetMapping("/{jobId}/applicant-count")
    public ResponseEntity<ApiResponse> getApplicantCount(@PathVariable Long jobId, Authentication authentication) {
        Long applicantId = requireApplicant(authentication);
        return ResponseEntity.ok(ApiResponse.success("Applicant activity found", HttpStatus.OK,
                applicantPrivacyService.getDifferentiallyPrivateApplicantCount(jobId, applicantId)));
    }

    @Operation(summary = "Get anonymous candidate previews for applicants who applied to the same job")
    @GetMapping("/{jobId}/anonymous-candidate-previews")
    public ResponseEntity<ApiResponse> getAnonymousCandidatePreviews(@PathVariable Long jobId,
            Authentication authentication) {
        Long applicantId = requireApplicant(authentication);
        return ResponseEntity.ok(ApiResponse.success("Anonymous candidate previews found", HttpStatus.OK,
                applicantPrivacyService.getAnonymousCandidatePreviews(jobId, applicantId)));
    }

    private Long requireApplicant(Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof InforInsideToken tokenInformation)
                || !"APPLICANT".equalsIgnoreCase(tokenInformation.getRoleName())) {
            throw new ForbiddenException("Only authenticated applicants can access applicant activity");
        }
        return tokenInformation.getUserId();
    }
}
