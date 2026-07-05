package DATN.backend.mapper;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.Enum.GenderEnum;
import DATN.backend.model.Applicant;
import DATN.backend.model.Cv;
import DATN.backend.request.applicant.UpdateApplicantRequest;
import DATN.backend.request.applicant.UpdateApplicantPrivacyRequest;
import DATN.backend.request.applicant.UploadCvRequest;
import DATN.backend.request.applicant.RegistrationApplicantRequest;
import DATN.backend.response.applicant.ApplicantResponse;
import DATN.backend.response.applicant.RegistrationApplicantResponse;
import DATN.backend.response.cv.CvResponse;

public class ApplicantMapper {

        private ApplicantMapper() {
        }

        public static RegistrationApplicantResponse toRegistrationResponse(Applicant applicant) {
                return new RegistrationApplicantResponse(
                                applicant.getUserName(),
                                applicant.getEmail(),
                                applicant.getFullName(),
                                applicant.getPhone(),
                                applicant.getAddress(),
                                applicant.getGender() == null ? null : applicant.getGender().name(),
                                applicant.getStatus() == null ? null : applicant.getStatus().name(),
                                applicant.getRole() == null ? null : applicant.getRole().getRoleName(),
                                applicant.getCv() == null ? null : String.valueOf(applicant.getCv().getId()));
        }

        public static ApplicantResponse toApplicantResponse(Applicant applicant) {
                return toApplicantResponse(applicant, true);
        }

        public static ApplicantResponse toApplicantResponse(Applicant applicant, boolean fullAccess) {
                return fullAccess ? toFullApplicantResponse(applicant) : toRecruiterVisibleApplicantResponse(applicant);
        }

        public static ApplicantResponse toRecruiterVisibleApplicantResponse(Applicant applicant) {
                boolean profileVisible = isVisible(applicant.getProfileVisibleToRecruiters(), true);
                boolean showFullName = profileVisible && isVisible(applicant.getShowFullName(), false);
                boolean showContactInfo = profileVisible && isVisible(applicant.getShowContactInfo(), false);
                boolean showAddress = profileVisible && isVisible(applicant.getShowAddress(), false);
                boolean showCvFile = profileVisible && isVisible(applicant.getShowCvFile(), false);
                boolean showObjective = profileVisible && isVisible(applicant.getShowObjective(), true);
                boolean showSkills = profileVisible && isVisible(applicant.getShowSkills(), true);
                boolean showExperience = profileVisible && isVisible(applicant.getShowExperience(), true);
                boolean showEducation = profileVisible && isVisible(applicant.getShowEducation(), true);
                boolean showCertifications = profileVisible && isVisible(applicant.getShowCertifications(), true);
                boolean privacyApplied = !profileVisible
                                || !showFullName
                                || !showContactInfo
                                || !showAddress
                                || !showCvFile
                                || !showObjective
                                || !showSkills
                                || !showExperience
                                || !showEducation
                                || !showCertifications;

                return new ApplicantResponse(
                                applicant.getId(),
                                null,
                                showContactInfo ? applicant.getEmail() : null,
                                showFullName ? applicant.getFullName() : anonymizedName(applicant),
                                showContactInfo ? applicant.getPhone() : null,
                                showAddress ? applicant.getAddress() : null,
                                null,
                                profileVisible && applicant.getStatus() != null ? applicant.getStatus().name() : null,
                                applicant.getCv() == null ? null : applicant.getCv().getId(),
                                applicant.getCv() == null ? null
                                                : toCvResponse(applicant.getCv(), showFullName, showAddress,
                                                                showContactInfo, showObjective, showSkills,
                                                                showExperience, showEducation, showCertifications,
                                                                showCvFile),
                                profileVisible,
                                isVisible(applicant.getProfileVisibleToOtherApplicants(), false),
                                showFullName,
                                showContactInfo,
                                showAddress,
                                showCvFile,
                                showObjective,
                                showSkills,
                                showExperience,
                                showEducation,
                                showCertifications,
                                privacyApplied,
                                privacyApplied,
                                privacyApplied
                                                ? "Candidate privacy settings hide one or more profile fields."
                                                : null);
        }

