package DATN.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "certificates")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Certificate extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, name = "certificate_name")
    private String name;

    @Column(nullable = true, name = "point")
    private String score;

    @Column(nullable = true, name = "organisation_name")
    private String provider;

    public Certificate(String name, String score, String provider) {
        super();
        this.name = name;
        this.score = score;
        this.provider = provider;
    }
}
