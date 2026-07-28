package DATN.backend.service.ImplService;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Instant;

import org.junit.jupiter.api.Test;

class ImplApplicantCountPrivacyServiceTests {

    @Test
    void shouldAnchorReleaseWindowsToTheJobPublishTime() {
        Instant publishedAt = Instant.parse("2026-07-28T01:15:00Z");

        ImplApplicantCountPrivacyService.ReleaseWindow firstWindow =
                ImplApplicantCountPrivacyService.calculateWindow(
                        publishedAt,
                        Instant.parse("2026-07-28T12:00:00Z"));
        ImplApplicantCountPrivacyService.ReleaseWindow secondWindow =
                ImplApplicantCountPrivacyService.calculateWindow(
                        publishedAt,
                        Instant.parse("2026-07-28T13:15:00Z"));

        assertThat(firstWindow.index()).isZero();
        assertThat(firstWindow.endsAt()).isEqualTo("2026-07-28T13:15:00Z");
        assertThat(secondWindow.index()).isEqualTo(1L);
        assertThat(secondWindow.endsAt()).isEqualTo("2026-07-29T01:15:00Z");
    }

    @Test
    void shouldUseTheFirstWindowWhenTheClockPrecedesPublishTime() {
        ImplApplicantCountPrivacyService.ReleaseWindow window =
                ImplApplicantCountPrivacyService.calculateWindow(
                        Instant.parse("2026-07-28T13:15:00Z"),
                        Instant.parse("2026-07-28T13:14:59Z"));

        assertThat(window.index()).isZero();
        assertThat(window.endsAt()).isEqualTo("2026-07-29T01:15:00Z");
    }

    @Test
    void shouldClampNegativeReleasedCountsToZero() {
        assertThat(ImplApplicantCountPrivacyService.applyNoise(2L, 3L)).isEqualTo(5L);
        assertThat(ImplApplicantCountPrivacyService.applyNoise(2L, -1L)).isEqualTo(1L);
        assertThat(ImplApplicantCountPrivacyService.applyNoise(2L, -5L)).isZero();
    }
}
