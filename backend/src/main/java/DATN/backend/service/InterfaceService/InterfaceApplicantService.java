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

    SavedJobResponse applyJob(SaveJobRequest request);

    List<SavedJobResponse> getSavedJobs(Long applicantId);

    List<SavedJobResponse> getAppliedJobs(Long applicantId);

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

}
