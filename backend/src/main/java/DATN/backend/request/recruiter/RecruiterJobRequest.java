package DATN.backend.request.recruiter;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonSetter;

import DATN.backend.utils.StringListConverter;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
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

    private String aboutCompany;
    private String jobDescriptionTitle;
    private String jobDescription;
    private String requirementsTitle;
    private String requirements;
    private String benefitsTitle;
    @Setter(AccessLevel.NONE)
    private Object benefits;
    private String location;
    private String salaryRange;
    private String jobType;
    private String postedDate;
    private String applyingDeadline;
    @Setter(AccessLevel.NONE)
    private String yoe;
    private Long customApplicationFieldsId;

    private String experienceLevel;
    private String industry;
    private String startDate;
    private String endDate;
    private String customApplicationFields;

    @Valid
    @NotNull(message = "Structured requirement details are required")
    private JobRequirementDetailsRequest requirementDetails;

    @JsonSetter("benefits")
    public void setBenefits(Object benefits) {
        this.benefits = benefits;
    }

    public List<String> getBenefits() {
        return StringListConverter.fromAny(benefits);
    }

    @JsonSetter("yoe")
    public void setYoe(Object yoe) {
        this.yoe = yoe == null ? null : yoe.toString();
    }
}
