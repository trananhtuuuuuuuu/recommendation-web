package DATN.backend.service.ImplService;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.Enum.CvMatchViewerRoleEnum;
import DATN.backend.model.Applicant;
import DATN.backend.model.Certificate;
import DATN.backend.model.Cv;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
import DATN.backend.model.Job;
import DATN.backend.model.JobLanguageRequirement;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.response.applicant.CvJobMatchResponse;
import DATN.backend.response.cv.CvMatchAiResponse;
import DATN.backend.service.InterfaceService.InterfaceCvAiService;
import DATN.backend.service.InterfaceService.InterfaceCvMatchService;
import DATN.backend.utils.StringListConverter;
import lombok.RequiredArgsConstructor;

/**
 * Builds the canonical CV from the applicant's stored profile fields (no extra
 * persistence / re-parsing) and delegates scoring to the AI /match endpoint.
 */
@Service
@RequiredArgsConstructor
public class ImplCvMatchService implements InterfaceCvMatchService {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private final ApplicantRepository applicantRepository;
    private final JobRepository jobDescriptionRepository;
    private final InterfaceCvAiService cvAiService;

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional(readOnly = true)
    public CvJobMatchResponse matchApplicantToJob(Long applicantId, Long jobId, CvJobMatchRequest request) {
        Applicant applicant = applicantRepository.findById(applicantId)
                .orElseThrow(() -> new ResourcesNotFoundException("Applicant not found"));
        Cv cv = applicant.getCv();
        if (cv == null) {
            throw new ResourcesNotFoundException("Applicant has no CV to match; upload a CV first");
        }
        Job job = jobDescriptionRepository.findById(jobId)
                .orElseThrow(() -> new ResourcesNotFoundException("Job not found"));

        CvMatchAiResponse ai = cvAiService.matchCvToJob(
                buildCanonical(cv),
                buildJd(job),
                Boolean.TRUE.equals(request.getLlm()),
                request.getMethod(),
                request.getViewerRole() == null
                        ? CvMatchViewerRoleEnum.APPLICANT
                        : request.getViewerRole());

        List<String> hardReasons = (ai.getHardFilter() == null || ai.getHardFilter().getReasons() == null)
                ? List.of()
                : ai.getHardFilter().getReasons();
        double matchScore = clamp(ai.getMatchScore(), 0.0, 1.0);
        return new CvJobMatchResponse(
                applicantId,
                jobId,
                ai.isPassedFilter(),
                matchScore,
                (int) Math.round(matchScore * 100),
                ai.getReason(),
                ai.getSuggestions() == null ? List.of() : ai.getSuggestions(),
                ai.getPerFieldScores() == null ? Map.of() : ai.getPerFieldScores(),
                hardReasons,
                ai.getScoringMethod(),
                ai.getModelUsed(),
                false,
                null,
                null,
                null);
    }

    private double clamp(double value, double min, double max) {
        return Math.max(min, Math.min(max, value));
    }

    /** Reconstruct the AI canonical CV (entitiesByLabel) from the stored Cv fields. */
    private Map<String, Object> buildCanonical(Cv cv) {
        List<String> titles = new ArrayList<>();
        List<String> companies = new ArrayList<>();
        List<String> dates = new ArrayList<>();
        List<String> descriptions = new ArrayList<>();
        addExperience(cv.getExperienceObj(), titles, companies, dates, descriptions);

        Map<String, Object> byLabel = new HashMap<>();
        byLabel.put("SKILL", cv.getSkills() == null ? List.of() : cv.getSkills());
        byLabel.put("CERTIFICATION", certificateList(cv.getCertificate()));
        byLabel.put("EDUCATION", educationList(cv.getEducationObj()));
        byLabel.put("SUMMARY", textList(cv.getObjective()));
        byLabel.put("CANDIDATE_LOCATION", textList(cv.getAddress()));
        byLabel.put("JOB_TITLE", titles);
        byLabel.put("COMPANY", companies);
        byLabel.put("DATE", dates);
        byLabel.put("EXPERIENCE", descriptions);

        Map<String, Object> canonical = new HashMap<>();
        canonical.put("entitiesByLabel", byLabel);
        canonical.put("summary", cv.getObjective() == null ? "" : cv.getObjective());
        Double totalExperienceYears = totalExperienceYears(cv.getExperienceObj());
        if (totalExperienceYears != null) {
            canonical.put("totalExperienceYears", totalExperienceYears);
        }
        // Matching only uses the persisted profile, which the applicant reviewed
        // and confirmed after AI extraction.
        canonical.put("experienceYearsConfirmed", true);
        return canonical;
    }

