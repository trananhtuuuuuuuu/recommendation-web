package DATN.backend.service.InterfaceService;

import DATN.backend.response.job.ApplicantActivityCountResponse;
import DATN.backend.response.job.AnonymousCandidatePreviewsResponse;

public interface InterfaceApplicantPrivacyService {
    ApplicantActivityCountResponse getDifferentiallyPrivateApplicantCount(Long jobId, Long viewerApplicantId);

    AnonymousCandidatePreviewsResponse getAnonymousCandidatePreviews(Long jobId, Long viewerApplicantId);
}
