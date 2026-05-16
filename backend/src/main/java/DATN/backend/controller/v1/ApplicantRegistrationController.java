package DATN.backend.controller.v1;

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
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/registrations/applicant")
@RequiredArgsConstructor
@Validated
public class ApplicantRegistrationController {

    private final InterfaceApplicantService applicantService;

    @Operation(summary = "Register applicant")
    @PostMapping
    public ResponseEntity<ApiResponse> registerApplicant(@Valid @RequestBody RegistrationApplicantRequest request) {
        return ResponseEntity.status(201).body(applicantService.registerApplicant(request));
    }
}