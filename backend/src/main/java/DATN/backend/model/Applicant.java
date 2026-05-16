package DATN.backend.model;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.Enum.GenderEnum;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Enumerated;
import jakarta.persistence.EnumType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "applicants")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Applicant extends User {

    @Column(nullable = true)
    @Enumerated(EnumType.ORDINAL)
    private ApplicantStatusEnum status;

    @Column(nullable = true)
    @Enumerated(EnumType.ORDINAL)
    private GenderEnum gender;

    @Column(nullable = false)
    private String fullName;

    public Applicant(String address, String email, String fullName, String password, String phone,
            ApplicantStatusEnum status, GenderEnum gender) {
        super(address, email, fullName, password, phone);
        this.status = status;
        this.gender = gender;
        this.fullName = fullName;
    }

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "cv_id")
    private Cv cv;

}