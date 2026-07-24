package DATN.backend.response.applicant;

import DATN.backend.response.cv.CvResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ApplicantResponse {
    private Long id;
    private String userName;
    private String email;
    private String fullName;
    private String phone;
    private String address;
    private String gender;
    private String status;
    private Long cvId;
    private CvResponse cv;
}
