package DATN.backend.service.InterfaceService;

import DATN.backend.request.auth.LoginRequest;
import DATN.backend.response.ApiResponse;

public interface InterfaceAuthService {

    ApiResponse login(LoginRequest request);
}