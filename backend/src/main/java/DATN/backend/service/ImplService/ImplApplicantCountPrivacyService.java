package DATN.backend.service.ImplService;

import java.sql.Date;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.config.PrivacyProperties;
import DATN.backend.exception.ForbiddenException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.model.Job;
import DATN.backend.model.PrivacyRelease;
import DATN.backend.repository.ApplicantJobRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.repository.PrivacyReleaseRepository;
import DATN.backend.response.job.ApplicantCountReleaseResponse;
import DATN.backend.service.InterfaceService.InterfaceApplicantCountPrivacyService;
import lombok.RequiredArgsConstructor;

/**
 * Publishes a stable differentially private applicant count every 12 hours.
 *
 * <p>Each applicant contributes at most one to the distinct count, so the
 * query sensitivity is one. The exact count and sampled noise remain local to
 * the release operation and are neither logged nor persisted.</p>
 */
@Service
@RequiredArgsConstructor
public class ImplApplicantCountPrivacyService implements InterfaceApplicantCountPrivacyService {

    static final Duration RELEASE_INTERVAL = Duration.ofHours(12);
    private static final String APPLIED_ACTION = "APPLIED";
    private static final String COUNT_METRIC = "JOB_APPLICANT_COUNT_V2";
    private static final String APPLICANT_AUDIENCE = "APPLICANT";
    private static final String RELEASE_KEY_VERSION = "v2";
    private static final ZoneId LEGACY_PUBLISH_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    private final JobRepository jobRepository;
    private final ApplicantJobRepository applicantJobRepository;
    private final PrivacyReleaseRepository privacyReleaseRepository;
    private final PrivacyProperties privacyProperties;
    private final DiscreteLaplaceNoiseGenerator noiseGenerator;

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public ApplicantCountReleaseResponse getApplicantCountRelease(Long jobId) {
        Job job = jobRepository.findByIdForUpdate(jobId)
                .orElseThrow(() -> new ResourcesNotFoundException("Job description not found"));
        PrivacyProperties.ApplicantCount config = privacyProperties.getDifferential().getApplicantCount();
        if (!privacyProperties.getDifferential().isEnabled()) {
            throw new ForbiddenException("Applicant count privacy release is disabled");
        }

        Instant now = Instant.now();
        Instant publishedAt = resolvePublishedAt(job, now);
        ReleaseWindow window = calculateWindow(publishedAt, now);
        String releaseWindow = "job-window-" + window.index();
        String releaseKey = releaseKey(jobId, window.index());

        PrivacyRelease release = privacyReleaseRepository.findByReleaseKey(releaseKey)
                .orElseGet(() -> createRelease(jobId, releaseKey, releaseWindow, config.getEpsilon()));

        return new ApplicantCountReleaseResponse(
                jobId,
                release.getReleasedValue(),
                displayText(release.getReleasedValue()),
                release.getCreatedAt(),
                window.endsAt(),
                (int) RELEASE_INTERVAL.toHours());
    }

    static ReleaseWindow calculateWindow(Instant publishedAt, Instant now) {
        long elapsedSeconds = Math.max(0L, Duration.between(publishedAt, now).getSeconds());
        long intervalSeconds = RELEASE_INTERVAL.toSeconds();
        long windowIndex = elapsedSeconds / intervalSeconds;
        Instant windowEndsAt = publishedAt.plusSeconds(Math.multiplyExact(windowIndex + 1L, intervalSeconds));
        return new ReleaseWindow(windowIndex, windowEndsAt);
    }

    static long applyNoise(long exactCount, long noise) {
        return Math.max(0L, Math.addExact(exactCount, noise));
    }

    private PrivacyRelease createRelease(Long jobId, String releaseKey, String releaseWindow, double epsilon) {
        long exactCount = applicantJobRepository.countDistinctApplicantsByJobAndActionType(jobId, APPLIED_ACTION);
        long releasedCount = applyNoise(exactCount, noiseGenerator.sample(epsilon));
        return privacyReleaseRepository.save(
                new PrivacyRelease(releaseKey, COUNT_METRIC, jobId, APPLICANT_AUDIENCE, releaseWindow,
                        releasedCount));
    }

    private String releaseKey(Long jobId, long windowIndex) {
        return String.join("|",
                RELEASE_KEY_VERSION,
                COUNT_METRIC,
                "jobId=" + jobId,
                "audience=" + APPLICANT_AUDIENCE,
                "window=" + windowIndex);
    }

    private Instant resolvePublishedAt(Job job, Instant fallback) {
        if (job.getPublishedAt() != null) {
            return job.getPublishedAt();
        }
        Date postedDate = job.getPostedDate();
        Instant resolved = postedDate == null
                ? fallback
                : postedDate.toLocalDate().atStartOfDay(LEGACY_PUBLISH_ZONE).toInstant();
        job.setPublishedAt(resolved);
        return resolved;
    }

    private String displayText(long count) {
        return count + (count == 1L ? " candidate has applied" : " candidates have applied");
    }

    /**
     * Identifies one job-relative private release window.
     *
     * @param index zero-based release-window index
     * @param endsAt exclusive end of the release window
     */
    record ReleaseWindow(long index, Instant endsAt) {
    }
}
