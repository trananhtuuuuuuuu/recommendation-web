package DATN.backend.service.ImplService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;

class DiscreteLaplaceNoiseGeneratorTests {

    @Test
    void shouldSamplePositiveNegativeAndZeroNoise() {
        assertThat(DiscreteLaplaceNoiseGenerator.sample(0.5, 0.9, 0.1)).isEqualTo(4L);
        assertThat(DiscreteLaplaceNoiseGenerator.sample(0.5, 0.1, 0.9)).isEqualTo(-4L);
        assertThat(DiscreteLaplaceNoiseGenerator.sample(0.5, 0.0, 0.0)).isZero();
    }

    @Test
    void shouldRejectInvalidEpsilonAndUniformSamples() {
        assertThatThrownBy(() -> DiscreteLaplaceNoiseGenerator.sample(0.0, 0.5, 0.5))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> DiscreteLaplaceNoiseGenerator.sample(Double.NaN, 0.5, 0.5))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> DiscreteLaplaceNoiseGenerator.sample(0.5, 1.0, 0.5))
                .isInstanceOf(IllegalArgumentException.class);
    }
}
