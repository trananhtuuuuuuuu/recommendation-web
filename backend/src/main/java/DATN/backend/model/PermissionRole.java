package DATN.backend.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "permission_role")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PermissionRole extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    @ManyToOne
    @JoinColumn(name = "permission_id")
    private Permission permission;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    public PermissionRole(Permission permission, Role role) {
        super();
        this.permission = permission;
        this.role = role;
    }
}
