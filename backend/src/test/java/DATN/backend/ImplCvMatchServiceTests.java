package DATN.backend;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import DATN.backend.Enum.DegreeEnum;
import DATN.backend.Enum.JobEducationRequirementModeEnum;
import DATN.backend.model.Applicant;
import DATN.backend.model.Certificate;
import DATN.backend.model.Cv;
import DATN.backend.model.Education;
import DATN.backend.model.Job;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.request.applicant.CvJobMatchRequest;
import DATN.backend.response.applicant.CvJobMatchResponse;
import DATN.backend.response.cv.CvMatchAiResponse;
import DATN.backend.service.ImplService.ImplCvMatchService;
import DATN.backend.service.InterfaceService.InterfaceCvAiService;

/**
 * Verifies that CV matching returns the canonical AI score without score noise.
 */
class ImplCvMatchServiceTests {

    @Test
    void shouldReturnRawAiScoreWithoutDifferentialPrivacyNoise() {
        ApplicantRepository applicantRepository = mock(ApplicantRepository.class);
        JobRepository jobRepository = mock(JobRepository.class);
        InterfaceCvAiService aiService = mock(InterfaceCvAiService.class);
        ImplCvMatchService service = new ImplCvMatchService(applicantRepository, jobRepository, aiService);

        Cv cv = new Cv();
        cv.setSkills(List.of("Java", "Spring Boot"));
        Education education = new Education();
        education.setDegree(DegreeEnum.BSc);
        education.setMajor("Computer Science");
        education.setName("HCMUS");
        cv.setEducationObj(education);
        Certificate certificate = new Certificate();
        certificate.setScore("900");
        certificate.setProvider("TOEIC");
        certificate.setName("English Certificate");
        cv.setCertificate(certificate);
        Applicant applicant = new Applicant();
        applicant.setId(10L);
        applicant.setCv(cv);
        Job job = new Job();
        job.setId(20L);
        job.setJobTitle("Backend Engineer");
        job.setEducationRequirementMode(JobEducationRequirementModeEnum.MINIMUM);
        job.setEducationDegrees(List.of("BACHELOR"));
        job.setEducationMajors(List.of("Computer Science"));
        job.setPreferredInstitutions(List.of("HCMUS"));
        job.setMinimumYearsExperience(3);
        job.setExperienceRequirements(List.of("Built production REST APIs"));
        job.setRequiredSkills(List.of("Java", "Debugging"));
        job.setTechStack(List.of("Spring Boot", "PostgreSQL"));
        job.setEnglishRequired(true);
        job.setEnglishLevel("B2");
        job.setEnglishSkills(List.of("Speaking", "Reading"));
        job.setTools(List.of("Git", "Postman"));
        job.setTechnicalKnowledge(List.of("REST API", "System design"));

        CvMatchAiResponse aiResponse = new CvMatchAiResponse();
        aiResponse.setPassedFilter(true);
        aiResponse.setMatchScore(0.8234);
        aiResponse.setScoringMethod("tfidf");
        aiResponse.setReason("Strong skills match");
        aiResponse.setSuggestions(List.of("Add production metrics"));
        aiResponse.setPerFieldScores(Map.of("SKILL", 0.9));

        when(applicantRepository.findById(10L)).thenReturn(Optional.of(applicant));
        when(jobRepository.findById(20L)).thenReturn(Optional.of(job));
        when(aiService.matchCvToJob(any(), any(), anyBoolean(), anyString())).thenReturn(aiResponse);

        CvJobMatchRequest request = new CvJobMatchRequest(false, "tfidf");
        CvJobMatchResponse result = service.matchApplicantToJob(10L, 20L, request);

        assertThat(result.getMatchScore()).isEqualTo(0.8234);
        assertThat(result.getMatchPercent()).isEqualTo(82);
        assertThat(result.isDifferentialPrivacyApplied()).isFalse();
        assertThat(result.getPrivacyEpsilon()).isNull();
        assertThat(result.getScoreSensitivity()).isNull();
        assertThat(result.getPrivacyMechanism()).isNull();

        ArgumentCaptor<Map<String, Object>> cvCaptor = ArgumentCaptor.captor();
        ArgumentCaptor<Map<String, Object>> jdCaptor = ArgumentCaptor.captor();
        org.mockito.Mockito.verify(aiService).matchCvToJob(
                cvCaptor.capture(), jdCaptor.capture(), anyBoolean(), anyString());
        Object entitiesValue = cvCaptor.getValue().get("entitiesByLabel");
        assertThat(entitiesValue).isInstanceOf(Map.class);
        Map<?, ?> entities = (Map<?, ?>) entitiesValue;
        assertThat(entities.get("EDUCATION"))
                .isEqualTo(List.of("BSc", "Computer Science", "HCMUS"));
        assertThat(entities.get("CERTIFICATION"))
                .isEqualTo(List.of("900", "TOEIC", "English Certificate"));
        assertThat(jdCaptor.getValue())
                .containsEntry("educationMode", "MINIMUM")
                .containsEntry("degrees", "BACHELOR")
                .containsEntry("educationLevel", "BACHELOR")
                .containsEntry("educationMajors", "Computer Science")
                .containsEntry("preferredInstitutions", "HCMUS")
                .containsEntry("minimumYearsExperience", "3")
                .containsEntry("experienceRequirements", "Built production REST APIs")
                .containsEntry("experienceDescription", "Built production REST APIs")
                .containsEntry("requiredSkills", "Java\nDebugging")
                .containsEntry("techStack", "Spring Boot\nPostgreSQL")
                .containsEntry("englishRequired", true)
                .containsEntry("englishLevel", "B2")
                .containsEntry("englishSkills", "Speaking\nReading")
                .containsEntry("tools", "Git\nPostman")
                .containsEntry("technicalKnowledge", "REST API\nSystem design");
    }
}
