package DATN.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.Applicant;

@Repository
public interface ApplicantRepository extends JpaRepository<Applicant, Long> {

}
