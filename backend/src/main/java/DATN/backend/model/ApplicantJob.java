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
@Table(name = "applicant_jobs")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ApplicantJob extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String actionType = "APPLIED";

    @ManyToOne
    @JoinColumn(name = "applicant_id")
    private Applicant applicant;

    @ManyToOne
    @JoinColumn(name = "job_id")
    private Job job;

    @ManyToOne
    @JoinColumn(name = "application_form_id")
    private ApplicationForm applicationForm;

    public ApplicantJob(Applicant applicant, Job job) {
        super();
        this.applicant = applicant;
        this.job = job;
        this.actionType = "APPLIED";
    }

    public ApplicantJob(Applicant applicant, Job job, String actionType) {
        super();
        this.applicant = applicant;
        this.job = job;
        this.actionType = actionType;
    }

}
