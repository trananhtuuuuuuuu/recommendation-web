package DATN.backend.model;

import java.sql.Date;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import DATN.backend.utils.StringListConverter;

@Entity
@Table(name = "jobs")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Job extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = true, name = "applying_deadline")
    private Date applyingDeadline;

    @Column(nullable = true, columnDefinition = "TEXT", name = "benefits")
    @Convert(converter = StringListConverter.class)
    private List<String> benefits;

    @Column(name = "yoe", nullable = true)
    private Integer yoe;

    @Column(name = "job_desc", nullable = true, columnDefinition = "TEXT")
    private String jobDesc;

    @Column(nullable = false, name = "job_title")
    private String jobTitle;

    @Column(nullable = true, name = "job_type")
    private String jobType;

    @Column(nullable = true)
    private String location;

    @Column(nullable = true)
    private Date postedDate;

    @Column(name = "requirements", nullable = true, columnDefinition = "TEXT")
    @Convert(converter = StringListConverter.class)
    private List<String> requirements;

    @Column(nullable = true, name = "salary_range")
    private String salaryRange;

    @ManyToOne
    @JoinColumn(name = "recruiter_id")
    private Recruiter recruiter;

    @OneToOne
    @JoinColumn(name = "custom_application_fields_id")
    private ApplicationForm applicationForm;

    public Job(String jobTitle,
            String jobDesc,
            List<String> requirements,
            List<String> benefits,
            String location,
            String salaryRange,
            String jobType,
            Date postedDate,
            Date applyingDeadline,
            Integer yoe,
            Long customApplicationFieldsId) {
        super();
        this.jobTitle = jobTitle;
        this.jobDesc = jobDesc;
        this.requirements = requirements;
        this.benefits = benefits;
        this.location = location;
        this.salaryRange = salaryRange;
        this.jobType = jobType;
        this.postedDate = postedDate;
        this.applyingDeadline = applyingDeadline;
        this.yoe = yoe;
    }

}
