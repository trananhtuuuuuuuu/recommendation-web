package DATN.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.model.Applicant;

@Repository
public interface ApplicantRepository extends JpaRepository<Applicant, Long> {

    Optional<Applicant> findByEmail(String email);

    Optional<Applicant> findByUserName(String userName);

    /**
     * Finds available applicants who have a CV for recruiter job matching.
     *
     * @param status applicant availability status
     * @return eligible applicants in stable identifier order
     */
    List<Applicant> findByStatusAndCvIsNotNullOrderByIdAsc(ApplicantStatusEnum status);

}
