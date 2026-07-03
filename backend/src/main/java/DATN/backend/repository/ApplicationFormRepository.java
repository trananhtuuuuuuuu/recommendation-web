package DATN.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.ApplicationForm;

@Repository
public interface ApplicationFormRepository extends JpaRepository<ApplicationForm, Long> {
}
