package DATN.backend.response.job;

import java.time.Instant;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Represents the applicant-facing differentially private count release.
 *
 * <p>{@code applicantCount} is a non-negative noisy value. The exact count,
 * sampled noise, and epsilon are never serialized in this response.</p>
 */
@Getter
@AllArgsConstructor
public class ApplicantCountReleaseResponse {

    @Schema(description = "Job identifier")
    private Long jobId;

    @Schema(description = "Differentially private applicant count released to applicants")
    private Long applicantCount;

    @Schema(description = "Display-ready text containing the released count")
    private String displayText;

    @Schema(description = "Time at which this window's private value was released")
    private Instant snapshotCapturedAt;

    @Schema(description = "Start of the next job-relative release window")
    private Instant nextRefreshAt;

    @Schema(description = "Applicant count release interval in hours", example = "12")
    private int refreshIntervalHours;
}
