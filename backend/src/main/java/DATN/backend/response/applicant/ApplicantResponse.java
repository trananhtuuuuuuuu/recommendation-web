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
    private Boolean profileVisibleToRecruiters;
    private Boolean profileVisibleToOtherApplicants;
    private Boolean showFullName;
    private Boolean showContactInfo;
    private Boolean showAddress;
    private Boolean showCvFile;
    private Boolean showObjective;
    private Boolean showSkills;
    private Boolean showExperience;
    private Boolean showEducation;
    private Boolean showCertifications;
    private boolean privacyApplied;
    private boolean anonymized;
    private String privacyNotice;
}
