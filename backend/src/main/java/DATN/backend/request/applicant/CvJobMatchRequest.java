package DATN.backend.request.applicant;

import DATN.backend.Enum.CvMatchViewerRoleEnum;
import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Options for matching an applicant's CV against a job description.
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CvJobMatchRequest {

    /** Use the local LLM (Ollama) for richer suggestions; slower. Defaults to false. */
    private Boolean llm = false;

    /** Scoring method: "embedding" or "tfidf". Null/blank uses the AI service default. */
    private String method;

    /**
     * Audience for the generated guidance. Public controllers overwrite this value
     * from the authenticated endpoint context instead of trusting client input.
     */
    @JsonIgnore
    @Schema(hidden = true)
    private CvMatchViewerRoleEnum viewerRole = CvMatchViewerRoleEnum.APPLICANT;

    public CvJobMatchRequest(Boolean llm, String method) {
        this(llm, method, CvMatchViewerRoleEnum.APPLICANT);
    }
}
