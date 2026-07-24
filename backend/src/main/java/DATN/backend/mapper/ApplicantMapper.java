package DATN.backend.mapper;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.Enum.GenderEnum;
import DATN.backend.model.Applicant;
import DATN.backend.model.Cv;
import DATN.backend.request.applicant.UpdateApplicantRequest;
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
                return fullAccess ? toFullApplicantResponse(applicant) : toPublicApplicantResponse(applicant);
        }

        public static ApplicantResponse toPublicApplicantResponse(Applicant applicant) {
                boolean profileVisible = isVisible(applicant.getProfileVisibleToRecruiters(), true);
                // Discoverability is the master consent. If it is disabled, an
                // applicant can still share individual sections explicitly.
                boolean showFullName = profileVisible || isVisible(applicant.getShowFullName(), false);
                boolean showContactInfo = profileVisible || isVisible(applicant.getShowContactInfo(), false);
                boolean showAddress = profileVisible || isVisible(applicant.getShowAddress(), false);
                boolean showCvFile = profileVisible || isVisible(applicant.getShowCvFile(), false);
                boolean showObjective = profileVisible || isVisible(applicant.getShowObjective(), true);
                boolean showSkills = profileVisible || isVisible(applicant.getShowSkills(), true);
                boolean showExperience = profileVisible || isVisible(applicant.getShowExperience(), true);
                boolean showEducation = profileVisible || isVisible(applicant.getShowEducation(), true);
                boolean showCertifications = profileVisible || isVisible(applicant.getShowCertifications(), true);
                return new ApplicantResponse(
                                applicant.getId(),
                                null,
                                showContactInfo ? applicant.getEmail() : null,
                                showFullName ? applicant.getFullName() : anonymizedName(applicant),
                                showContactInfo ? applicant.getPhone() : null,
                                showAddress ? applicant.getAddress() : null,
                                null,
                                profileVisible && applicant.getStatus() != null ? applicant.getStatus().name() : null,
                                null,
                                applicant.getCv() == null ? null
                                                : toCvResponse(applicant.getCv(), showFullName, showAddress,
                                                                showContactInfo, showObjective, showSkills,
                                                                showExperience, showEducation, showCertifications,
                                                                showCvFile));
        }

        public static ApplicantResponse toRecruiterVisibleApplicantResponse(Applicant applicant) {
                ApplicantResponse response = toFullApplicantResponse(applicant);
                response.setUserName(null);
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
                                applicant.getCv() == null ? null : toCvResponse(applicant.getCv()));
        }

        public static Applicant toNewApplicant(RegistrationApplicantRequest request) {
                Applicant applicant = new Applicant();
                applicant.setAddress(toNullableText(request.getAddress()));
                applicant.setEmail(toNullableText(request.getEmail()));
                applicant.setPassword(request.getPassword());
                applicant.setPhone(toNullableText(request.getPhone()));
                applicant.setUserName(request.getUserName());
                applicant.setFullName(toNullableText(request.getFullName()));
                applicant.setGender(request.getGender() == null || request.getGender().isBlank() ? null
                                : GenderEnum.valueOf(request.getGender()));
                applicant
                                .setStatus(request.getStatus() == null || request.getStatus().isBlank()
                                                ? ApplicantStatusEnum.OpenToWork
                                                : toApplicantStatus(request.getStatus()));
                return applicant;
        }

        private static String toNullableText(String value) {
                return value == null || value.isBlank() ? null : value.trim();
        }

        public static Applicant updateApplicant(Applicant applicant, UpdateApplicantRequest request) {
                if (request.getAddress() != null) {
                        applicant.setAddress(request.getAddress());
                }
                if (request.getEmail() != null) {
                        applicant.setEmail(request.getEmail());
                }
                if (request.getPhone() != null) {
                        applicant.setPhone(request.getPhone());
                }
                if (request.getFullName() != null) {
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
                return "Candidate";
        }

}
