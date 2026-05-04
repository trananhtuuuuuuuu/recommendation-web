package DATN.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.ApplicantJobDescription;

@Repository
public interface ApplicantJobDescriptionRepository extends JpaRepository<ApplicantJobDescription, Long> {

}
