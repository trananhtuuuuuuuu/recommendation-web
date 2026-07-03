package DATN.backend.mapper;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.Enum.GenderEnum;
import DATN.backend.model.Applicant;
import DATN.backend.model.Certificate;
import DATN.backend.model.Cv;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
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
                                toExperienceResponse(cv.getExperienceObj()),
                                toEducationResponse(cv.getEducationObj()),
                                toCertificateResponse(cv.getCertificate()),
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
                cv.setExperienceObj(toExperience(request.getExperience(), cv.getExperienceObj()));
                cv.setEducationObj(toEducation(request.getEducation(), cv.getEducationObj()));
                cv.setCertificate(toCertificate(request.getCertifications(), cv.getCertificate()));
        }

        private static Experience toExperience(String value, Experience current) {
                String normalizedValue = trimToNull(value);
                if (normalizedValue == null) {
                        return null;
                }

                Experience experience = current == null ? new Experience() : current;
                ExperienceSummary summary = ExperienceSummary.from(normalizedValue);
                experience.setCompanyName(blankToDefault(summary.companyName(), "Experience"));
                experience.setJobTitle(trimToNull(summary.position()));
                experience.setField(trimToNull(summary.skills()));
                experience.setContribution(normalizedValue);
                if (experience.getIsPresent() == null) {
                        experience.setIsPresent(false);
                }
                return experience;
        }

        private static Education toEducation(String value, Education current) {
                String normalizedValue = trimToNull(value);
                if (normalizedValue == null) {
                        return null;
                }

                Education education = current == null ? new Education() : current;
                education.setName(normalizedValue);
                education.setMajor(null);
                education.setDegree(null);
                education.setStartDate(null);
                education.setEndDate(null);
                return education;
        }

        private static Certificate toCertificate(String value, Certificate current) {
                String normalizedValue = trimToNull(value);
                if (normalizedValue == null) {
                        return null;
                }

                Certificate certificate = current == null ? new Certificate() : current;
                certificate.setName(normalizedValue);
                certificate.setProvider(null);
                certificate.setScore(null);
                return certificate;
        }

        private static String toExperienceResponse(Experience experience) {
                return experience == null ? null : experience.getContribution();
        }

        private static String toEducationResponse(Education education) {
                return education == null ? null : education.getName();
        }

        private static String toCertificateResponse(Certificate certificate) {
                return certificate == null ? null : certificate.getName();
        }

        private static String blankToDefault(String value, String defaultValue) {
                String normalizedValue = trimToNull(value);
                return normalizedValue == null ? defaultValue : normalizedValue;
        }

        private static String trimToNull(String value) {
                return value == null || value.isBlank() ? null : value.trim();
        }

        private record ExperienceSummary(String companyName, String position, String skills) {
                private static ExperienceSummary from(String value) {
                        String companyName = readJsonField(value, "companyName");
                        String position = readJsonField(value, "position");
                        String skills = readJsonField(value, "skills");
                        return new ExperienceSummary(companyName, position, skills);
                }

                private static String readJsonField(String value, String fieldName) {
                        String quotedField = "\"" + fieldName + "\"";
                        int fieldIndex = value.indexOf(quotedField);
                        if (fieldIndex < 0) {
                                return null;
                        }
                        int colonIndex = value.indexOf(':', fieldIndex + quotedField.length());
                        if (colonIndex < 0) {
                                return null;
                        }
                        int quoteStart = value.indexOf('"', colonIndex + 1);
                        if (quoteStart < 0) {
                                return null;
                        }
                        StringBuilder result = new StringBuilder();
                        boolean escaping = false;
                        for (int index = quoteStart + 1; index < value.length(); index++) {
                                char current = value.charAt(index);
                                if (escaping) {
                                        result.append(current);
                                        escaping = false;
                                } else if (current == '\\') {
                                        escaping = true;
                                } else if (current == '"') {
                                        return result.toString();
                                } else {
                                        result.append(current);
                                }
                        }
                        return null;
                }
        }

}
