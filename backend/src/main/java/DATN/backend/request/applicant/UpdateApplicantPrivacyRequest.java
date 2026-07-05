package DATN.backend.request.applicant;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateApplicantPrivacyRequest {
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
}
