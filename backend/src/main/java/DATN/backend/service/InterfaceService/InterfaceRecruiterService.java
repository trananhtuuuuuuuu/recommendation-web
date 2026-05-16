package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RegistrationRecruiterRequest;
import DATN.backend.response.ApiResponse;

public interface InterfaceRecruiterService {

    ApiResponse registerRecruiter(RegistrationRecruiterRequest request);

    ApiResponse getRecruiterById(Long recruiterId);

    ApiResponse getAllRecruiters();

}
