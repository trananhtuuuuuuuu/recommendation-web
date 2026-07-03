package DATN.backend.response.job;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class JobResponse {
    private Long id;
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
    private Long recruiterId;
    private String recruiterName;
}
