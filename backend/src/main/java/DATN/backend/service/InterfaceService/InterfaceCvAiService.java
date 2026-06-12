package DATN.backend.service.InterfaceService;

import org.springframework.web.multipart.MultipartFile;

import DATN.backend.response.cv.CvAnalysisResponse;

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
}
