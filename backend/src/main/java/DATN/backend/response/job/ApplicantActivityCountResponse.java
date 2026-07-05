package DATN.backend.response.job;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ApplicantActivityCountResponse {
    private Long jobId;
    private Long approximateApplicantCount;
    private String displayText;
    private boolean approximate;
}
