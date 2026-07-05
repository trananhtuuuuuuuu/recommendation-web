package DATN.backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.PrivacyRelease;

@Repository
public interface PrivacyReleaseRepository extends JpaRepository<PrivacyRelease, Long> {
    Optional<PrivacyRelease> findByReleaseKey(String releaseKey);
}
