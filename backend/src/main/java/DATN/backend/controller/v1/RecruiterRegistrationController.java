package DATN.backend.controller.v1;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.recruiter.RegistrationRecruiterRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.service.InterfaceService.InterfaceRecruiterService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/registrations/recruiters")
@RequiredArgsConstructor
@Validated
public class RecruiterRegistrationController {

    private final InterfaceRecruiterService recruiterService;

    @Operation(summary = "Register recruiter")
    @PostMapping
    public ResponseEntity<ApiResponse> registerRecruiter(@Valid @RequestBody RegistrationRecruiterRequest request) {
        return ResponseEntity.status(201).body(recruiterService.registerRecruiter(request));
    }
}