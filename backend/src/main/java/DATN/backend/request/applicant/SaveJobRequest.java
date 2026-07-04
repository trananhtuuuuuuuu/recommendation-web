package DATN.backend.request.applicant;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SaveJobRequest {

    private Long applicantId;

    private Long jobId;

    private Long jobDescriptionId;

    private String coverLetter;
    private String portfolioUrl;
    private String applicationAnswers;

    public Long getJobId() {
        return jobId != null ? jobId : jobDescriptionId;
    }
}
