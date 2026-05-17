package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.recruiter.UpdateRecruiterRequest;
import DATN.backend.response.ApiResponse;
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
}
