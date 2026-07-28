package DATN.backend.mapper;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import DATN.backend.Enum.JobDegreeEnum;
import DATN.backend.Enum.JobEducationRequirementModeEnum;
import DATN.backend.model.ApplicationForm;
import DATN.backend.model.EnglishCertificateRequirement;
import DATN.backend.model.Job;
import DATN.backend.model.Recruiter;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.response.job.EnglishCertificateRequirementResponse;
import DATN.backend.response.job.JobRequirementDetailsResponse;
import DATN.backend.request.recruiter.JobRequirementDetailsRequest;
import DATN.backend.utils.StringListConverter;

public class JobMapper {

    private static final String DEFAULT_JOB_DESCRIPTION_TITLE = "Job description";
    private static final String DEFAULT_REQUIREMENTS_TITLE = "Requirements";
    private static final String DEFAULT_BENEFITS_TITLE = "Benefits";

    private JobMapper() {
    }

    public static Job toNewJob(Recruiter recruiter, RecruiterJobRequest request) {
        Job jobDescription = new Job();
        jobDescription.setRecruiter(recruiter);
        jobDescription.setJobTitle(request.getJobTitle());
        jobDescription.setAboutCompany(resolveAboutCompany(recruiter, request.getAboutCompany()));
        jobDescription.setJobDescriptionTitle(
                defaultIfBlank(request.getJobDescriptionTitle(), DEFAULT_JOB_DESCRIPTION_TITLE));
        jobDescription.setJobDesc(request.getJobDescription());
        jobDescription.setRequirementsTitle(
                defaultIfBlank(request.getRequirementsTitle(), DEFAULT_REQUIREMENTS_TITLE));
        jobDescription.setRequirements(StringListConverter.fromString(request.getRequirements()));
        jobDescription.setBenefitsTitle(defaultIfBlank(request.getBenefitsTitle(), DEFAULT_BENEFITS_TITLE));
        jobDescription.setBenefits(request.getBenefits());
        jobDescription.setLocation(request.getLocation());
        jobDescription.setSalaryRange(parseSalaryRange(request.getSalaryRange()));
        jobDescription.setJobType(request.getJobType());
        jobDescription.setExperienceLevel(blankToNull(request.getExperienceLevel()));
        jobDescription.setIndustry(blankToNull(request.getIndustry()));
        jobDescription.setPostedDate(parseDate(request.getPostedDate()));
        jobDescription.setApplyingDeadline(parseDate(request.getApplyingDeadline()));
        jobDescription.setStartDate(parseDate(request.getStartDate()));
        jobDescription.setEndDate(parseDate(request.getEndDate()));
        jobDescription.setYoe(request.getYoe());
        jobDescription.setCustomApplicationFields(blankToNull(request.getCustomApplicationFields()));
        jobDescription.setApplicationForm(toApplicationFormReference(request.getCustomApplicationFieldsId()));
        applyRequirementDetails(jobDescription, request.getRequirementDetails());
        return jobDescription;
    }

    public static Job updateJob(Job jobDescription, Recruiter recruiter, RecruiterJobRequest request) {
        jobDescription.setJobTitle(request.getJobTitle());
        jobDescription.setAboutCompany(resolveAboutCompany(recruiter, request.getAboutCompany()));
        jobDescription.setJobDescriptionTitle(
                defaultIfBlank(request.getJobDescriptionTitle(), DEFAULT_JOB_DESCRIPTION_TITLE));
        jobDescription.setJobDesc(request.getJobDescription());
        jobDescription.setRequirementsTitle(
                defaultIfBlank(request.getRequirementsTitle(), DEFAULT_REQUIREMENTS_TITLE));
        jobDescription.setRequirements(StringListConverter.fromString(request.getRequirements()));
        jobDescription.setBenefitsTitle(defaultIfBlank(request.getBenefitsTitle(), DEFAULT_BENEFITS_TITLE));
        jobDescription.setBenefits(request.getBenefits());
        jobDescription.setLocation(request.getLocation());
        jobDescription.setSalaryRange(parseSalaryRange(request.getSalaryRange()));
        jobDescription.setJobType(request.getJobType());
        jobDescription.setExperienceLevel(blankToNull(request.getExperienceLevel()));
        jobDescription.setIndustry(blankToNull(request.getIndustry()));
        jobDescription.setPostedDate(parseDate(request.getPostedDate()));
        jobDescription.setApplyingDeadline(parseDate(request.getApplyingDeadline()));
        jobDescription.setStartDate(parseDate(request.getStartDate()));
        jobDescription.setEndDate(parseDate(request.getEndDate()));
        jobDescription.setYoe(request.getYoe());
        jobDescription.setCustomApplicationFields(blankToNull(request.getCustomApplicationFields()));
        jobDescription.setApplicationForm(toApplicationFormReference(request.getCustomApplicationFieldsId()));
        applyRequirementDetails(jobDescription, request.getRequirementDetails());
        return jobDescription;
    }

