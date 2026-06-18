package DATN.backend.exception;

/**
 * Indicates that the CV analysis service cannot currently process a request.
 */
public class AiServiceUnavailableException extends RuntimeException {

    /**
     * Creates an AI-service availability exception.
     *
     * @param message user-facing availability message
     */
    public AiServiceUnavailableException(String message) {
        super(message);
    }
}
