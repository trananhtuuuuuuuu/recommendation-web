package DATN.backend.model;

import java.sql.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "jobs")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class JobDescription extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    @Column(nullable = false)
    private String jobTitle;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String jobDescription;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String requirements;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String benefits;

    @Column(nullable = true)
    private String location;

    @Column(nullable = true)
    private String salaryRange;

    @Column(nullable = true)
    private String jobType;

    @Column(nullable = true)
    private String experienceLevel;

    @Column(nullable = true)
    private String industry;

    @Column(nullable = true)
    private Date postedDate;

    @Column(nullable = true)
    private Date applyingDeadline;

    @Column(nullable = true)
    private Date startDate;

    @Column(nullable = true)
    private Date endDate;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String customApplicationFields;

    @Column(name = "yoe", nullable = true)
    private Integer yoe;

    @Column(name = "custom_application_fields_id", nullable = true)
    private Long customApplicationFieldsId;

    public JobDescription(String jobTitle, String jobDescription, String requirements,
            String benefits, String location, String salaryRange, String jobType, String experienceLevel,
            String industry, Date postedDate, Date applyingDeadline, Date startDate, Date endDate) {
        super();
        this.jobTitle = jobTitle;
        this.jobDescription = jobDescription;
        this.requirements = requirements;
        this.benefits = benefits;
        this.location = location;
        this.salaryRange = salaryRange;
        this.jobType = jobType;
        this.experienceLevel = experienceLevel;
        this.industry = industry;
        this.postedDate = postedDate;
        this.applyingDeadline = applyingDeadline;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    @ManyToOne
    @JoinColumn(name = "recruiter_id")
    private Recruiter recruiter;

}
