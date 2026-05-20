package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.applicant.SaveJobRequest;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.service.InterfaceService.InterfaceApplicantService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/api/v1/applicants")
@RequiredArgsConstructor
@Validated
@Tag(name = "Applicant", description = "Applicant profile, saved job, and CV APIs")
public class ApplicantController {
    private final InterfaceApplicantService applicantService;

    @Operation(summary = "Get all applicants")
    @GetMapping
    public ResponseEntity<ApiResponse> getAllApplicants() {
        return ResponseEntity.ok(ApiResponse.success("Applicants found", HttpStatus.OK,
                applicantService.getAllApplicants()));
    }

    @Operation(summary = "Get applicant profile")
    @GetMapping("/{applicantId}")
    public ResponseEntity<ApiResponse> getApplicantById(@PathVariable Long applicantId) {
        return ResponseEntity.ok(ApiResponse.success("Applicant found", HttpStatus.OK,
                applicantService.getApplicantById(applicantId)));
    }

    @Operation(summary = "Update applicant profile")
    @PutMapping("/{applicantId}")
    public ResponseEntity<ApiResponse> updateApplicant(@PathVariable Long applicantId,
            @Valid @RequestBody UpdateApplicantRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Applicant updated successfully", HttpStatus.OK,
                applicantService.updateApplicant(applicantId, request)));
    }

    @Operation(summary = "Get saved jobs for applicant")
    @GetMapping("/saved-jobs")
    public ResponseEntity<ApiResponse> getSavedJobs(@RequestParam Long applicantId) {
        return ResponseEntity.ok(ApiResponse.success("Saved jobs found", HttpStatus.OK,
                applicantService.getSavedJobs(applicantId)));
    }

    @Operation(summary = "Get applied jobs for applicant")
    @GetMapping("/applied-jobs")
    public ResponseEntity<ApiResponse> getAppliedJobs(@RequestParam Long applicantId) {
        return ResponseEntity.ok(ApiResponse.success("Applied jobs found", HttpStatus.OK,
                applicantService.getAppliedJobs(applicantId)));
    }

    @Operation(summary = "Save a job for applicant")
    @PostMapping("/save/job")
    public ResponseEntity<ApiResponse> saveJob(@Valid @RequestBody SaveJobRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Job saved successfully",
                HttpStatus.CREATED, applicantService.saveJob(request)));
    }

    @Operation(summary = "Apply to a job as applicant")
    @PostMapping("/apply/job")
    public ResponseEntity<ApiResponse> applyJob(@Valid @RequestBody SaveJobRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Job applied successfully",
                HttpStatus.CREATED, applicantService.applyJob(request)));
    }

    @Operation(summary = "Upload CV for applicant")
    @PostMapping(value = "/upload-cv/{applicantId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ApiResponse> uploadCv(@PathVariable Long applicantId,
            @Valid @ModelAttribute UploadCvRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("CV uploaded successfully",
                HttpStatus.CREATED, applicantService.uploadCv(applicantId, request)));
    }

    @Operation(summary = "Upload CV metadata for applicant")
    @PostMapping(value = "/upload-cv/{applicantId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse> uploadCvMetadata(@PathVariable Long applicantId,
            @Valid @RequestBody UploadCvRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("CV uploaded successfully",
                HttpStatus.CREATED, applicantService.uploadCv(applicantId, request)));
    }

}