    private void addExperience(Experience experience, List<String> titles, List<String> companies,
            List<String> dates, List<String> descriptions) {
        if (experience == null) {
            return;
        }
        // UploadCvRequest currently stores a multi-company experience array in
        // contribution while keeping only the first company in scalar columns.
        // Expand that JSON here so AI receives every company/date/description.
        if (addEmbeddedExperiences(
                experience.getContribution(),
                titles,
                companies,
                dates,
                descriptions)) {
            return;
        }
        addIfPresent(titles, experience.getJobTitle());
        addIfPresent(companies, experience.getCompanyName());
        addIfPresent(descriptions, experience.getContribution());
        if (experience.getStartDate() != null) {
            String end = experience.getEndDate() != null
                    ? experience.getEndDate().toString()
                    : Boolean.TRUE.equals(experience.getIsPresent())
                            ? "Present"
                            : "";
            dates.add(end.isBlank()
                    ? experience.getStartDate().toString()
                    : experience.getStartDate() + " - " + end);
        } else {
            addIfPresent(dates, experience.getTime());
        }
    }

    private boolean addEmbeddedExperiences(
            String contribution,
            List<String> titles,
            List<String> companies,
            List<String> dates,
            List<String> descriptions) {
        if (contribution == null || !contribution.stripLeading().startsWith("[")) {
            return false;
        }
        try {
            JsonNode entries = OBJECT_MAPPER.readTree(contribution);
            if (!entries.isArray()) {
                return false;
            }
            boolean found = false;
            for (JsonNode entry : entries) {
                if (!entry.isObject()) {
                    continue;
                }
                found = true;
                addIfPresent(companies, jsonText(entry, "companyName"));
                addIfPresent(titles, firstJsonText(entry, "jobTitle", "position"));
                addIfPresent(dates, firstJsonText(entry, "time", "period"));
                addIfPresent(
                        descriptions,
                        firstJsonText(entry, "description", "contribution"));
            }
            return found;
        } catch (Exception ignored) {
            // A normal free-text contribution follows the scalar path above.
            return false;
        }
    }

    private String firstJsonText(JsonNode node, String first, String second) {
        String value = jsonText(node, first);
        return value == null || value.isBlank() ? jsonText(node, second) : value;
    }

    private String jsonText(JsonNode node, String field) {
        JsonNode value = node.get(field);
        return value == null || value.isNull() ? null : value.asText();
    }

    private Double totalExperienceYears(Experience experience) {
        if (experience == null || experience.getStartDate() == null) {
            // Do not send a misleading zero. The AI service will calculate YOE
            // from every DATE range expanded above and merge overlapping jobs.
            return null;
        }
        LocalDate start = experience.getStartDate().toLocalDate();
        LocalDate end = experience.getEndDate() != null
                ? experience.getEndDate().toLocalDate()
                : Boolean.TRUE.equals(experience.getIsPresent())
                        ? LocalDate.now()
                        : null;
        if (end == null || end.isBefore(start)) {
            return null;
        }
        double years = ChronoUnit.DAYS.between(start, end) / 365.25;
        return Math.round(years * 100.0) / 100.0;
    }

    private void addIfPresent(List<String> target, String value) {
        if (value != null && !value.isBlank()) {
            target.add(value.trim());
        }
    }

