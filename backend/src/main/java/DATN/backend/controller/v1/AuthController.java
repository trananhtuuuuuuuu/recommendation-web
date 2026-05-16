package DATN.backend.controller.v1;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.auth.LoginRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.response.auth.LoginResponse;
import DATN.backend.service.InterfaceService.InterfaceAuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Validated
@Tag(name = "Auth", description = "Authentication APIs")
public class AuthController {

    private final InterfaceAuthService authService;

    @Operation(summary = "Login with username and password")
    @PostMapping
    public ResponseEntity<ApiResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authService.login(request);
        return ResponseEntity.ok()
                .header(HttpHeaders.AUTHORIZATION, response.getTokenType() + " " + response.getToken())
                .body(ApiResponse.success("Login successful", HttpStatus.OK, response));
    }
}
