package DATN.backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.Cv;

@Repository
public interface CvRepository extends JpaRepository<Cv, Long> {

    Optional<Cv> findByFullNameAndPhone(String fullName, String phone);

}
