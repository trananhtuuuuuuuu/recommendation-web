package DATN.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.ApplicantJobDescription;

@Repository
public interface ApplicantJobDescriptionRepository extends JpaRepository<ApplicantJobDescription, Long> {

    List<ApplicantJobDescription> findByApplicant_Id(Long applicantId);

    Optional<ApplicantJobDescription> findByApplicant_IdAndJobDescription_Id(Long applicantId, Long jobDescriptionId);

}
