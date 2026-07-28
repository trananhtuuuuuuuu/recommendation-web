package DATN.backend.service.InterfaceService;

import DATN.backend.response.job.AnonymousCandidatePreviewsResponse;

/**
 * Provides consent-based anonymous applicant previews.
 */
public interface InterfaceApplicantPrivacyService {

    /**
     * Returns anonymous candidate previews to an eligible applicant.
     *
     * @param jobId job identifier
     * @param viewerApplicantId viewing applicant identifier
     * @return consent-filtered anonymous profiles
     */
    AnonymousCandidatePreviewsResponse getAnonymousCandidatePreviews(Long jobId, Long viewerApplicantId);
}
