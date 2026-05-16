package DATN.backend.controller.v1;

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
import DATN.backend.service.InterfaceService.InterfaceJobDescriptionService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/recruiters/jobs")
@RequiredArgsConstructor
@Validated
public class RecruiterJobController {

    private final InterfaceJobDescriptionService jobDescriptionService;

    @Operation(summary = "Get jobs posted by recruiter")
    @GetMapping("/{recruiterId}")
    public ResponseEntity<ApiResponse> getJobsByRecruiter(@PathVariable Long recruiterId) {
        return ResponseEntity.ok(jobDescriptionService.getJobsByRecruiter(recruiterId));
    }

    @Operation(summary = "Create a recruiter job")
    @PostMapping("/{recruiterId}")
    public ResponseEntity<ApiResponse> createJob(@PathVariable Long recruiterId,
            @Valid @RequestBody RecruiterJobRequest request) {
        return ResponseEntity.status(201).body(jobDescriptionService.createJob(recruiterId, request));
    }

    @Operation(summary = "Update a recruiter job")
    @PutMapping("/{recruiterId}/{jobId}")
    public ResponseEntity<ApiResponse> updateJob(@PathVariable Long recruiterId, @PathVariable Long jobId,
            @Valid @RequestBody RecruiterJobRequest request) {
        return ResponseEntity.ok(jobDescriptionService.updateJob(recruiterId, jobId, request));
    }
}