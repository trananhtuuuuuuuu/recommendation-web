package DATN.backend.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "applicant_job_descriptions")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ApplicantJobDescription extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "applicant_id")
    private Applicant applicant;

    @ManyToOne
    @JoinColumn(name = "job_description_id")
    private JobDescription jobDescription;

    @Column(nullable = false)
    private String actionType = "APPLIED";

    @Column(nullable = true, columnDefinition = "TEXT")
    private String coverLetter;

    @Column(nullable = true)
    private String portfolioUrl;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String applicationAnswers;

    public ApplicantJobDescription(Applicant applicant, JobDescription jobDescription) {
        super();
        this.applicant = applicant;
        this.jobDescription = jobDescription;
        this.actionType = "APPLIED";
    }

    public ApplicantJobDescription(Applicant applicant, JobDescription jobDescription, String actionType) {
        super();
        this.applicant = applicant;
        this.jobDescription = jobDescription;
        this.actionType = actionType;
    }

}
