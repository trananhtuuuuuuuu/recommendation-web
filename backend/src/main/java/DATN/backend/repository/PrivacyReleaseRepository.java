package DATN.backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.PrivacyRelease;

/**
 * Persists stable differentially private aggregate releases.
 */
@Repository
public interface PrivacyReleaseRepository extends JpaRepository<PrivacyRelease, Long> {

    /**
     * Finds the value already released for a unique privacy window.
     *
     * @param releaseKey unique release key
     * @return persisted release when one exists
     */
    Optional<PrivacyRelease> findByReleaseKey(String releaseKey);
}
