package DATN.backend.service.ImplService;

import static org.assertj.core.api.Assertions.assertThat;

import java.nio.ByteBuffer;

import org.junit.jupiter.api.Test;

class ImplApplicantPrivacyServiceTests {

    private static final double EPSILON_FOR_Q_HALF = Math.log(2.0);

    @Test
    void shouldMapUniformValuesToExpectedGeometricCdfIntervals() {
        assertThat(ImplApplicantPrivacyService.sampleGeometric(EPSILON_FOR_Q_HALF, 0.49)).isZero();
        assertThat(ImplApplicantPrivacyService.sampleGeometric(EPSILON_FOR_Q_HALF, 0.60)).isEqualTo(1L);
        assertThat(ImplApplicantPrivacyService.sampleGeometric(EPSILON_FOR_Q_HALF, 0.80)).isEqualTo(2L);
    }

    @Test
    void shouldCreatePositiveNoiseFromDifferenceOfTwoGeometricSamples() {
        byte[] randomBytes = randomBytesFor(0.80, 0.20);

        long noise = ImplApplicantPrivacyService.sampleDiscreteLaplace(EPSILON_FOR_Q_HALF, randomBytes);

        assertThat(noise).isEqualTo(2L);
    }

    @Test
    void shouldCreateNegativeNoiseFromDifferenceOfTwoGeometricSamples() {
        byte[] randomBytes = randomBytesFor(0.20, 0.80);

        long noise = ImplApplicantPrivacyService.sampleDiscreteLaplace(EPSILON_FOR_Q_HALF, randomBytes);

        assertThat(noise).isEqualTo(-2L);
    }

    @Test
    void shouldCreateZeroNoiseWhenGeometricSamplesAreEqual() {
        byte[] randomBytes = randomBytesFor(0.60, 0.60);

        long noise = ImplApplicantPrivacyService.sampleDiscreteLaplace(EPSILON_FOR_Q_HALF, randomBytes);

        assertThat(noise).isZero();
    }

    private byte[] randomBytesFor(double firstUniform, double secondUniform) {
        byte[] bytes = new byte[32];
        putUniform(bytes, 0, firstUniform);
        putUniform(bytes, Long.BYTES, secondUniform);
        return bytes;
    }

    private void putUniform(byte[] bytes, int offset, double uniform) {
        long unitValue = (long) Math.floor(uniform * Long.MAX_VALUE);
        ByteBuffer.wrap(bytes, offset, Long.BYTES).putLong(unitValue << 1);
    }
}