    public static JobResponse toResponse(Job jobDescription) {
        return new JobResponse(
                jobDescription.getId(),
                jobDescription.getJobTitle(),
                resolveAboutCompany(jobDescription.getRecruiter(), jobDescription.getAboutCompany()),
                defaultIfBlank(jobDescription.getJobDescriptionTitle(), DEFAULT_JOB_DESCRIPTION_TITLE),
                jobDescription.getJobDesc(),
                defaultIfBlank(jobDescription.getRequirementsTitle(), DEFAULT_REQUIREMENTS_TITLE),
                StringListConverter.join(jobDescription.getRequirements()),
                defaultIfBlank(jobDescription.getBenefitsTitle(), DEFAULT_BENEFITS_TITLE),
                jobDescription.getBenefits(),
                jobDescription.getLocation(),
                jobDescription.getSalaryRange() == null ? null : jobDescription.getSalaryRange().toString(),
                jobDescription.getJobType(),
                jobDescription.getExperienceLevel(),
                jobDescription.getIndustry(),
                jobDescription.getPostedDate() == null ? null : jobDescription.getPostedDate().toString(),
                jobDescription.getApplyingDeadline() == null ? null
                        : jobDescription.getApplyingDeadline().toString(),
                jobDescription.getStartDate() == null ? null : jobDescription.getStartDate().toString(),
                jobDescription.getEndDate() == null ? null : jobDescription.getEndDate().toString(),
                jobDescription.getYoe(),
                jobDescription.getApplicationForm() == null ? null : jobDescription.getApplicationForm().getId(),
                jobDescription.getCustomApplicationFields(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getId(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getCompanyName(),
                toRequirementDetailsResponse(jobDescription));
    }

    public static JobApplicantsResponse toApplicantsResponse(Long jobId, Long count) {
        return new JobApplicantsResponse(jobId, count);
    }

    private static Date parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return Date.valueOf(LocalDate.parse(value));
    }

    private static String parseSalaryRange(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return value;
    }

    private static String blankToNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return value;
    }

    private static String defaultIfBlank(String value, String defaultValue) {
        return value == null || value.isBlank() ? defaultValue : value.trim();
    }

    private static String resolveAboutCompany(Recruiter recruiter, String requestValue) {
        if (recruiter != null && recruiter.getCompanyDesc() != null && !recruiter.getCompanyDesc().isBlank()) {
            return recruiter.getCompanyDesc().trim();
        }
        return blankToNull(requestValue);
    }

    private static ApplicationForm toApplicationFormReference(Long id) {
        if (id == null) {
            return null;
        }
        ApplicationForm applicationForm = new ApplicationForm();
        applicationForm.setId(id);
        return applicationForm;
    }

