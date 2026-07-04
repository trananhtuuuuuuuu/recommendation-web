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
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.service.InterfaceService.InterfaceJobService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

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
    public ResponseEntity<ApiResponse> getAppliedApplicants(@PathVariable Long recruiterId, @PathVariable Long jobId) {
        return ResponseEntity.ok(ApiResponse.success("Job applicants found", HttpStatus.OK,
                jobDescriptionService.getJobApplicants(jobId, recruiterId)));
    }
}
