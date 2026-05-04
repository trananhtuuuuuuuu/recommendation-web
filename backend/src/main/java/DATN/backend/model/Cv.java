package DATN.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "cvs")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Cv extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    @Column(nullable = false)
    private String fullName;

    @Column(nullable = true)
    private String address;

    @Column(nullable = true)
    private String phone;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String objective;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String skills;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String experience;

    @Column(nullable = true)
    private String education;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String certifications;

    public Cv(String fullName, String address, String phone, String objective, String skills, String experience,
            String education, String certifications) {
        super();
        this.fullName = fullName;
        this.address = address;
        this.phone = phone;
        this.objective = objective;
        this.skills = skills;
        this.experience = experience;
        this.education = education;
        this.certifications = certifications;
    }

    @OneToOne(mappedBy = "cv")
    private Applicant applicant;
}
