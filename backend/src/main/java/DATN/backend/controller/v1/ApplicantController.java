package DATN.backend.controller.v1;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
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
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/api/v1/applicants")
@RequiredArgsConstructor
@Validated
public class ApplicantController {
    private final InterfaceApplicantService applicantService;

    @Operation(summary = "Get all applicants")
    @GetMapping
    public ResponseEntity<ApiResponse> getAllApplicants() {
        return ResponseEntity.ok(applicantService.getAllApplicants());
    }

    @Operation(summary = "Get applicant profile")
    @GetMapping("/{applicantId}")
    public ResponseEntity<ApiResponse> getApplicantById(@PathVariable Long applicantId) {
        return ResponseEntity.ok(applicantService.getApplicantById(applicantId));
    }

    @Operation(summary = "Update applicant profile")
    @PutMapping("/{applicantId}")
    public ResponseEntity<ApiResponse> updateApplicant(@PathVariable Long applicantId,
            @Valid @RequestBody UpdateApplicantRequest request) {
        return ResponseEntity.ok(applicantService.updateApplicant(applicantId, request));
    }

    @Operation(summary = "Get saved jobs for applicant")
    @GetMapping("/saved-jobs")
    public ResponseEntity<ApiResponse> getSavedJobs(@RequestParam Long applicantId) {
        return ResponseEntity.ok(applicantService.getSavedJobs(applicantId));
    }

    @Operation(summary = "Save a job for applicant")
    @PostMapping("/save/job")
    public ResponseEntity<ApiResponse> saveJob(@Valid @RequestBody SaveJobRequest request) {
        return ResponseEntity.ok(applicantService.saveJob(request));
    }

    @Operation(summary = "Upload CV for applicant")
    @PostMapping("/upload-cv/{applicantId}")
    public ResponseEntity<ApiResponse> uploadCv(@PathVariable Long applicantId,
            @Valid @RequestBody UploadCvRequest request) {
        return ResponseEntity.ok(applicantService.uploadCv(applicantId, request));
    }

}
