package DATN.backend.model;

import java.sql.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "experiences")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Experience extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, name = "company_name")
    private String companyName;

    @Column(nullable = true, name = "position")
    private String jobTitle;

    @Column(nullable = true, name = "field")
    private String field;

    @Column(nullable = true, columnDefinition = "TEXT", name = "contribution")
    private String contribution;

    @Column(nullable = true, name = "start_date")
    private Date startDate;

    @Column(nullable = true, name = "end_date")
    private Date endDate;

    @Column(name = "period", nullable = true)
    private String time;

    @Column(nullable = false, name = "isPresent")
    private Boolean isPresent = false;

    public Experience(String companyName,
            String jobTitle,
            String field,
            String contribution,
            Date startDate,
            Date endDate,
            String time,
            Boolean isPresent) {
        super();
        this.companyName = companyName;
        this.jobTitle = jobTitle;
        this.field = field;
        this.contribution = contribution;
        this.startDate = startDate;
        this.endDate = endDate;
        this.time = time;
        this.isPresent = isPresent != null ? isPresent : false;
    }
}
