package DATN.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.ApplicantJob;

@Repository
public interface ApplicantJobRepository extends JpaRepository<ApplicantJob, Long> {

    List<ApplicantJob> findByApplicant_Id(Long applicantId);

    List<ApplicantJob> findByApplicant_IdAndActionType(Long applicantId, String actionType);

    List<ApplicantJob> findByJob_IdAndActionType(Long jobDescriptionId, String actionType);

    long countByJob_IdAndActionType(Long jobDescriptionId, String actionType);

    Optional<ApplicantJob> findByApplicant_IdAndJob_Id(Long applicantId, Long jobDescriptionId);

    Optional<ApplicantJob> findByApplicant_IdAndJob_IdAndActionType(Long applicantId,
            Long jobDescriptionId, String actionType);

    /**
     * Finds a saved or applied relation owned by an applicant.
     *
     * @param id relation identifier
     * @param applicantId applicant owner identifier
     * @param actionType relation action type
     * @return matching relation when it exists
     */
    Optional<ApplicantJob> findByIdAndApplicant_IdAndActionType(Long id, Long applicantId,
            String actionType);

}
