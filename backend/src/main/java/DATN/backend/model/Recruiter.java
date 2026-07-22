package DATN.backend.model;

import java.sql.Date;
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

    @Column(unique = false, name = "company_name", nullable = false)
    private String companyName;

    @Column(name = "company_desc", length = 2000, nullable = true, columnDefinition = "TEXT")
    private String companyDesc;

    @Column(nullable = true)
    private String location;

    @Column(nullable = true, name = "company_size")
    private Integer companySize;

    @Column(nullable = true, name = "industry_type")
    private String industryType;

    @Column(nullable = true)
    private String contact;

    @Column(nullable = true, length = 2048)
    private String website;

    @Column(nullable = true, name = "contact_email")
    private String contactEmail;

    @Column(nullable = true, name = "contact_phone")
    private String contactPhone;

    @Column(nullable = true, name = "tax_code")
    private String taxCode;

    @Column(nullable = true, name = "business_license", length = 2048)
    private String businessLicense;

    @Column(nullable = true, name = "company_type")
    private String companyType;

    @Column(nullable = true, length = 2048)
    private String avatarUrl;

    @Column(nullable = true, name = "logo_url", length = 2048)
    private String logoUrl;

    @Column(nullable = true, name = "cover_image_url", length = 2048)
    private String coverImageUrl;

    @Column(nullable = true)
    private Date establishedDate;

    public Recruiter(String address, String email, String fullName, String password, String phone, String companyName,
            String companyDesc, String location, Integer companySize, String industryType, String contact,
            String avatarUrl, Date establishedDate) {
        super(address, email, fullName, password, phone);
        this.companyName = companyName;
        this.companyDesc = companyDesc;
        this.location = location;
        this.companySize = companySize;
        this.industryType = industryType;
        this.contact = contact;
        this.avatarUrl = avatarUrl;
        this.establishedDate = establishedDate;
    }

    @OneToMany(mappedBy = "recruiter")
    private List<Job> jobs;
}
