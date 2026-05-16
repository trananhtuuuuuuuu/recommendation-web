package DATN.backend.response.job;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class JobApplicantsResponse {
    private Long jobDescriptionId;
    private Long applicantCount;
}