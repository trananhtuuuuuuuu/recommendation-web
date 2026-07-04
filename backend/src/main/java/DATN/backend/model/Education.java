package DATN.backend.model;

import java.sql.Date;

import DATN.backend.Enum.DegreeEnum;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "educations")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Education extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, name = "name")
    private String name;

    @Column(nullable = true, name = "major")
    private String major;

    @Column(nullable = true, name = "degree")
    @Enumerated(EnumType.STRING)
    private DegreeEnum degree;

    @Column(nullable = true, name = "start_date")
    private Date startDate;

    @Column(nullable = true, name = "end_date")
    private Date endDate;

    @Column(nullable = true, name = "period")
    private String time;

    @Column(nullable = false, name = "isPresent")
    private boolean isPresent = false;

    public Education(String name,
            String major,
            DegreeEnum degree,
            Date startDate,
            Date endDate,
            String time,
            boolean isPresent) {
        super();
        this.name = name;
        this.major = major;
        this.degree = degree;
        this.startDate = startDate;
        this.endDate = endDate;
        this.time = time;
        this.isPresent = isPresent;
    }
}
