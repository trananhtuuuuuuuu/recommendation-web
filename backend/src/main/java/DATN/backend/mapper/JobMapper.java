package DATN.backend.mapper;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import DATN.backend.Enum.JobDegreeEnum;
import DATN.backend.Enum.JobEducationRequirementModeEnum;
import DATN.backend.model.ApplicationForm;
import DATN.backend.model.Job;
import DATN.backend.model.JobLanguageRequirement;
import DATN.backend.model.LanguageCertificateRequirement;
import DATN.backend.model.Recruiter;
import DATN.backend.request.recruiter.LanguageRequirementRequest;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.response.job.EnglishCertificateRequirementResponse;
import DATN.backend.response.job.LanguageCertificateRequirementResponse;
import DATN.backend.response.job.LanguageRequirementResponse;
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
        replaceLanguageRequirements(job, details);
        job.setTools(normalizeList(details.getTools()));
        job.setTechnicalKnowledge(normalizeList(details.getTechnicalKnowledge()));
    }

    private static JobRequirementDetailsResponse toRequirementDetailsResponse(Job job) {
        List<LanguageRequirementResponse> languages = toLanguageRequirementResponses(job.getLanguageRequirements());
        LanguageRequirementResponse english = languages.stream()
                .filter(language -> "english".equals(language.getLanguageName().trim().toLowerCase(Locale.ROOT)))
                .findFirst()
                .orElse(null);
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
                !languages.isEmpty(),
                languages,
                english != null,
                english == null ? null : english.getProficiencyLevel(),
                english == null ? List.of() : english.getSkills(),
                english == null ? List.of() : toLegacyEnglishCertificateResponses(english.getCertificates()),
                emptyIfNull(job.getTools()),
                emptyIfNull(job.getTechnicalKnowledge()));
    }

    private static void replaceLanguageRequirements(Job job, JobRequirementDetailsRequest details) {
        List<LanguageRequirementRequest> requestedLanguages;
        if (details.getLanguageRequired() != null) {
            requestedLanguages = Boolean.TRUE.equals(details.getLanguageRequired())
                    ? details.getLanguageRequirements()
                    : List.of();
        } else if (Boolean.TRUE.equals(details.getEnglishRequired())) {
            requestedLanguages = List.of(new LanguageRequirementRequest(
                    "English",
                    normalizeEnglishLevel(details.getEnglishLevel()),
                    details.getEnglishSkills(),
                    details.getEnglishCertificates().stream()
                            .map(certificate -> new DATN.backend.request.recruiter.LanguageCertificateRequirementRequest(
                                    certificate.getCertificateName(),
                                    certificate.getMinimumScore()))
                            .toList()));
        } else {
            requestedLanguages = List.of();
        }

        if (job.getLanguageRequirements() == null) {
            job.setLanguageRequirements(new ArrayList<>());
        }

        List<JobLanguageRequirement> existingLanguages = job.getLanguageRequirements();
        int sharedLanguageCount = Math.min(existingLanguages.size(), requestedLanguages.size());
        for (int index = 0; index < sharedLanguageCount; index++) {
            updateLanguageRequirement(existingLanguages.get(index), requestedLanguages.get(index));
        }

        if (requestedLanguages.size() < existingLanguages.size()) {
            existingLanguages.subList(requestedLanguages.size(), existingLanguages.size()).clear();
            return;
        }

        int nextDisplayOrder = existingLanguages.stream()
                .map(JobLanguageRequirement::getDisplayOrder)
                .filter(java.util.Objects::nonNull)
                .max(Integer::compareTo)
                .map(order -> order + 1)
                .orElse(0);
        for (int index = existingLanguages.size(); index < requestedLanguages.size(); index++) {
            JobLanguageRequirement language = new JobLanguageRequirement();
            language.setJob(job);
            language.setDisplayOrder(nextDisplayOrder++);
            updateLanguageRequirement(language, requestedLanguages.get(index));
            existingLanguages.add(language);
        }
    }

    /**
     * Applies recruiter-entered language fields to an existing managed child
     * entity while preserving its database identity and display-order slot.
     *
     * @param language managed or newly created language requirement
     * @param request recruiter-entered language requirement
     */
    private static void updateLanguageRequirement(JobLanguageRequirement language,
            LanguageRequirementRequest request) {
        language.setLanguageName(request.getLanguageName().trim());
        language.setProficiencyLevel(request.getProficiencyLevel().trim());
        language.setSkills(new ArrayList<>(normalizeList(request.getSkills())));
        reconcileLanguageCertificates(language, request);
    }

    /**
     * Reconciles certificate values in place so Hibernate does not replace the
     * ordered collection with a detached list.
     *
     * @param language managed or newly created language requirement
     * @param request recruiter-entered language requirement
     */
    private static void reconcileLanguageCertificates(JobLanguageRequirement language,
            LanguageRequirementRequest request) {
        if (language.getCertificates() == null) {
            language.setCertificates(new ArrayList<>());
        }

        List<LanguageCertificateRequirement> certificates = language.getCertificates();
        int sharedCertificateCount = Math.min(certificates.size(), request.getCertificates().size());
        for (int index = 0; index < sharedCertificateCount; index++) {
            LanguageCertificateRequirement certificate = certificates.get(index);
            certificate.setCertificateName(request.getCertificates().get(index).getCertificateName().trim());
            certificate.setMinimumScore(request.getCertificates().get(index).getMinimumScore().trim());
        }
        if (request.getCertificates().size() < certificates.size()) {
            certificates.subList(request.getCertificates().size(), certificates.size()).clear();
            return;
        }
        for (int index = certificates.size(); index < request.getCertificates().size(); index++) {
            certificates.add(new LanguageCertificateRequirement(
                    request.getCertificates().get(index).getCertificateName().trim(),
                    request.getCertificates().get(index).getMinimumScore().trim()));
        }
    }

    private static List<LanguageRequirementResponse> toLanguageRequirementResponses(
            List<JobLanguageRequirement> values) {
        if (values == null) {
            return List.of();
        }
        return values.stream()
                .map(value -> new LanguageRequirementResponse(
                        value.getLanguageName(),
                        value.getProficiencyLevel(),
                        emptyIfNull(value.getSkills()),
                        value.getCertificates() == null
                                ? List.of()
                                : value.getCertificates().stream()
                                        .map(certificate -> new LanguageCertificateRequirementResponse(
                                                certificate.getCertificateName(),
                                                certificate.getMinimumScore()))
                                        .toList()))
                .toList();
    }

    private static List<EnglishCertificateRequirementResponse> toLegacyEnglishCertificateResponses(
            List<LanguageCertificateRequirementResponse> values) {
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