    private static void applyRequirementDetails(Job job, JobRequirementDetailsRequest details) {
        job.setEducationRequirementMode(details.getEducationMode());
        boolean educationRequired = details.getEducationMode() != JobEducationRequirementModeEnum.NOT_REQUIRED;
        job.setEducationDegrees(educationRequired
                ? details.getDegrees().stream().map(JobDegreeEnum::name).distinct().toList()
                : List.of());
        job.setNoDegreeRequirement(educationRequired
                ? null
                : blankToNull(details.getNoDegreeRequirement()));
        job.setEducationMajors(educationRequired
                ? normalizeList(details.getEducationMajors())
                : List.of());
        job.setPreferredInstitutions(educationRequired
                ? normalizeList(details.getPreferredInstitutions())
                : List.of());
        job.setMinimumYearsExperience(details.getMinimumYearsExperience());
        job.setExperienceRequirements(normalizeList(details.getExperienceRequirements()));
        job.setRequiredSkills(normalizeList(details.getRequiredSkills()));
        job.setTechStack(normalizeList(details.getTechStack()));
        job.setEnglishRequired(details.getEnglishRequired());
        job.setEnglishLevel(Boolean.TRUE.equals(details.getEnglishRequired())
                ? normalizeEnglishLevel(details.getEnglishLevel())
                : null);
        job.setEnglishSkills(Boolean.TRUE.equals(details.getEnglishRequired())
                ? normalizeList(details.getEnglishSkills())
                : List.of());
        job.setEnglishCertificates(Boolean.TRUE.equals(details.getEnglishRequired())
                ? new ArrayList<>(details.getEnglishCertificates().stream()
                        .map(certificate -> new EnglishCertificateRequirement(
                                certificate.getCertificateName().trim(),
                                certificate.getMinimumScore().trim()))
                        .toList())
                : new ArrayList<>());
        job.setTools(normalizeList(details.getTools()));
        job.setTechnicalKnowledge(normalizeList(details.getTechnicalKnowledge()));
    }

    private static JobRequirementDetailsResponse toRequirementDetailsResponse(Job job) {
        return new JobRequirementDetailsResponse(
                job.getEducationRequirementMode(),
                toDegrees(job.getEducationDegrees()),
                job.getNoDegreeRequirement(),
                emptyIfNull(job.getEducationMajors()),
                emptyIfNull(job.getPreferredInstitutions()),
                job.getMinimumYearsExperience(),
                emptyIfNull(job.getExperienceRequirements()),
                emptyIfNull(job.getRequiredSkills()),
                emptyIfNull(job.getTechStack()),
                job.getEnglishRequired(),
                normalizeEnglishLevel(job.getEnglishLevel()),
                emptyIfNull(job.getEnglishSkills()),
                toEnglishCertificateResponses(job.getEnglishCertificates()),
                emptyIfNull(job.getTools()),
                emptyIfNull(job.getTechnicalKnowledge()));
    }

    private static List<EnglishCertificateRequirementResponse> toEnglishCertificateResponses(
            List<EnglishCertificateRequirement> values) {
        if (values == null) {
            return List.of();
        }
        return values.stream()
                .map(value -> new EnglishCertificateRequirementResponse(
                        value.getCertificateName(),
                        value.getMinimumScore()))
                .toList();
    }

    private static String normalizeEnglishLevel(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return switch (value.trim().toUpperCase()) {
            case "A1" -> "Beginner";
            case "A2" -> "Elementary";
            case "B1" -> "Intermediate";
            case "B2" -> "Upper-intermediate";
            case "C1" -> "Advanced";
            case "C2" -> "Proficient";
            default -> value.trim();
        };
    }

    private static List<JobDegreeEnum> toDegrees(List<String> values) {
        if (values == null) {
            return List.of();
        }
        return values.stream()
                .map(value -> JobDegreeEnum.valueOf(value.toUpperCase()))
                .distinct()
                .toList();
    }

    private static List<String> emptyIfNull(List<String> values) {
        return values == null ? List.of() : values;
    }

    private static List<String> normalizeList(List<String> values) {
        if (values == null) {
            return List.of();
        }
        return values.stream()
                .map(String::trim)
                .filter(value -> !value.isEmpty())
                .distinct()
                .toList();
    }
}
