package DATN.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import DATN.backend.model.ApplicantJob;

@Repository
public interface ApplicantJobRepository extends JpaRepository<ApplicantJob, Long> {

    List<ApplicantJob> findByApplicant_Id(Long applicantId);

    List<ApplicantJob> findByApplicant_IdAndActionType(Long applicantId, String actionType);

    @EntityGraph(attributePaths = { "applicant", "job", "job.recruiter" })
    Page<ApplicantJob> findByApplicant_IdAndActionType(Long applicantId, String actionType, Pageable pageable);

    List<ApplicantJob> findByJob_IdAndActionType(Long jobDescriptionId, String actionType);

    long countByJob_IdAndActionType(Long jobDescriptionId, String actionType);

    @Query("""
            select count(distinct aj.applicant.id)
            from ApplicantJob aj
            where aj.job.id = :jobId
              and aj.actionType = :actionType
              and (aj.isDeleted is null or aj.isDeleted = false)
              and (aj.applicant.isDeleted is null or aj.applicant.isDeleted = false)
              and (aj.job.isDeleted is null or aj.job.isDeleted = false)
            """)
    long countDistinctApplicantsByJobAndActionType(@Param("jobId") Long jobId,
            @Param("actionType") String actionType);

    @Query("""
            select case when count(aj.id) > 0 then true else false end
            from ApplicantJob aj
            where aj.job.id = :jobId
              and aj.applicant.id = :applicantId
              and aj.actionType = :actionType
              and (aj.isDeleted is null or aj.isDeleted = false)
            """)
    boolean existsActiveRelation(@Param("applicantId") Long applicantId, @Param("jobId") Long jobId,
            @Param("actionType") String actionType);

    @EntityGraph(attributePaths = { "applicant", "applicant.cv", "applicant.cv.experienceObj",
            "applicant.cv.educationObj", "job" })
    @Query("""
            select aj
            from ApplicantJob aj
            where aj.job.id = :jobId
              and aj.actionType = :actionType
              and aj.applicant.id <> :viewerApplicantId
              and aj.applicant.profileVisibleToOtherApplicants = true
              and (aj.isDeleted is null or aj.isDeleted = false)
              and (aj.applicant.isDeleted is null or aj.applicant.isDeleted = false)
              and aj.id in (
                  select min(innerAj.id)
                  from ApplicantJob innerAj
                  where innerAj.job.id = :jobId
                    and innerAj.actionType = :actionType
                    and (innerAj.isDeleted is null or innerAj.isDeleted = false)
                  group by innerAj.applicant.id
              )
            """)
    List<ApplicantJob> findEligibleAnonymousPreviewApplications(@Param("jobId") Long jobId,
            @Param("viewerApplicantId") Long viewerApplicantId,
            @Param("actionType") String actionType);

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
