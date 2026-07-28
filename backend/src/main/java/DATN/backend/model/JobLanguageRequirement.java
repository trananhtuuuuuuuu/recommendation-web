package DATN.backend.model;

import java.util.ArrayList;
import java.util.List;

import DATN.backend.utils.StringListConverter;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OrderColumn;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Represents one language, proficiency, skills, and optional certificates
 * required by a job.
 */
@Entity
@Table(name = "job_language_requirements")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class JobLanguageRequirement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "job_id", nullable = false)
    private Job job;

    @Column(name = "display_order", nullable = false)
    private Integer displayOrder;

    @Column(name = "language_name", nullable = false)
    private String languageName;

    @Column(name = "proficiency_level", nullable = false)
    private String proficiencyLevel;

    @Column(name = "skills", nullable = false, columnDefinition = "TEXT")
    @Convert(converter = StringListConverter.class)
    private List<String> skills = new ArrayList<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(
            name = "job_language_certificate_requirements",
            joinColumns = @JoinColumn(name = "language_requirement_id"))
    @OrderColumn(name = "display_order")
    private List<LanguageCertificateRequirement> certificates = new ArrayList<>();
}
