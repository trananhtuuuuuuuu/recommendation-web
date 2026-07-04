package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.response.ApiResponse;
import DATN.backend.service.InterfaceService.InterfaceJobService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/browse-jobs")
@RequiredArgsConstructor
@Validated
@Tag(name = "Browse Job", description = "Public job browsing APIs")
public class BrowseJobController {

    private final InterfaceJobService jobDescriptionService;

    @Operation(summary = "Get all jobs")
    @GetMapping
    public ResponseEntity<ApiResponse> getAllJobs(@RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id,desc") String sort) {
        return ResponseEntity.ok(ApiResponse.success("Jobs found", HttpStatus.OK,
                jobDescriptionService.getAllJobs(toPageable(page, size, sort))));
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

    @Operation(summary = "Get applicants who applied for a job")
    @GetMapping("/applicants/{jobId}/list")
    public ResponseEntity<ApiResponse> getApplicants(@PathVariable Long jobId) {
        return ResponseEntity.ok(ApiResponse.success("Job applicants found", HttpStatus.OK,
                jobDescriptionService.getJobApplicants(jobId, null)));
    }

    private Pageable toPageable(int page, int size, String sort) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.min(Math.max(size, 1), 20);
        return PageRequest.of(safePage, safeSize, toSort(sort));
    }

    private Sort toSort(String sort) {
        String[] parts = sort == null ? new String[0] : sort.split(",", 2);
        String requestedField = parts.length > 0 ? parts[0] : "id";
        Sort.Direction direction = parts.length > 1 && "asc".equalsIgnoreCase(parts[1])
                ? Sort.Direction.ASC
                : Sort.Direction.DESC;
        String field = switch (requestedField) {
            case "jobTitle" -> "jobTitle";
            case "location" -> "location";
            case "jobType" -> "jobType";
            case "postedDate" -> "postedDate";
            default -> "id";
        };
        return Sort.by(direction, field);
    }
}