        public static ApplicantResponse toKAnonymousApplicantResponse(Applicant applicant, int groupSize, int k) {
                ApplicantResponse response = toRecruiterVisibleApplicantResponse(applicant);
                boolean belowThreshold = groupSize < k;
                response.setUserName(null);
                response.setEmail(null);
                response.setFullName(belowThreshold ? "Candidate" : anonymizedName(applicant));
                response.setPhone(null);
                response.setAddress(null);
                response.setGender(null);
                response.setAnonymized(true);
                response.setPrivacyApplied(true);
                response.setPrivacyNotice(belowThreshold
                                ? "Shortlist has fewer than " + k
                                                + " applicants, so quasi-identifiers are suppressed for k-anonymity."
                                : "Quasi-identifiers are generalized for k-anonymity.");
                if (belowThreshold) {
                        response.setCv(null);
                        response.setCvId(null);
                } else if (response.getCv() != null) {
                        response.getCv().setFullName(anonymizedName(applicant));
                        response.getCv().setAddress(null);
                        response.getCv().setPhone(null);
                        response.getCv().setObjective(null);
                        response.getCv().setExperience(null);
                        response.getCv().setEducation(null);
                        response.getCv().setCertifications(null);
                        response.getCv().setCvFileUrl(null);
                }
                return response;
        }

        private static ApplicantResponse toFullApplicantResponse(Applicant applicant) {
                return new ApplicantResponse(
                                applicant.getId(),
                                applicant.getUserName(),
                                applicant.getEmail(),
                                applicant.getFullName(),
                                applicant.getPhone(),
                                applicant.getAddress(),
                                applicant.getGender() == null ? null : applicant.getGender().name(),
                                applicant.getStatus() == null ? null : applicant.getStatus().name(),
                                applicant.getCv() == null ? null : applicant.getCv().getId(),
                                applicant.getCv() == null ? null : toCvResponse(applicant.getCv()),
                                isVisible(applicant.getProfileVisibleToRecruiters(), true),
                                isVisible(applicant.getProfileVisibleToOtherApplicants(), false),
                                isVisible(applicant.getShowFullName(), false),
                                isVisible(applicant.getShowContactInfo(), false),
                                isVisible(applicant.getShowAddress(), false),
                                isVisible(applicant.getShowCvFile(), false),
                                isVisible(applicant.getShowObjective(), true),
                                isVisible(applicant.getShowSkills(), true),
                                isVisible(applicant.getShowExperience(), true),
                                isVisible(applicant.getShowEducation(), true),
                                isVisible(applicant.getShowCertifications(), true),
                                false,
                                false,
                                null);
        }

        public static Applicant toNewApplicant(RegistrationApplicantRequest request) {
                Applicant applicant = new Applicant();
                applicant.setAddress(request.getAddress());
                applicant.setEmail(request.getEmail());
                applicant.setPassword(request.getPassword());
                applicant.setPhone(request.getPhone());
                applicant.setUserName(request.getUserName());
                applicant.setFullName(request.getFullName());
                applicant.setGender(request.getGender() == null || request.getGender().isBlank() ? null
                                : GenderEnum.valueOf(request.getGender()));
                applicant
                                .setStatus(request.getStatus() == null || request.getStatus().isBlank()
                                                ? ApplicantStatusEnum.OpenToWork
                                                : toApplicantStatus(request.getStatus()));
                return applicant;
        }

        public static Applicant updateApplicant(Applicant applicant, UpdateApplicantRequest request) {
                applicant.setAddress(request.getAddress());
                if (request.getEmail() != null && !request.getEmail().isBlank()) {
                        applicant.setEmail(request.getEmail());
                }
                applicant.setPhone(request.getPhone());
                if (request.getUserName() != null && !request.getUserName().isBlank()) {
                        applicant.setUserName(request.getUserName());
                }
                if (request.getFullName() != null && !request.getFullName().isBlank()) {
                        applicant.setFullName(request.getFullName());
                }
                if (request.getGender() != null) {
                        applicant.setGender(
                                        request.getGender().isBlank() ? null : GenderEnum.valueOf(request.getGender()));
                }
                if (request.getStatus() != null) {
                        applicant.setStatus(
                                        request.getStatus().isBlank() ? null : toApplicantStatus(request.getStatus()));
                }
                return applicant;
        }

