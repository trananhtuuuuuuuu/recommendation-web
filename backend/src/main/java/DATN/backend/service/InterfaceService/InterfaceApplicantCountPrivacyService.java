package DATN.backend.service.InterfaceService;

import DATN.backend.response.job.ApplicantCountReleaseResponse;

/**
 * Releases applicant-facing job counts with differential privacy.
 */
public interface InterfaceApplicantCountPrivacyService {

    /**
     * Returns the stable private count for the current job-relative window.
     *
     * @param jobId job identifier
     * @return current differentially private count release
     */
    ApplicantCountReleaseResponse getApplicantCountRelease(Long jobId);
}
