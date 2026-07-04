package DATN.backend.service.InterfaceService;

import DATN.backend.request.applicant.SaveJobRequest;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UpdateApplicantPrivacyRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.request.applicant.RegistrationApplicantRequest;
import DATN.backend.response.applicant.ApplicantResponse;
import DATN.backend.response.applicant.RegistrationApplicantResponse;
import DATN.backend.response.applicant.SavedJobResponse;
import DATN.backend.response.cv.CvResponse;
import DATN.backend.response.PageResponse;

import java.util.List;

import org.springframework.data.domain.Pageable;

public interface InterfaceApplicantService {

    RegistrationApplicantResponse registerApplicant(RegistrationApplicantRequest request);

    ApplicantResponse getApplicantById(Long applicantId, boolean fullAccess);

    List<ApplicantResponse> getAllApplicants(boolean fullAccess);

    ApplicantResponse updateApplicant(Long applicantId, UpdateApplicantRequest request);

    ApplicantResponse updateApplicantPrivacy(Long applicantId, UpdateApplicantPrivacyRequest request);

    SavedJobResponse saveJob(SaveJobRequest request);

    SavedJobResponse applyJob(SaveJobRequest request);

    PageResponse<SavedJobResponse> getSavedJobs(Long applicantId, Pageable pageable);

    PageResponse<SavedJobResponse> getAppliedJobs(Long applicantId, Pageable pageable);

    /**
     * Removes a job from an applicant's saved list.
     *
     * @param applicantId applicant owner identifier
     * @param applicantJobId saved relation identifier
     * @return removed saved-job relation
     */
    SavedJobResponse removeSavedJob(Long applicantId, Long applicantJobId);

    /**
     * Withdraws an applicant's submitted job application.
     *
     * @param applicantId applicant owner identifier
     * @param applicantJobId applied relation identifier
     * @return removed application relation
     */
    SavedJobResponse withdrawApplication(Long applicantId, Long applicantJobId);

    CvResponse uploadCv(Long applicantId, UploadCvRequest request);

    CvResponse deleteUploadedCvFile(Long applicantId);

}