    private Map<String, Object> buildJd(Job job) {
        Map<String, Object> jd = new HashMap<>();
        jd.put("jobTitle", nullToEmpty(job.getJobTitle()));
        jd.put("aboutCompany", nullToEmpty(job.getAboutCompany() != null ? job.getAboutCompany()
                : job.getRecruiter() != null ? job.getRecruiter().getCompanyDesc() : ""));
        jd.put("jobDescription", nullToEmpty(job.getJobDesc()));
        jd.put("requirements", nullToEmpty(StringListConverter.join(job.getRequirements())));
        jd.put("benefits", nullToEmpty(StringListConverter.join(job.getBenefits())));
        jd.put("location", nullToEmpty(job.getLocation()));
        jd.put("salaryRange", job.getSalaryRange() == null ? "" : job.getSalaryRange().toString());
        jd.put("jobType", nullToEmpty(job.getJobType()));
        jd.put("experienceLevel", nullToEmpty(job.getExperienceLevel() != null ? job.getExperienceLevel()
                : job.getYoe() == null ? "" : job.getYoe()));
        jd.put("industry", nullToEmpty(job.getIndustry()));
        jd.put("educationMode",
                job.getEducationRequirementMode() == null ? "" : job.getEducationRequirementMode().name());
        String degrees = nullToEmpty(StringListConverter.join(job.getEducationDegrees()));
        jd.put("degrees", degrees);
        jd.put("educationLevel",
                job.getEducationDegrees() == null || job.getEducationDegrees().isEmpty()
                        ? ""
                        : job.getEducationDegrees().getFirst());
        jd.put("noDegreeRequirement", nullToEmpty(job.getNoDegreeRequirement()));
        jd.put("educationMajors", nullToEmpty(StringListConverter.join(job.getEducationMajors())));
        jd.put("preferredInstitutions", nullToEmpty(StringListConverter.join(job.getPreferredInstitutions())));
        jd.put("minimumYearsExperience",
                job.getMinimumYearsExperience() == null ? "" : job.getMinimumYearsExperience().toString());
        String experienceRequirements = nullToEmpty(StringListConverter.join(job.getExperienceRequirements()));
        jd.put("experienceRequirements", experienceRequirements);
        jd.put("experienceDescription", experienceRequirements);
        jd.put("requiredSkills", nullToEmpty(StringListConverter.join(job.getRequiredSkills())));
        jd.put("techStack", nullToEmpty(StringListConverter.join(job.getTechStack())));
        List<JobLanguageRequirement> languages = job.getLanguageRequirements() == null
                ? List.of()
                : job.getLanguageRequirements();
        jd.put("languageRequired", !languages.isEmpty());
        jd.put("languageRequirements", languages.stream()
                .map(this::toLanguageRequirementPayload)
                .toList());
        JobLanguageRequirement english = languages.stream()
                .filter(language -> language.getLanguageName() != null
                        && language.getLanguageName().equalsIgnoreCase("English"))
                .findFirst()
                .orElse(null);
        jd.put("englishRequired", english != null);
        jd.put("englishLevel", english == null ? "" : nullToEmpty(english.getProficiencyLevel()));
        jd.put("englishSkills", english == null ? "" : nullToEmpty(StringListConverter.join(english.getSkills())));
        jd.put("englishCertificates", english == null || english.getCertificates() == null
                ? ""
                : english.getCertificates().stream()
                        .map(certificate -> certificate.getCertificateName() + ": " + certificate.getMinimumScore())
                        .collect(java.util.stream.Collectors.joining("\n")));
        jd.put("tools", nullToEmpty(StringListConverter.join(job.getTools())));
        jd.put("technicalKnowledge", nullToEmpty(StringListConverter.join(job.getTechnicalKnowledge())));
        return jd;
    }

    private Map<String, Object> toLanguageRequirementPayload(JobLanguageRequirement language) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("languageName", nullToEmpty(language.getLanguageName()));
        payload.put("proficiencyLevel", nullToEmpty(language.getProficiencyLevel()));
        payload.put("skills", language.getSkills() == null ? List.of() : language.getSkills());
        payload.put("certificates", language.getCertificates() == null
                ? List.of()
                : language.getCertificates().stream()
                        .map(certificate -> Map.of(
                                "certificateName", nullToEmpty(certificate.getCertificateName()),
                                "minimumScore", nullToEmpty(certificate.getMinimumScore())))
                        .toList());
        return payload;
    }

    private List<String> textList(String value) {
        return (value == null || value.isBlank()) ? new ArrayList<>() : List.of(value.trim());
    }

    private List<String> certificateList(Certificate certificate) {
        if (certificate == null) {
            return List.of();
        }
        List<String> values = new ArrayList<>();
        addIfPresent(values, certificate.getScore());
        addIfPresent(values, certificate.getProvider());
        addIfPresent(values, certificate.getName());
        return values;
    }

    private List<String> educationList(Education education) {
        if (education == null) {
            return List.of();
        }
        List<String> values = new ArrayList<>();
        if (education.getDegree() != null) {
            values.add(education.getDegree().name());
        }
        addIfPresent(values, education.getMajor());
        addIfPresent(values, education.getName());
        return values;
    }

    private String nullToEmpty(String value) {
        return value == null ? "" : value;
    }
}
