package DATN.backend.model;

import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "privacy_releases", uniqueConstraints = {
        @UniqueConstraint(name = "uk_privacy_release_key", columnNames = "release_key")
})
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PrivacyRelease {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "release_key", nullable = false, length = 512)
    private String releaseKey;

    @Column(name = "metric_name", nullable = false, length = 128)
    private String metricName;

    @Column(name = "job_id", nullable = false)
    private Long jobId;

    @Column(name = "audience", nullable = false, length = 64)
    private String audience;

    @Column(name = "release_window", nullable = false, length = 64)
    private String releaseWindow;

    @Column(name = "released_value", nullable = false)
    private Long releasedValue;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    public PrivacyRelease(String releaseKey, String metricName, Long jobId, String audience, String releaseWindow,
            Long releasedValue) {
        this.releaseKey = releaseKey;
        this.metricName = metricName;
        this.jobId = jobId;
        this.audience = audience;
        this.releaseWindow = releaseWindow;
        this.releasedValue = releasedValue;
        this.createdAt = Instant.now();
    }
}
