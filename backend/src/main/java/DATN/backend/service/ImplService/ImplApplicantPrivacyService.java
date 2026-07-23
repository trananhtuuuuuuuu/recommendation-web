package DATN.backend.service.ImplService;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.config.PrivacyProperties;
import DATN.backend.exception.ForbiddenException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.model.Applicant;
import DATN.backend.model.ApplicantJob;
import DATN.backend.model.Cv;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
import DATN.backend.model.PrivacyRelease;
import DATN.backend.repository.ApplicantJobRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.repository.PrivacyReleaseRepository;
import DATN.backend.response.job.ApplicantActivityCountResponse;
import DATN.backend.response.job.AnonymousCandidatePreviewProfileResponse;
import DATN.backend.response.job.AnonymousCandidatePreviewsResponse;
import DATN.backend.service.InterfaceService.InterfaceApplicantPrivacyService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplApplicantPrivacyService implements InterfaceApplicantPrivacyService {

    private static final String APPLIED_ACTION = "APPLIED";
    private static final String COUNT_METRIC = "JOB_APPLICANT_COUNT";
    private static final String APPLICANT_AUDIENCE = "APPLICANT";
    private static final String HMAC_ALGORITHM = "HmacSHA256";
    private static final String UNAVAILABLE_MESSAGE = "Anonymous candidate previews are unavailable for this job.";

    private final JobRepository jobRepository;
    private final ApplicantJobRepository applicantJobRepository;
    private final PrivacyReleaseRepository privacyReleaseRepository;
    private final PrivacyProperties privacyProperties;
    private final Map<String, Integer> anonymousPreviewRateLimits = new ConcurrentHashMap<>();

    @Override
    @Transactional
    public ApplicantActivityCountResponse getDifferentiallyPrivateApplicantCount(Long jobId, Long viewerApplicantId) {
        requireExistingJob(jobId);
        if (!privacyProperties.getDifferential().isEnabled()) {
            throw new ForbiddenException("Applicant activity privacy release is disabled");
        }
        PrivacyProperties.ApplicantCount config = privacyProperties.getDifferential().getApplicantCount();
        validateEpsilon(config.getEpsilon());
        String window = currentWindow(config.getReleaseWindow());
        String releaseKey = COUNT_METRIC + "|jobId=" + jobId + "|audience=" + APPLICANT_AUDIENCE + "|window=" + window;
        // Reuse the same release inside the window so refreshes cannot be averaged back toward the raw count.
        Long releasedCount = privacyReleaseRepository.findByReleaseKey(releaseKey)
                .map(PrivacyRelease::getReleasedValue)
                .orElseGet(() -> createApplicantCountRelease(jobId, config, window, releaseKey));
        return new ApplicantActivityCountResponse(
                jobId,
                releasedCount,
                "Approximately " + releasedCount + " candidates have applied",
                true);
    }

    @Override
    @Transactional(readOnly = true)
    public AnonymousCandidatePreviewsResponse getAnonymousCandidatePreviews(Long jobId, Long viewerApplicantId) {
        requireExistingJob(jobId);
        requireAppliedViewer(viewerApplicantId, jobId);
        PrivacyProperties.AnonymousCandidatePreview config = privacyProperties.getAnonymousCandidatePreview();
        if (!config.isEnabled()) {
            return unavailable();
        }
        String window = currentWindow(config.getRotationWindow());
        enforceRateLimit(viewerApplicantId, jobId, window, config.getRateLimitPerWindow());
        List<ApplicantJob> eligible = applicantJobRepository.findEligibleAnonymousPreviewApplications(jobId,
                viewerApplicantId, APPLIED_ACTION);
        if (eligible.size() < config.getMinimumEligibleCandidates()) {
            return unavailable();
        }
        return new AnonymousCandidatePreviewsResponse(
                true,
                "These candidates chose to share a limited anonymous profile. Identifying details are hidden.",
                eligible.stream()
                        .sorted(Comparator.comparing(relation -> hmacBase64(config.getTokenSecret(),
                                "sample|" + relation.getApplicant().getId() + "|" + jobId + "|" + window)))
                        .limit(config.getMaximumPreviews())
                        .map(relation -> toAnonymousProfile(relation.getApplicant(), viewerApplicantId, jobId, window,
                                config.getTokenSecret()))
                        .toList());
    }

    private Long createApplicantCountRelease(Long jobId, PrivacyProperties.ApplicantCount config, String window,
            String releaseKey) {
        // Sensitivity is 1 because one applicant can change COUNT(DISTINCT applicant_id) by at most one.
        // The raw count and generated noise stay inside this method and must never be serialized or logged.
        long rawCount = applicantJobRepository.countDistinctApplicantsByJobAndActionType(jobId, APPLIED_ACTION);
        long noise = sampleDiscreteLaplace(config.getEpsilon(),
                hmacBytes(config.getReleaseSecret(), releaseKey + "|noise"));
        long releasedCount = Math.max(0L, rawCount + noise);
        return privacyReleaseRepository
                .save(new PrivacyRelease(releaseKey, COUNT_METRIC, jobId, APPLICANT_AUDIENCE, window, releasedCount))
                .getReleasedValue();
    }

    static long sampleDiscreteLaplace(double epsilon, byte[] randomBytes) {
        // If G1 and G2 are independent Geometric(1 - exp(-epsilon)) samples,
        // G1 - G2 has the exact two-sided geometric (discrete Laplace) distribution.
        long positiveComponent = sampleGeometric(epsilon, unsignedLongUnit(randomBytes, 0));
        long negativeComponent = sampleGeometric(epsilon, unsignedLongUnit(randomBytes, Long.BYTES));
        return positiveComponent - negativeComponent;
    }

    static long sampleGeometric(double epsilon, double uniform) {
        // q = exp(-epsilon), so log(q) = -epsilon. log1p is stable when uniform is near zero.
        return (long) Math.floor(-Math.log1p(-uniform) / epsilon);
    }

    private static double unsignedLongUnit(byte[] bytes, int offset) {
        long value = ByteBuffer.wrap(bytes, offset, Long.BYTES).getLong() >>> 1;
        return Math.min(value / (double) Long.MAX_VALUE, Math.nextDown(1.0));
    }

    private AnonymousCandidatePreviewProfileResponse toAnonymousProfile(Applicant candidate, Long viewerApplicantId,
            Long jobId, String window, String secret) {
        Cv cv = candidate.getCv();
        Experience experience = cv == null ? null : cv.getExperienceObj();
        Education education = cv == null ? null : cv.getEducationObj();
        List<String> skillCategories = cv == null ? List.of() : toSkillCategories(cv.getSkills());
        String token = hmacBase64(secret,
                "candidate|" + candidate.getId() + "|job|" + jobId + "|viewer|" + viewerApplicantId + "|window|"
                        + window);
        return new AnonymousCandidatePreviewProfileResponse(
                "candidate-" + token.substring(0, Math.min(8, token.length())),
                toExperienceBucket(experience),
                skillCategories,
                toEducationLevel(education),
                toGeneralRegion(candidate.getAddress(), cv == null ? null : cv.getAddress()),
                toRoleCategory(experience));
    }

    private List<String> toSkillCategories(List<String> skills) {
        if (skills == null || skills.isEmpty()) {
            return List.of("General Software");
        }
        Set<String> categories = new LinkedHashSet<>();
        for (String skill : skills) {
            String normalized = skill == null ? "" : skill.toLowerCase(Locale.ROOT);
            if (normalized.matches(".*(java|spring|node|api|backend|python|go|\\.net).*")) {
                categories.add("Backend");
            }
            if (normalized.matches(".*(react|vue|angular|css|html|frontend|typescript|javascript).*")) {
                categories.add("Frontend");
            }
            if (normalized.matches(".*(sql|postgres|mysql|mongodb|redis|database).*")) {
                categories.add("Database");
            }
            if (normalized.matches(".*(aws|azure|gcp|cloud).*")) {
                categories.add("Cloud");
            }
            if (normalized.matches(".*(docker|kubernetes|ci|cd|devops).*")) {
                categories.add("DevOps");
            }
            if (normalized.matches(".*(data|analytics|warehouse|etl).*")) {
                categories.add("Data");
            }
            if (normalized.matches(".*(machine learning|ml|ai|tensorflow|pytorch).*")) {
                categories.add("Machine Learning");
            }
            if (normalized.matches(".*(android|ios|flutter|mobile).*")) {
                categories.add("Mobile");
            }
            if (normalized.matches(".*(test|qa|quality).*")) {
                categories.add("Quality Assurance");
            }
            if (normalized.matches(".*(figma|design|ux|ui).*")) {
                categories.add("Product Design");
            }
        }
        if (categories.isEmpty()) {
            categories.add("General Software");
        }
        return new ArrayList<>(categories).stream().limit(3).toList();
    }

    private String toExperienceBucket(Experience experience) {
        String period = experience == null ? null : experience.getTime();
        if (period != null && period.matches(".*([4-9]|[1-9][0-9])\\+?.*")) {
            return "4+ years";
        }
        if (period != null && period.matches(".*[1-3].*")) {
            return "1-3 years";
        }
        return "0-1 years";
    }

    private String toEducationLevel(Education education) {
        if (education == null || education.getDegree() == null) {
            return "Not specified";
        }
        return switch (education.getDegree().name()) {
            case "MSc", "Master", "MASTER" -> "Master's degree";
            case "PhD", "PHD", "Doctorate" -> "Doctorate";
            default -> "Bachelor's degree";
        };
    }

    private String toGeneralRegion(String applicantAddress, String cvAddress) {
        String address = ((applicantAddress == null ? "" : applicantAddress) + " " + (cvAddress == null ? "" : cvAddress))
                .toLowerCase(Locale.ROOT);
        if (address.matches(".*(ho chi minh|hcm|can tho|dong nai|binh duong|southern).*")) {
            return "Southern Vietnam";
        }
        if (address.matches(".*(da nang|hue|central).*")) {
            return "Central Vietnam";
        }
        if (address.matches(".*(hanoi|ha noi|hai phong|northern).*")) {
            return "Northern Vietnam";
        }
        return "Vietnam";
    }

    private String toRoleCategory(Experience experience) {
        String text = experience == null ? "" : (experience.getJobTitle() + " " + experience.getField())
                .toLowerCase(Locale.ROOT);
        if (text.matches(".*(frontend|react|ui).*")) {
            return "Frontend";
        }
        if (text.matches(".*(data|analytics|machine learning|ai).*")) {
            return "Data";
        }
        if (text.matches(".*(qa|test|quality).*")) {
            return "Quality Assurance";
        }
        return "Backend";
    }

    private void requireExistingJob(Long jobId) {
        if (!jobRepository.existsById(jobId)) {
            throw new ResourcesNotFoundException("Job description not found");
        }
    }

    private void requireAppliedViewer(Long viewerApplicantId, Long jobId) {
        if (viewerApplicantId == null
                || !applicantJobRepository.existsActiveRelation(viewerApplicantId, jobId, APPLIED_ACTION)) {
            throw new ForbiddenException("Applicant activity is available only to applicants who applied for this job");
        }
    }

    private void enforceRateLimit(Long viewerApplicantId, Long jobId, String window, int limit) {
        String key = viewerApplicantId + "|" + jobId + "|" + window;
        int attempts = anonymousPreviewRateLimits.merge(key, 1, Integer::sum);
        if (attempts > limit) {
            throw new ForbiddenException("Anonymous candidate preview rate limit exceeded");
        }
    }

    private void validateEpsilon(double epsilon) {
        if (epsilon <= 0.0) {
            throw new IllegalArgumentException(
                    "privacy.differential.applicant-count.epsilon must be greater than zero");
        }
    }

    private AnonymousCandidatePreviewsResponse unavailable() {
        return new AnonymousCandidatePreviewsResponse(false, UNAVAILABLE_MESSAGE, List.of());
    }

    private String currentWindow(Duration duration) {
        long windowSeconds = duration.toSeconds();
        long windowIndex = Instant.now().getEpochSecond() / windowSeconds;
        return "epoch-window-" + windowIndex;
    }

    private byte[] hmacBytes(String secret, String input) {
        try {
            // The secret makes the output deterministic for this release key but unpredictable to clients.
            // Do not log the secret, HMAC input, digest, seed, raw count, or noise.
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM));
            return mac.doFinal(input.getBytes(StandardCharsets.UTF_8));
        } catch (Exception exception) {
            throw new IllegalStateException("Unable to generate privacy token", exception);
        }
    }

    private String hmacBase64(String secret, String input) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(hmacBytes(secret, input));
    }
}
