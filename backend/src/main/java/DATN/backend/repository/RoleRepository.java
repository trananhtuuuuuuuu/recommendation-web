package DATN.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

}
