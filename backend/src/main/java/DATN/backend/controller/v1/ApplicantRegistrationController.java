package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.applicant.RegistrationApplicantRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.service.InterfaceService.InterfaceApplicantService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/registrations/applicant")
@RequiredArgsConstructor
@Validated
@Tag(name = "Applicant Registration", description = "Applicant registration APIs")
public class ApplicantRegistrationController {

    private final InterfaceApplicantService applicantService;

    @Operation(summary = "Register applicant")
    @PostMapping
    public ResponseEntity<ApiResponse> registerApplicant(@Valid @RequestBody RegistrationApplicantRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Applicant registered successfully",
                HttpStatus.CREATED, applicantService.registerApplicant(request)));
    }
}
