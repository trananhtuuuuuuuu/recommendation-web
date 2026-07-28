package DATN.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Stores one accepted English certificate and its recruiter-defined score.
 */
@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EnglishCertificateRequirement {

    @Column(name = "certificate_name", nullable = false)
    private String certificateName;

    @Column(name = "minimum_score", nullable = false)
    private String minimumScore;
}
