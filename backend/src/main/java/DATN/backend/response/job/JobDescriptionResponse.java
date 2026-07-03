package DATN.backend.response.job;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class JobDescriptionResponse {
    private Long id;
    private String jobTitle;
    private String jobDescription;
    private String requirements;
    private String benefits;
    private String location;
    private String salaryRange;
    private String jobType;
    private String experienceLevel;
    private String industry;
    private String postedDate;
    private String applyingDeadline;
    private String startDate;
    private String endDate;
    private Long recruiterId;
    private String recruiterName;
    private String customApplicationFields;
}