        public static Applicant updateApplicantPrivacy(Applicant applicant, UpdateApplicantPrivacyRequest request) {
                if (request.getProfileVisibleToRecruiters() != null) {
                        applicant.setProfileVisibleToRecruiters(request.getProfileVisibleToRecruiters());
                }
                if (request.getProfileVisibleToOtherApplicants() != null) {
                        applicant.setProfileVisibleToOtherApplicants(request.getProfileVisibleToOtherApplicants());
                }
                if (request.getShowFullName() != null) {
                        applicant.setShowFullName(request.getShowFullName());
                }
                if (request.getShowContactInfo() != null) {
                        applicant.setShowContactInfo(request.getShowContactInfo());
                }
                if (request.getShowAddress() != null) {
                        applicant.setShowAddress(request.getShowAddress());
                }
                if (request.getShowCvFile() != null) {
                        applicant.setShowCvFile(request.getShowCvFile());
                }
                if (request.getShowObjective() != null) {
                        applicant.setShowObjective(request.getShowObjective());
                }
                if (request.getShowSkills() != null) {
                        applicant.setShowSkills(request.getShowSkills());
                }
                if (request.getShowExperience() != null) {
                        applicant.setShowExperience(request.getShowExperience());
                }
                if (request.getShowEducation() != null) {
                        applicant.setShowEducation(request.getShowEducation());
                }
                if (request.getShowCertifications() != null) {
                        applicant.setShowCertifications(request.getShowCertifications());
                }
                return applicant;
        }

        private static ApplicantStatusEnum toApplicantStatus(String status) {
                if ("NotOpenToWork".equals(status) || "Archived".equals(status)) {
                        return ApplicantStatusEnum.Normal;
                }
                return ApplicantStatusEnum.valueOf(status);
        }

        public static Cv toCv(UploadCvRequest request) {
                Cv cv = new Cv(
                                request.getFullName(),
                                request.getAddress(),
                                request.getPhone(),
                                request.getObjective(),
                                request.getSkills(),
                                request.getCvFileUrl());
                updateCvProfileRelations(cv, request);
                return cv;
        }

        public static CvResponse toCvResponse(Cv cv) {
                return new CvResponse(
                                cv.getId(),
                                cv.getFullName(),
                                cv.getAddress(),
                                cv.getPhone(),
                                cv.getObjective(),
                                cv.getSkills(),
                                cv.getExperienceObj(),
                                cv.getEducationObj(),
                                cv.getCertificate(),
                                cv.getCvFileUrl());
        }

        private static CvResponse toCvResponse(Cv cv, boolean showFullName, boolean showAddress,
                        boolean showContactInfo, boolean showObjective, boolean showSkills, boolean showExperience,
                        boolean showEducation, boolean showCertifications, boolean showCvFile) {
                return new CvResponse(
                                cv.getId(),
                                showFullName ? cv.getFullName() : null,
                                showAddress ? cv.getAddress() : null,
                                showContactInfo ? cv.getPhone() : null,
                                showObjective ? cv.getObjective() : null,
                                showSkills ? cv.getSkills() : null,
                                showExperience ? cv.getExperienceObj() : null,
                                showEducation ? cv.getEducationObj() : null,
                                showCertifications ? cv.getCertificate() : null,
                                showCvFile ? cv.getCvFileUrl() : null);
        }

        /**
         * Updates an existing {@link Cv} entity's fields in-place from the given
         * request. Using this instead of {@link #toCv} on subsequent uploads prevents
         * JPA from inserting a second CV row and violating the one-to-one FK
         * constraint.
         *
         * @param cv      existing managed CV entity
         * @param request upload payload with the new field values
         */
        public static void updateCv(Cv cv, UploadCvRequest request) {
                cv.setFullName(request.getFullName());
                cv.setAddress(request.getAddress());
                cv.setPhone(request.getPhone());
                cv.setObjective(request.getObjective());
                cv.setSkills(request.getSkills());
                updateCvProfileRelations(cv, request);
                if (request.getCvFileUrl() != null && !request.getCvFileUrl().isBlank()) {
                        cv.setCvFileUrl(request.getCvFileUrl());
                }
        }

        private static void updateCvProfileRelations(Cv cv, UploadCvRequest request) {
                cv.setExperienceObj(request.getExperience());
                cv.setEducationObj(request.getEducation());
                cv.setCertificate(request.getCertifications());
        }

        private static boolean isVisible(Boolean value, boolean defaultValue) {
                return value == null ? defaultValue : Boolean.TRUE.equals(value);
        }

        private static String anonymizedName(Applicant applicant) {
                return "Candidate #" + applicant.getId();
        }

}
