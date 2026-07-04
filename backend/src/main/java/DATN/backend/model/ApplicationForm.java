package DATN.backend.model;

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
@Table(name = "application_forms")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ApplicationForm extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = true)
    private String field;

    @Column(name = "field_value", nullable = true)
    private String value;

    @Column(nullable = true)
    private String urlFile;

    public ApplicationForm(String field, String value, String urlFile) {
        super();
        this.field = field;
        this.value = value;
        this.urlFile = urlFile;
    }
}
