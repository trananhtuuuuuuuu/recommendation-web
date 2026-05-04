package DATN.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.backend.model.PermissionRole;

@Repository
public interface PermissionRoleRepository extends JpaRepository<PermissionRole, Long> {

}
