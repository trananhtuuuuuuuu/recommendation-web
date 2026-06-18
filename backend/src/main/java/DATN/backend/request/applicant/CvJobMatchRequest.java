package DATN.backend.request.applicant;

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
    private boolean llm = false;

    /** Scoring method: "embedding" or "tfidf". Null/blank uses the AI service default. */
    private String method;
}
