package DATN.backend.model;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "roles")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Role extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String roleName;

    @Column(nullable = true)
    private String description;

    public Role(String roleName, String description) {
        super();
        this.roleName = roleName;
        this.description = description;
    }

    @OneToMany(mappedBy = "role")
    private List<User> users;

    @OneToMany(mappedBy = "role")
    private List<PermissionRole> permissionRoles;
}