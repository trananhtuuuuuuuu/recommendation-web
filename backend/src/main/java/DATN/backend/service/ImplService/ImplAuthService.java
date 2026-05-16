package DATN.backend.service.ImplService;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.repository.UserRepository;
import DATN.backend.request.auth.LoginRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.response.auth.LoginResponse;
import DATN.backend.security.InforInsideToken;
import DATN.backend.security.JwtService;
import DATN.backend.service.InterfaceService.InterfaceAuthService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplAuthService implements InterfaceAuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Override
    public ApiResponse login(LoginRequest request) {
        var user = userRepository.findByUserName(request.getUserName())
                .orElseThrow(() -> new ResourcesNotFoundException("User not found"));
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new ResourcesNotFoundException("Invalid credentials");
        }
        String roleName = user.getRole() == null ? "USER" : user.getRole().getRoleName();
        InforInsideToken info = new InforInsideToken(user.getId(), user.getUserName(), user.getEmail(), roleName);
        String token = jwtService.generateToken(info);
        LoginResponse response = new LoginResponse(token, "Bearer", user.getId(), user.getUserName(), user.getEmail(),
                roleName);
        return new ApiResponse("Login successful", HttpStatus.OK.value(), null, null, response);
    }
}