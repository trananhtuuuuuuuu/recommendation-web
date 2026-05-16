package DATN.backend.exception;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ControllerAdvice;

import DATN.backend.response.ApiResponse;

@ControllerAdvice
public class GlobalException {

    @ExceptionHandler(AlreadyExistException.class)
    public ResponseEntity<ApiResponse> handleAlreadyExistException(AlreadyExistException exception) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(ApiResponse.failure(
                exception.getMessage(),
                HttpStatus.CONFLICT,
                exception.getMessage(),
                List.of(exception.getMessage())));
    }

    @ExceptionHandler(ResourcesNotFoundException.class)
    public ResponseEntity<ApiResponse> handleResourcesNotFoundException(ResourcesNotFoundException exception) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.failure(
                exception.getMessage(),
                HttpStatus.NOT_FOUND,
                exception.getMessage(),
                List.of(exception.getMessage())));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse> handleMethodArgumentNotValidException(
            MethodArgumentNotValidException exception) {
        List<String> errors = exception.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .toList();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.failure(
                "Validation failed",
                HttpStatus.BAD_REQUEST,
                "Validation failed",
                errors));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse> handleIllegalArgumentException(IllegalArgumentException exception) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.failure(
                exception.getMessage(),
                HttpStatus.BAD_REQUEST,
                exception.getMessage(),
                List.of(exception.getMessage())));
    }

}
