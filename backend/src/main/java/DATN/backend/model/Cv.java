package DATN.backend.model;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import DATN.backend.utils.StringListConverter;

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

    @Column(nullable = true)
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

    @Column(nullable = true, length = 2048)
    private String cvFileUrl;

    public Cv(String fullName,
            String address,
            String phone,
            String objective,
            List<String> skills,
            String cvFileUrl) {
        super();
        this.fullName = fullName;
        this.address = address;
        this.phone = phone;
        this.objective = objective;
        this.skills = skills;
        this.cvFileUrl = cvFileUrl;
    }

    @OneToOne(mappedBy = "cv")
    private Applicant applicant;

    @ManyToOne
    @JoinColumn(name = "certificate_id")
    private Certificate certificate;

    @ManyToOne
    @JoinColumn(name = "education_id")
    private Education educationObj;

    @ManyToOne
    @JoinColumn(name = "experience_id")
    private Experience experienceObj;
}
