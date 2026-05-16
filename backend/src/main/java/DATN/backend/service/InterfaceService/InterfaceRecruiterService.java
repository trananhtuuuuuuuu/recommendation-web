package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RegistrationRecruiterRequest;
import DATN.backend.response.recruiter.RecruiterResponse;
import DATN.backend.response.recruiter.RegistrationRecruiterResponse;

import java.util.List;

public interface InterfaceRecruiterService {

    RegistrationRecruiterResponse registerRecruiter(RegistrationRecruiterRequest request);

    RecruiterResponse getRecruiterById(Long recruiterId);

    List<RecruiterResponse> getAllRecruiters();

}
