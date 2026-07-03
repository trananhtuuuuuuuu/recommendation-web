package DATN.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.Certificate;

@Repository
public interface CertificateRepository extends JpaRepository<Certificate, Long> {
}
