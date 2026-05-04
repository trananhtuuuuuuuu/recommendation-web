package DATN.backend.model;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "recruiters")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Recruiter extends User {

    @Column(unique = false, nullable = false)
    private String companyName;

    @Column(length = 2000, nullable = true, columnDefinition = "TEXT")
    private String companyDescription;

    @Column(length = 2000, nullable = true)
    private String companyLocation;

    @Column(length = 100, nullable = true)
    private String companySize;

    @Column(length = 100, nullable = true, columnDefinition = "TEXT")
    private String industry;

    @Column(nullable = true)
    private String website;

    @Column(nullable = true)
    private String logoUrl;

    @Column(nullable = true)
    private String contactEmail;

    @Column(nullable = true)
    private String contactPhone;

    @Column(nullable = false)
    private String taxCode;

    @Column(nullable = true)
    private String businessLicense;

    @Column(nullable = false)
    private String establishedDate;

    @Column(nullable = true)
    private String companyType;

    public Recruiter(String address, String email, String fullName, String password, String phone, String companyName,
            String companyDescription, String companyLocation, String companySize, String industry, String website,
            String logoUrl, String contactEmail, String contactPhone, String taxCode, String businessLicense,
            String establishedDate, String companyType) {
        super(address, email, fullName, password, phone);
        this.companyName = companyName;
        this.companyDescription = companyDescription;
        this.companyLocation = companyLocation;
        this.companySize = companySize;
        this.industry = industry;
        this.website = website;
        this.logoUrl = logoUrl;
        this.contactEmail = contactEmail;
        this.contactPhone = contactPhone;
        this.taxCode = taxCode;
        this.businessLicense = businessLicense;
        this.establishedDate = establishedDate;
        this.companyType = companyType;
    }

    @OneToMany(mappedBy = "recruiter")
    private List<JobDescription> jobs;
}