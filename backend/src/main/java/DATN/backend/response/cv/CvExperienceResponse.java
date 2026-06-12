package DATN.backend.response.cv;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Structured work-experience entry extracted from an uploaded CV.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CvExperienceResponse {
    private String companyName;
    private String position;
    private String time;
    private String description;
    private String skills;
    private String certificates;
}
