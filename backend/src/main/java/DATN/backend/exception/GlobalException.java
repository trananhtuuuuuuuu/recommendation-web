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
        return ResponseEntity.status(HttpStatus.CONFLICT).body(new ApiResponse(
                exception.getMessage(),
                HttpStatus.CONFLICT.value(),
                exception.getMessage(),
                List.of(exception.getMessage()),
                null));
    }

    @ExceptionHandler(ResourcesNotFoundException.class)
    public ResponseEntity<ApiResponse> handleResourcesNotFoundException(ResourcesNotFoundException exception) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ApiResponse(
                exception.getMessage(),
                HttpStatus.NOT_FOUND.value(),
                exception.getMessage(),
                List.of(exception.getMessage()),
                null));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse> handleMethodArgumentNotValidException(
            MethodArgumentNotValidException exception) {
        List<String> errors = exception.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .toList();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ApiResponse(
                "Validation failed",
                HttpStatus.BAD_REQUEST.value(),
                "Validation failed",
                errors,
                null));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse> handleIllegalArgumentException(IllegalArgumentException exception) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ApiResponse(
                exception.getMessage(),
                HttpStatus.BAD_REQUEST.value(),
                exception.getMessage(),
                List.of(exception.getMessage()),
                null));
    }

}
