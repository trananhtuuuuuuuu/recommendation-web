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

    @Column(nullable = false)
    private String name;

    @Column(nullable = true)
    private String major;

    @Column(nullable = true)
    @Enumerated(EnumType.STRING)
    private DegreeEnum degree;

    @Column(nullable = true)
    private Date startDate;

    @Column(nullable = true)
    private Date endDate;

    public Education(String name, String major, DegreeEnum degree, Date startDate, Date endDate) {
        super();
        this.name = name;
        this.major = major;
        this.degree = degree;
        this.startDate = startDate;
        this.endDate = endDate;
    }
}
