package DATN.backend.controller.v1;

import java.beans.PropertyEditorSupport;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.request.applicant.SaveJobRequest;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.model.Certificate;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
import DATN.backend.response.ApiResponse;
import DATN.backend.exception.ForbiddenException;
import DATN.backend.security.InforInsideToken;
import DATN.backend.service.InterfaceService.InterfaceApplicantService;
import DATN.backend.service.InterfaceService.InterfaceCvAiService;
import DATN.backend.service.InterfaceService.InterfaceCvMatchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.security.core.Authentication;

@RestController
@RequestMapping("/api/v1/applicants")
@RequiredArgsConstructor
@Validated
@Tag(name = "Applicant", description = "Applicant profile, saved job, and CV APIs")
public class ApplicantController {
        private final InterfaceApplicantService applicantService;
        private final InterfaceCvAiService cvAiService;
        private final InterfaceCvMatchService cvMatchService;

        @InitBinder
        public void initBinder(WebDataBinder binder) {
                binder.registerCustomEditor(Experience.class, new PropertyEditorSupport() {
                        @Override
                        public void setAsText(String text) {
                                setValue(UploadCvRequest.parseExperience(text));
                        }
                });
                binder.registerCustomEditor(Education.class, new PropertyEditorSupport() {
                        @Override
                        public void setAsText(String text) {
                                setValue(UploadCvRequest.parseEducation(text));
                        }
                });
                binder.registerCustomEditor(Certificate.class, new PropertyEditorSupport() {
                        @Override
                        public void setAsText(String text) {
                                setValue(UploadCvRequest.parseCertificate(text));
                        }
                });
        }

        @Operation(summary = "Get all applicants")
        @GetMapping
        public ResponseEntity<ApiResponse> getAllApplicants(Authentication authentication) {
                return ResponseEntity.ok(ApiResponse.success("Applicants found", HttpStatus.OK,
                                applicantService.getAllApplicants(isAdmin(authentication))));
        }

        @Operation(summary = "Get applicant profile")
        @GetMapping("/{applicantId}")
        public ResponseEntity<ApiResponse> getApplicantById(@PathVariable Long applicantId,
                        Authentication authentication) {
                if (isRecruiter(authentication)) {
                        return ResponseEntity.ok(ApiResponse.success("Applicant found", HttpStatus.OK,
                                        applicantService.getApplicantForRecruiter(applicantId)));
                }
                return ResponseEntity.ok(ApiResponse.success("Applicant found", HttpStatus.OK,
                                applicantService.getApplicantById(applicantId,
                                                hasFullApplicantAccess(applicantId, authentication))));
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
        public ResponseEntity<ApiResponse> getSavedJobs(@RequestParam Long applicantId,
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "5") int size,
                        @RequestParam(defaultValue = "id,desc") String sort) {
                return ResponseEntity.ok(ApiResponse.success("Saved jobs found", HttpStatus.OK,
                                applicantService.getSavedJobs(applicantId, toPageable(page, size, sort))));
        }

