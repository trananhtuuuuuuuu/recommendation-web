package DATN.backend.request.applicant;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SaveJobRequest {

    @NotNull(message = "Applicant id is required")
    private Long applicantId;

    @NotNull(message = "Job description id is required")
    private Long jobDescriptionId;
}