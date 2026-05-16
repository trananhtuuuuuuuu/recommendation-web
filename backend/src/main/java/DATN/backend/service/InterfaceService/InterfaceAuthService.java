package DATN.backend.service.InterfaceService;

import DATN.backend.request.auth.LoginRequest;
import DATN.backend.response.auth.LoginResponse;

public interface InterfaceAuthService {

    LoginResponse login(LoginRequest request);
}
