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

    @Column(nullable = false)
    private String companyName;

    @Column(nullable = true)
    private String jobTitle;

    @Column(nullable = true)
    private String field;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String contribution;

    @Column(nullable = true)
    private Date startDate;

    @Column(nullable = true)
    private Date endDate;

    @Column(nullable = false)
    private Boolean isPresent = false;

    public Experience(String companyName, String jobTitle, String field, String contribution, Date startDate, Date endDate, Boolean isPresent) {
        super();
        this.companyName = companyName;
        this.jobTitle = jobTitle;
        this.field = field;
        this.contribution = contribution;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isPresent = isPresent != null ? isPresent : false;
    }
}
