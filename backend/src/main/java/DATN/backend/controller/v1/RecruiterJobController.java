package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.exception.ForbiddenException;
import DATN.backend.security.InforInsideToken;
import DATN.backend.service.InterfaceService.InterfaceJobService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;

@RestController
@RequestMapping("/api/v1/recruiters/jobs")
@RequiredArgsConstructor
@Validated
@Tag(name = "Recruiter Job", description = "Recruiter job management APIs")
public class RecruiterJobController {

    private final InterfaceJobService jobDescriptionService;

    @Operation(summary = "Get jobs posted by recruiter")
    @GetMapping("/{recruiterId}")
    public ResponseEntity<ApiResponse> getJobsByRecruiter(@PathVariable Long recruiterId) {
        return ResponseEntity.ok(ApiResponse.success("Recruiter jobs found", HttpStatus.OK,
                jobDescriptionService.getJobsByRecruiter(recruiterId)));
    }

    @Operation(summary = "Create a recruiter job")
    @PostMapping("/{recruiterId}")
    public ResponseEntity<ApiResponse> createJob(@PathVariable Long recruiterId,
            @Valid @RequestBody RecruiterJobRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Job created successfully",
                HttpStatus.CREATED, jobDescriptionService.createJob(recruiterId, request)));
    }

    @Operation(summary = "Update a recruiter job")
    @PutMapping("/{recruiterId}/{jobId}")
    public ResponseEntity<ApiResponse> updateJob(@PathVariable Long recruiterId, @PathVariable Long jobId,
            @Valid @RequestBody RecruiterJobRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Job updated successfully", HttpStatus.OK,
                jobDescriptionService.updateJob(recruiterId, jobId, request)));
    }

    @Operation(summary = "Get applied applicants for a recruiter job")
    @GetMapping("/{recruiterId}/{jobId}/applicants")
    public ResponseEntity<ApiResponse> getAppliedApplicants(@PathVariable Long recruiterId, @PathVariable Long jobId,
            Authentication authentication) {
        verifyRecruiterAccess(recruiterId, authentication);
        return ResponseEntity.ok(ApiResponse.success("Job applicants found", HttpStatus.OK,
                jobDescriptionService.getJobApplicants(jobId, recruiterId)));
    }

    /**
     * Ranks applicants for a job owned by the authenticated recruiter.
     *
     * @param recruiterId posting recruiter identifier
     * @param jobId job identifier
     * @param request optional AI matching options
     * @param authentication current JWT authentication
     * @return descending AI match ranking in the standard API envelope
     */
    @Operation(summary = "AI-rank applicants for a recruiter job")
    @PostMapping("/{recruiterId}/{jobId}/ai-match")
    public ResponseEntity<ApiResponse> matchAppliedApplicants(@PathVariable Long recruiterId,
            @PathVariable Long jobId, @RequestBody(required = false) CvJobMatchRequest request,
            Authentication authentication) {
        verifyRecruiterAccess(recruiterId, authentication);
        return ResponseEntity.ok(ApiResponse.success("Job applicants matched and ranked", HttpStatus.OK,
                jobDescriptionService.matchJobApplicants(jobId, recruiterId,
                        request == null ? new CvJobMatchRequest() : request)));
    }

    /**
     * Runs the richer single-candidate AI suggestion flow for an applicant who
     * submitted to a recruiter-owned job.
     *
     * @param recruiterId posting recruiter identifier
     * @param jobId job identifier
     * @param applicantId submitted applicant identifier
     * @param request optional AI matching options
     * @param authentication current JWT authentication
     * @return single applicant match in the standard API envelope
     */
    @Operation(summary = "AI-match one applicant for a recruiter job")
    @PostMapping("/{recruiterId}/{jobId}/applicants/{applicantId}/ai-match")
    public ResponseEntity<ApiResponse> matchAppliedApplicant(@PathVariable Long recruiterId,
            @PathVariable Long jobId, @PathVariable Long applicantId,
            @RequestBody(required = false) CvJobMatchRequest request, Authentication authentication) {
        verifyRecruiterAccess(recruiterId, authentication);
        return ResponseEntity.ok(ApiResponse.success("Applicant AI suggestion generated", HttpStatus.OK,
                jobDescriptionService.matchJobApplicant(jobId, recruiterId, applicantId,
                        request == null ? new CvJobMatchRequest() : request)));
    }

    /**
     * Recommends open-to-work candidates who have CVs available for matching.
     *
     * @param recruiterId posting recruiter identifier
     * @param jobId published job identifier
     * @param limit maximum result count from 1 through 20
     * @param request optional AI matching options
     * @param authentication current JWT authentication
     * @return descending candidate ranking in the standard API envelope
     */
    @Operation(summary = "Recommend open-to-work candidates for a published job")
    @PostMapping("/{recruiterId}/{jobId}/recommendations")
    public ResponseEntity<ApiResponse> recommendCandidates(@PathVariable Long recruiterId,
            @PathVariable Long jobId, @RequestParam(defaultValue = "10") int limit,
            @RequestBody(required = false) CvJobMatchRequest request, Authentication authentication) {
        verifyRecruiterAccess(recruiterId, authentication);
        if (limit < 1 || limit > 20) {
            throw new IllegalArgumentException("Recommendation limit must be between 1 and 20");
        }
        return ResponseEntity.ok(ApiResponse.success("Recommended candidates ranked", HttpStatus.OK,
                jobDescriptionService.recommendCandidates(jobId, recruiterId,
                        request == null ? new CvJobMatchRequest() : request, limit)));
    }

    /**
     * Generates the detailed AI explanation for one candidate in a job
     * recommendation ranking.
     *
     * @param recruiterId posting recruiter identifier
     * @param jobId published job identifier
     * @param applicantId recommended applicant identifier
     * @param request optional AI matching options
     * @param authentication current JWT authentication
     * @return detailed candidate match in the standard API envelope
     */
    @Operation(summary = "Explain an AI candidate recommendation")
    @PostMapping("/{recruiterId}/{jobId}/recommendations/{applicantId}/ai-suggestion")
    public ResponseEntity<ApiResponse> getRecommendedCandidateSuggestion(
            @PathVariable Long recruiterId,
            @PathVariable Long jobId,
            @PathVariable Long applicantId,
            @RequestBody(required = false) CvJobMatchRequest request,
            Authentication authentication) {
        verifyRecruiterAccess(recruiterId, authentication);
        return ResponseEntity.ok(ApiResponse.success("Candidate AI suggestion generated", HttpStatus.OK,
                jobDescriptionService.getRecommendedCandidateSuggestion(
                        jobId,
                        recruiterId,
                        applicantId,
                        request == null ? new CvJobMatchRequest() : request)));
    }

    private void verifyRecruiterAccess(Long recruiterId, Authentication authentication) {
        if (authentication == null
                || !(authentication.getPrincipal() instanceof InforInsideToken tokenInformation)
                || !("RECRUITER".equalsIgnoreCase(tokenInformation.getRoleName())
                        && recruiterId.equals(tokenInformation.getUserId()))) {
            throw new ForbiddenException("Only the posting recruiter can access applicants for this job");
        }
    }
}
