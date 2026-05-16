package DATN.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.JobDescription;

@Repository
public interface JobDescriptionRepository extends JpaRepository<JobDescription, Long> {

    List<JobDescription> findByRecruiter_Id(Long recruiterId);

}
