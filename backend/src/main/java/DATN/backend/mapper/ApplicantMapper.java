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
                                                : ApplicantStatusEnum.valueOf(request.getStatus()));
                return applicant;
        }

        public static Applicant updateApplicant(Applicant applicant, UpdateApplicantRequest request) {
                applicant.setAddress(request.getAddress());
                applicant.setEmail(request.getEmail());
                applicant.setPhone(request.getPhone());
                applicant.setUserName(request.getUserName());
                applicant.setFullName(request.getFullName());
                applicant.setGender(request.getGender() == null || request.getGender().isBlank() ? applicant.getGender()
                                : GenderEnum.valueOf(request.getGender()));
                applicant.setStatus(request.getStatus() == null || request.getStatus().isBlank() ? applicant.getStatus()
                                : ApplicantStatusEnum.valueOf(request.getStatus()));
                return applicant;
        }

        public static Cv toCv(UploadCvRequest request) {
                return new Cv(
                                request.getFullName(),
                                request.getAddress(),
                                request.getPhone(),
                                request.getObjective(),
                                request.getSkills(),
                                request.getExperience(),
                                request.getEducation(),
                                request.getCertifications(),
                                request.getCvFileUrl());
        }

        public static CvResponse toCvResponse(Cv cv) {
                return new CvResponse(
                                cv.getId(),
                                cv.getFullName(),
                                cv.getAddress(),
                                cv.getPhone(),
                                cv.getObjective(),
                                cv.getSkills(),
                                cv.getExperience(),
                                cv.getEducation(),
                                cv.getCertifications(),
                                cv.getCvFileUrl());
        }

}
