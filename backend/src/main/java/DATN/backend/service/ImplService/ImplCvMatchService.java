package DATN.backend.service.ImplService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.model.Applicant;
import DATN.backend.model.Cv;
import DATN.backend.model.JobDescription;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.JobDescriptionRepository;
import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.response.applicant.CvJobMatchResponse;
import DATN.backend.response.cv.CvMatchAiResponse;
import DATN.backend.service.InterfaceService.InterfaceCvAiService;
import DATN.backend.service.InterfaceService.InterfaceCvMatchService;
import lombok.RequiredArgsConstructor;

/**
 * Builds the canonical CV from the applicant's stored profile fields (no extra
 * persistence / re-parsing) and delegates scoring to the AI /match endpoint.
 */
@Service
@RequiredArgsConstructor
public class ImplCvMatchService implements InterfaceCvMatchService {

    private final ApplicantRepository applicantRepository;
    private final JobDescriptionRepository jobDescriptionRepository;
    private final InterfaceCvAiService cvAiService;
    private final ObjectMapper objectMapper = new ObjectMapper();

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
        JobDescription job = jobDescriptionRepository.findById(jobId)
                .orElseThrow(() -> new ResourcesNotFoundException("Job not found"));

        CvMatchAiResponse ai = cvAiService.matchCvToJob(
                buildCanonical(cv), buildJd(job), request.isLlm(), request.getMethod());

        List<String> hardReasons = (ai.getHardFilter() == null || ai.getHardFilter().getReasons() == null)
                ? List.of()
                : ai.getHardFilter().getReasons();
        return new CvJobMatchResponse(
                applicantId,
                jobId,
                ai.isPassedFilter(),
                ai.getMatchScore(),
                (int) Math.round(ai.getMatchScore() * 100),
                ai.getReason(),
                ai.getSuggestions() == null ? List.of() : ai.getSuggestions(),
                ai.getPerFieldScores() == null ? Map.of() : ai.getPerFieldScores(),
                hardReasons,
                ai.getScoringMethod(),
                ai.getModelUsed());
    }

    /** Reconstruct the AI canonical CV (entitiesByLabel) from the stored Cv fields. */
    private Map<String, Object> buildCanonical(Cv cv) {
        List<String> titles = new ArrayList<>();
        List<String> companies = new ArrayList<>();
        List<String> dates = new ArrayList<>();
        List<String> descriptions = new ArrayList<>();
        parseExperience(cv.getExperience(), titles, companies, dates, descriptions);

        Map<String, Object> byLabel = new HashMap<>();
        byLabel.put("SKILL", splitList(cv.getSkills()));
        byLabel.put("CERTIFICATION", splitList(cv.getCertifications()));
        byLabel.put("EDUCATION", splitList(cv.getEducation()));
        byLabel.put("SUMMARY", textList(cv.getObjective()));
        byLabel.put("CANDIDATE_LOCATION", textList(cv.getAddress()));
        byLabel.put("JOB_TITLE", titles);
        byLabel.put("COMPANY", companies);
        byLabel.put("DATE", dates);
        byLabel.put("EXPERIENCE", descriptions);

        Map<String, Object> canonical = new HashMap<>();
        canonical.put("entitiesByLabel", byLabel);
        canonical.put("summary", cv.getObjective() == null ? "" : cv.getObjective());
        return canonical;
    }

    /** The Cv.experience column is a JSON array of {position, companyName, time, description}. */
    private void parseExperience(String experience, List<String> titles, List<String> companies,
            List<String> dates, List<String> descriptions) {
        if (experience == null || experience.isBlank()) {
            return;
        }
        try {
            JsonNode node = objectMapper.readTree(experience);
            if (node.isArray()) {
                for (JsonNode item : node) {
                    addIfPresent(titles, item, "position");
                    addIfPresent(companies, item, "companyName");
                    addIfPresent(dates, item, "time");
                    addIfPresent(descriptions, item, "description");
                }
                return;
            }
        } catch (Exception ignored) {
            // Not JSON -> fall through and treat the whole value as one experience blob.
        }
        descriptions.add(experience.trim());
    }

    private void addIfPresent(List<String> target, JsonNode item, String field) {
        JsonNode value = item.get(field);
        if (value != null && !value.asText().isBlank()) {
            target.add(value.asText().trim());
        }
    }

    private Map<String, Object> buildJd(JobDescription job) {
        Map<String, Object> jd = new HashMap<>();
        jd.put("jobTitle", nullToEmpty(job.getJobTitle()));
        jd.put("aboutCompany", nullToEmpty(job.getAboutCompany()));
        jd.put("jobDescription", nullToEmpty(job.getJobDescription()));
        jd.put("requirements", nullToEmpty(job.getRequirements()));
        jd.put("benefits", nullToEmpty(job.getBenefits()));
        jd.put("location", nullToEmpty(job.getLocation()));
        jd.put("salaryRange", nullToEmpty(job.getSalaryRange()));
        jd.put("jobType", nullToEmpty(job.getJobType()));
        jd.put("experienceLevel", nullToEmpty(job.getExperienceLevel()));
        jd.put("industry", nullToEmpty(job.getIndustry()));
        return jd;
    }

    private List<String> splitList(String value) {
        List<String> out = new ArrayList<>();
        if (value == null || value.isBlank()) {
            return out;
        }
        for (String part : value.split("[,;\\n|]")) {
            String trimmed = part.trim();
            if (!trimmed.isEmpty()) {
                out.add(trimmed);
            }
        }
        return out;
    }

    private List<String> textList(String value) {
        return (value == null || value.isBlank()) ? new ArrayList<>() : List.of(value.trim());
    }

    private String nullToEmpty(String value) {
        return value == null ? "" : value;
    }
}
