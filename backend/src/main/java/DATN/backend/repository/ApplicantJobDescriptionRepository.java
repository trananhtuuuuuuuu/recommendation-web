package DATN.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.ApplicantJobDescription;

@Repository
public interface ApplicantJobDescriptionRepository extends JpaRepository<ApplicantJobDescription, Long> {

    List<ApplicantJobDescription> findByApplicant_Id(Long applicantId);

    List<ApplicantJobDescription> findByApplicant_IdAndActionType(Long applicantId, String actionType);

    List<ApplicantJobDescription> findByJobDescription_IdAndActionType(Long jobDescriptionId, String actionType);

    long countByJobDescription_IdAndActionType(Long jobDescriptionId, String actionType);

    Optional<ApplicantJobDescription> findByApplicant_IdAndJobDescription_Id(Long applicantId, Long jobDescriptionId);

    Optional<ApplicantJobDescription> findByApplicant_IdAndJobDescription_IdAndActionType(Long applicantId,
            Long jobDescriptionId, String actionType);

    /**
     * Finds a saved or applied relation owned by an applicant.
     *
     * @param id relation identifier
     * @param applicantId applicant owner identifier
     * @param actionType relation action type
     * @return matching relation when it exists
     */
    Optional<ApplicantJobDescription> findByIdAndApplicant_IdAndActionType(Long id, Long applicantId,
            String actionType);

}
