package DATN.backend.service.InterfaceService;

import DATN.backend.request.applicant.SaveJobRequest;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.request.applicant.RegistrationApplicantRequest;
import DATN.backend.response.ApiResponse;

public interface InterfaceApplicantService {

    ApiResponse registerApplicant(RegistrationApplicantRequest request);

    ApiResponse getApplicantById(Long applicantId);

    ApiResponse getAllApplicants();

    ApiResponse updateApplicant(Long applicantId, UpdateApplicantRequest request);

    ApiResponse saveJob(SaveJobRequest request);

    ApiResponse getSavedJobs(Long applicantId);

    ApiResponse uploadCv(Long applicantId, UploadCvRequest request);

}
