package DATN.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.Cv;

@Repository
public interface CvRepository extends JpaRepository<Cv, Long> {

}
