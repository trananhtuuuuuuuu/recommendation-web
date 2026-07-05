package DATN.backend.config;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import jakarta.annotation.PostConstruct;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Validated
@ConfigurationProperties(prefix = "privacy")
public class PrivacyProperties {

    @Valid
    private Differential differential = new Differential();

    @Valid
    private AnonymousCandidatePreview anonymousCandidatePreview = new AnonymousCandidatePreview();

    @PostConstruct
    void validate() {
        applicantCount().validate();
        anonymousCandidatePreview.validate();
    }

    private ApplicantCount applicantCount() {
        return differential.getApplicantCount();
    }

    @Getter
    @Setter
    public static class Differential {
        private boolean enabled = true;

        @Valid
        private ApplicantCount applicantCount = new ApplicantCount();
    }

    @Getter
    @Setter
    public static class ApplicantCount {
        @Positive(message = "privacy.differential.applicant-count.epsilon must be greater than zero")
        private double epsilon = 0.5;

        private Duration releaseWindow = Duration.ofDays(7);

        @NotBlank(message = "privacy.differential.applicant-count.release-secret must be configured")
        private String releaseSecret = "local-development-dp-release-secret-change-me";

        void validate() {
            if (releaseWindow == null || releaseWindow.isZero() || releaseWindow.isNegative()) {
                throw new IllegalArgumentException(
                        "privacy.differential.applicant-count.release-window must be positive");
            }
        }
    }

    @Getter
    @Setter
    public static class AnonymousCandidatePreview {
        private boolean enabled = true;

        @Min(value = 2, message = "privacy.anonymous-candidate-preview.minimum-eligible-candidates must be at least 2")
        private int minimumEligibleCandidates = 10;

        @Min(value = 1, message = "privacy.anonymous-candidate-preview.maximum-previews must be at least 1")
        private int maximumPreviews = 3;

        private Duration rotationWindow = Duration.ofDays(7);

        @Min(value = 1, message = "privacy.anonymous-candidate-preview.rate-limit-per-window must be at least 1")
        private int rateLimitPerWindow = 20;

        @NotBlank(message = "privacy.anonymous-candidate-preview.token-secret must be configured")
        private String tokenSecret = "local-development-anonymous-preview-secret-change-me";

        void validate() {
            if (rotationWindow == null || rotationWindow.isZero() || rotationWindow.isNegative()) {
                throw new IllegalArgumentException(
                        "privacy.anonymous-candidate-preview.rotation-window must be positive");
            }
        }
    }
}