        @Operation(summary = "Get applied jobs for applicant")
        @GetMapping("/applied-jobs")
        public ResponseEntity<ApiResponse> getAppliedJobs(@RequestParam Long applicantId,
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "5") int size,
                        @RequestParam(defaultValue = "id,desc") String sort) {
                return ResponseEntity.ok(ApiResponse.success("Applied jobs found", HttpStatus.OK,
                                applicantService.getAppliedJobs(applicantId, toPageable(page, size, sort))));
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

        /**
         * Removes a saved job owned by the authenticated applicant.
         *
         * @param applicantId    applicant owner identifier
         * @param applicantJobId saved relation identifier
         * @param authentication current JWT authentication
         * @return standard API response containing the removed relation
         */
        @Operation(summary = "Remove a job from an applicant's saved list")
        @DeleteMapping("/{applicantId}/saved-jobs/{applicantJobId}")
        public ResponseEntity<ApiResponse> removeSavedJob(@PathVariable Long applicantId,
                        @PathVariable Long applicantJobId, Authentication authentication) {
                verifyApplicantAccess(applicantId, authentication);
                return ResponseEntity.ok(ApiResponse.success("Saved job removed successfully", HttpStatus.OK,
                                applicantService.removeSavedJob(applicantId, applicantJobId)));
        }

        /**
         * Withdraws a submitted application owned by the authenticated applicant.
         *
         * @param applicantId    applicant owner identifier
         * @param applicantJobId applied relation identifier
         * @param authentication current JWT authentication
         * @return standard API response containing the withdrawn relation
         */
        @Operation(summary = "Withdraw an applicant's submitted job application")
        @DeleteMapping("/{applicantId}/applied-jobs/{applicantJobId}")
        public ResponseEntity<ApiResponse> withdrawApplication(@PathVariable Long applicantId,
                        @PathVariable Long applicantJobId, Authentication authentication) {
                verifyApplicantAccess(applicantId, authentication);
                return ResponseEntity.ok(ApiResponse.success("Application withdrawn successfully", HttpStatus.OK,
                                applicantService.withdrawApplication(applicantId, applicantJobId)));
        }

        /**
         * Analyzes a CV and returns suggested applicant profile fields without
         * persisting them.
         *
         * @param applicantId    applicant owner identifier
         * @param cvFile         uploaded CV document
         * @param authentication current JWT authentication
         * @return standard API response containing extracted fields
         */
        @Operation(summary = "Analyze a CV and suggest applicant profile fields")
        @PostMapping(value = "/{applicantId}/analyze-cv", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        public ResponseEntity<ApiResponse> analyzeCv(
                        @PathVariable Long applicantId,
                        @RequestPart("cvFile") MultipartFile cvFile,
                        Authentication authentication) {
                verifyApplicantAccess(applicantId, authentication);
                return ResponseEntity.ok(
                                ApiResponse.success("CV analyzed successfully",
                                                HttpStatus.OK,
                                                cvAiService.analyzeCv(cvFile)));
        }

        /**
         * Matches the authenticated applicant's stored CV against a job and returns a
         * score plus English improvement suggestions.
         *
         * @param applicantId    applicant owner identifier
         * @param jobId          job description identifier
         * @param request        optional matching options (LLM toggle, scoring method)
         * @param authentication current JWT authentication
         * @return standard API response containing the match result
         */
        @Operation(summary = "Match the applicant's CV against a job (score + suggestions)")
        @PostMapping("/{applicantId}/match/{jobId}")
        public ResponseEntity<ApiResponse> matchJob(@PathVariable Long applicantId, @PathVariable Long jobId,
                        @RequestBody(required = false) CvJobMatchRequest request, Authentication authentication) {
                verifyApplicantAccess(applicantId, authentication);
                CvJobMatchRequest options = request == null ? new CvJobMatchRequest() : request;
                return ResponseEntity.ok(ApiResponse.success("CV matched successfully", HttpStatus.OK,
                                cvMatchService.matchApplicantToJob(applicantId, jobId, options)));
        }

        @Operation(summary = "Upload CV for applicant")
        @PostMapping(value = "/upload-cv/{applicantId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        public ResponseEntity<ApiResponse> uploadCv(
                        @PathVariable Long applicantId,
                        @Valid @ModelAttribute UploadCvRequest request) {
                return ResponseEntity.status(HttpStatus.CREATED).body(
                                ApiResponse.success("CV uploaded successfully",
                                                HttpStatus.CREATED,
                                                applicantService.uploadCv(applicantId, request)));
        }

        @Operation(summary = "Upload CV metadata for applicant")
        @PostMapping(value = "/upload-cv/{applicantId}", consumes = MediaType.APPLICATION_JSON_VALUE)
        public ResponseEntity<ApiResponse> uploadCvMetadata(@PathVariable Long applicantId,
                        @Valid @RequestBody UploadCvRequest request) {
                return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("CV uploaded successfully",
                                HttpStatus.CREATED, applicantService.uploadCv(applicantId, request)));
        }

        @Operation(summary = "Delete uploaded CV file for applicant")
        @DeleteMapping("/{applicantId}/cv-file")
        public ResponseEntity<ApiResponse> deleteUploadedCvFile(@PathVariable Long applicantId,
                        Authentication authentication) {
                verifyApplicantAccess(applicantId, authentication);
                return ResponseEntity.ok(ApiResponse.success("CV file deleted successfully", HttpStatus.OK,
                                applicantService.deleteUploadedCvFile(applicantId)));
        }

        private void verifyApplicantAccess(Long applicantId, Authentication authentication) {
                if (authentication == null
                                || !(authentication.getPrincipal() instanceof InforInsideToken tokenInformation)
                                || !"APPLICANT".equalsIgnoreCase(tokenInformation.getRoleName())
                                || !applicantId.equals(tokenInformation.getUserId())) {
                        throw new ForbiddenException("You can only manage jobs in your own applicant account");
                }
        }

        private boolean hasFullApplicantAccess(Long applicantId, Authentication authentication) {
                if (authentication == null
                                || !(authentication.getPrincipal() instanceof InforInsideToken tokenInformation)) {
                        return false;
                }
                if ("ADMIN".equalsIgnoreCase(tokenInformation.getRoleName())) {
                        return true;
                }
                return "APPLICANT".equalsIgnoreCase(tokenInformation.getRoleName())
                                && applicantId.equals(tokenInformation.getUserId());
        }

        private boolean isAdmin(Authentication authentication) {
                return authentication != null
                                && authentication.getPrincipal() instanceof InforInsideToken tokenInformation
                                && "ADMIN".equalsIgnoreCase(tokenInformation.getRoleName());
        }

        private boolean isRecruiter(Authentication authentication) {
                return authentication != null
                                && authentication.getPrincipal() instanceof InforInsideToken tokenInformation
                                && "RECRUITER".equalsIgnoreCase(tokenInformation.getRoleName());
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
                        case "jobTitle" -> "job.jobTitle";
                        case "location" -> "job.location";
                        case "jobType" -> "job.jobType";
                        case "postedDate" -> "job.postedDate";
                        default -> "id";
                };
                return Sort.by(direction, field);
        }

}
