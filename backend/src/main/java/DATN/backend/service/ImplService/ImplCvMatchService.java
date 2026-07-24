package DATN.backend.service.ImplService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.model.Applicant;
import DATN.backend.model.Certificate;
import DATN.backend.model.Cv;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
import DATN.backend.model.Job;
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
                buildCanonical(cv), buildJd(job), Boolean.TRUE.equals(request.getLlm()), request.getMethod());

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
        return canonical;
    }

    private void addExperience(Experience experience, List<String> titles, List<String> companies,
            List<String> dates, List<String> descriptions) {
        if (experience == null) {
            return;
        }
        addIfPresent(titles, experience.getJobTitle());
        addIfPresent(companies, experience.getCompanyName());
        addIfPresent(descriptions, experience.getContribution());
        if (experience.getStartDate() != null) {
            dates.add(experience.getStartDate().toString());
        }
        if (experience.getEndDate() != null) {
            dates.add(experience.getEndDate().toString());
        } else if (Boolean.TRUE.equals(experience.getIsPresent())) {
            dates.add("Present");
        }
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
        return jd;
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
