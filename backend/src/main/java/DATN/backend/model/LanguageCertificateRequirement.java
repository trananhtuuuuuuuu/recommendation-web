package DATN.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Stores one recruiter-defined certificate accepted for a language requirement.
 */
@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LanguageCertificateRequirement {

    @Column(name = "certificate_name", nullable = false)
    private String certificateName;

    @Column(name = "minimum_score", nullable = false)
    private String minimumScore;
}
