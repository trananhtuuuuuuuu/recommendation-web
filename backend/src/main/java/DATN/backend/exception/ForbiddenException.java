package DATN.backend.exception;

/**
 * Indicates that an authenticated user is not allowed to perform an operation.
 */
public class ForbiddenException extends RuntimeException {

    /**
     * Creates a forbidden-operation exception.
     *
     * @param message user-facing explanation of why access was denied
     */
    public ForbiddenException(String message) {
        super(message);
    }
}
