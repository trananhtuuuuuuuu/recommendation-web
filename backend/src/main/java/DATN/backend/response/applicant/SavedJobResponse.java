package DATN.backend.response.applicant;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SavedJobResponse {
    private Long applicantJobId;
    private Long applicantId;
    private Long jobDescriptionId;
    private String jobTitle;
    private String companyName;
    private String location;
    private String jobType;
    private String status;
    private String savedAt;
    private String appliedAt;
}
