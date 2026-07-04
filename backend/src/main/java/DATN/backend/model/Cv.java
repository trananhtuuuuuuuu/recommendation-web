package DATN.backend.model;

import java.util.List;

import DATN.backend.utils.StringListConverter;
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

@Entity
@Table(name = "cvs")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Cv extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = true, name = "full_name")
    private String fullName;

    @Column(nullable = true, name = "address")
    private String address;

    @Column(nullable = true, name = "phone")
    private String phone;

    @Column(nullable = true, columnDefinition = "TEXT", name = "objective")
    private String objective;

    @Column(nullable = true, columnDefinition = "TEXT", name = "skills")
    @Convert(converter = StringListConverter.class)
    private List<String> skills;

    @Column(nullable = true, length = 2048, name = "cv_file_url")
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
