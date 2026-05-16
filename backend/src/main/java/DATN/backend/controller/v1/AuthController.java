package DATN.backend.controller.v1;

import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.request.auth.LoginRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.service.InterfaceService.InterfaceAuthService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Validated
public class AuthController {

    private final InterfaceAuthService authService;

    @Operation(summary = "Login with username and password")
    @PostMapping
    public ResponseEntity<ApiResponse> login(@Valid @RequestBody LoginRequest request) {
        ApiResponse response = authService.login(request);
        Object data = response.getData();
        if (data instanceof DATN.backend.response.auth.LoginResponse loginResponse) {
            return ResponseEntity.ok()
                    .header(HttpHeaders.AUTHORIZATION, loginResponse.getTokenType() + " " + loginResponse.getToken())
                    .body(response);
        }
        return ResponseEntity.ok(response);
    }
}