package DATN.backend.service.InterfaceService;

import DATN.backend.request.recruiter.RegistrationRecruiterRequest;
import DATN.backend.request.recruiter.UpdateRecruiterRequest;
import DATN.backend.response.recruiter.RecruiterResponse;
import DATN.backend.response.recruiter.RegistrationRecruiterResponse;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface InterfaceRecruiterService {

    RegistrationRecruiterResponse registerRecruiter(RegistrationRecruiterRequest request);

    RecruiterResponse getRecruiterById(Long recruiterId);

    List<RecruiterResponse> getAllRecruiters();

    RecruiterResponse updateRecruiter(Long recruiterId, UpdateRecruiterRequest request);

    /**
     * Stores and assigns one of the recruiter's public company images.
     *
     * @param recruiterId recruiter owner identifier
     * @param imageType supported type: {@code logo} or {@code cover}
     * @param image uploaded image file
     * @return updated recruiter profile
     */
    RecruiterResponse uploadProfileImage(Long recruiterId, String imageType, MultipartFile image);

}
