package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.response.ApiResponse;
import DATN.backend.service.InterfaceService.InterfaceJobDescriptionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/browse-jobs")
@RequiredArgsConstructor
@Validated
@Tag(name = "Browse Job", description = "Public job browsing APIs")
public class BrowseJobController {

    private final InterfaceJobDescriptionService jobDescriptionService;

    @Operation(summary = "Get all jobs")
    @GetMapping
    public ResponseEntity<ApiResponse> getAllJobs() {
        return ResponseEntity.ok(ApiResponse.success("Jobs found", HttpStatus.OK,
                jobDescriptionService.getAllJobs()));
    }

    @Operation(summary = "Get job by id")
    @GetMapping("/{jobId}")
    public ResponseEntity<ApiResponse> getJobById(@PathVariable Long jobId) {
        return ResponseEntity.ok(ApiResponse.success("Job found", HttpStatus.OK,
                jobDescriptionService.getJobById(jobId)));
    }

    @Operation(summary = "Get applicant count for a job")
    @GetMapping("/applicants/{jobId}")
    public ResponseEntity<ApiResponse> getApplicantCount(@PathVariable Long jobId) {
        return ResponseEntity.ok(ApiResponse.success("Applicant count found", HttpStatus.OK,
                jobDescriptionService.getJobApplicantsCount(jobId, null)));
    }
}
