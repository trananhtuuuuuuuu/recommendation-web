package DATN.backend.request.recruiter;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonSetter;

import DATN.backend.utils.StringListConverter;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RecruiterJobRequest {

    @NotBlank(message = "Job title is required")
    private String jobTitle;

    private String jobDescription;
    private String requirements;
    private List<String> benefits;
    private String location;
    private String salaryRange;
    private String jobType;
    private String postedDate;
    private String applyingDeadline;
    private Integer yoe;
    private Long customApplicationFieldsId;

    private String experienceLevel;
    private String industry;
    private String startDate;
    private String endDate;
    private String customApplicationFields;

    @JsonSetter("benefits")
    public void setBenefitsFromJson(Object benefits) {
        this.benefits = StringListConverter.fromAny(benefits);
    }
}
