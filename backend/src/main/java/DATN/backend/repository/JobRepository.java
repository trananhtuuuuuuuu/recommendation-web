package DATN.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import DATN.backend.model.Job;
import jakarta.persistence.LockModeType;

@Repository
public interface JobRepository extends JpaRepository<Job, Long> {

    @Override
    @EntityGraph(attributePaths = { "recruiter" })
    Page<Job> findAll(Pageable pageable);

    List<Job> findByRecruiter_Id(Long recruiterId);

    /**
     * Loads and locks a job while its applicant-count privacy release is created.
     *
     * @param jobId job identifier
     * @return the locked job when it exists
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select j from Job j where j.id = :jobId")
    Optional<Job> findByIdForUpdate(@Param("jobId") Long jobId);
}
