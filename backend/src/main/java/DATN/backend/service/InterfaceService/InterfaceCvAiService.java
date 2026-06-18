package DATN.backend.service.InterfaceService;

import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import DATN.backend.response.cv.CvAnalysisResponse;
import DATN.backend.response.cv.CvMatchAiResponse;

/**
 * Defines CV analysis operations supplied by the external AI service.
 */
public interface InterfaceCvAiService {

    /**
     * Extracts applicant profile suggestions from a CV file.
     *
     * @param cvFile uploaded CV document
     * @return extracted profile suggestions
     */
    CvAnalysisResponse analyzeCv(MultipartFile cvFile);

    /**
     * Scores a canonical CV against a structured job description.
     *
     * @param cv canonical CV map (entitiesByLabel + summary)
     * @param jd structured job description fields
     * @param llm whether to use the local LLM for richer suggestions
     * @param method scoring method ("embedding"/"tfidf"); null uses the AI default
     * @return match score, reason, and suggestions
     */
    CvMatchAiResponse matchCvToJob(Map<String, Object> cv, Map<String, Object> jd, boolean llm, String method);
}
