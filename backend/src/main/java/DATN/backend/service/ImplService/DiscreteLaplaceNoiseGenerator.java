package DATN.backend.service.ImplService;

import java.security.SecureRandom;

import org.springframework.stereotype.Component;

/**
 * Samples integer noise from the two-sided geometric distribution.
 *
 * <p>For a count query with sensitivity one, this distribution is the
 * discrete counterpart of Laplace noise and provides epsilon-differential
 * privacy for one release.</p>
 */
@Component
public class DiscreteLaplaceNoiseGenerator {

    private final SecureRandom secureRandom;

    /**
     * Creates a generator backed by a cryptographically strong random source.
     */
    public DiscreteLaplaceNoiseGenerator() {
        this(new SecureRandom());
    }

    DiscreteLaplaceNoiseGenerator(SecureRandom secureRandom) {
        this.secureRandom = secureRandom;
    }

    /**
     * Samples discrete Laplace noise for the supplied epsilon.
     *
     * @param epsilon privacy parameter greater than zero
     * @return signed integer noise
     * @throws IllegalArgumentException when epsilon is not finite and positive
     */
    public long sample(double epsilon) {
        return sample(epsilon, secureRandom.nextDouble(), secureRandom.nextDouble());
    }

    static long sample(double epsilon, double positiveUniform, double negativeUniform) {
        validateEpsilon(epsilon);
        return sampleGeometric(epsilon, positiveUniform) - sampleGeometric(epsilon, negativeUniform);
    }

    private static long sampleGeometric(double epsilon, double uniform) {
        if (uniform < 0.0 || uniform >= 1.0 || !Double.isFinite(uniform)) {
            throw new IllegalArgumentException("uniform samples must be finite values in [0, 1)");
        }
        return (long) Math.floor(-Math.log1p(-uniform) / epsilon);
    }

    private static void validateEpsilon(double epsilon) {
        if (!Double.isFinite(epsilon) || epsilon <= 0.0) {
            throw new IllegalArgumentException("epsilon must be finite and greater than zero");
        }
    }
}
