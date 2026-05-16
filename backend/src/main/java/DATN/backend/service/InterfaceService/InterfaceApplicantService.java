package DATN.backend.service.InterfaceService;

import DATN.backend.request.applicant.SaveJobRequest;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.request.applicant.RegistrationApplicantRequest;
import DATN.backend.response.applicant.ApplicantResponse;
import DATN.backend.response.applicant.RegistrationApplicantResponse;
import DATN.backend.response.applicant.SavedJobResponse;
import DATN.backend.response.cv.CvResponse;

import java.util.List;

public interface InterfaceApplicantService {

    RegistrationApplicantResponse registerApplicant(RegistrationApplicantRequest request);

    ApplicantResponse getApplicantById(Long applicantId);

    List<ApplicantResponse> getAllApplicants();

    ApplicantResponse updateApplicant(Long applicantId, UpdateApplicantRequest request);

    SavedJobResponse saveJob(SaveJobRequest request);

    List<SavedJobResponse> getSavedJobs(Long applicantId);

    CvResponse uploadCv(Long applicantId, UploadCvRequest request);

}
