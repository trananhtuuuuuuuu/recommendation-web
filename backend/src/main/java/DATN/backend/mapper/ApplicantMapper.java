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

}
