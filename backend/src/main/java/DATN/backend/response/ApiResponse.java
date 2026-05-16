package DATN.backend.response;

import java.util.List;

import org.springframework.http.HttpStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ApiResponse {
    private String message;
    private int status;
    private Object error;
    private List<String> errors;
    private Object data;

    public static ApiResponse success(String message, HttpStatus status, Object data) {
        return new ApiResponse(message, status.value(), null, null, data);
    }

    public static ApiResponse failure(String message, HttpStatus status, Object error, List<String> errors) {
        return new ApiResponse(message, status.value(), error, errors, null);
    }
}
