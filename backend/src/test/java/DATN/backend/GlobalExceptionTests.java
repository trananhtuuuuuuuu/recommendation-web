package DATN.backend;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import DATN.backend.exception.GlobalException;
import DATN.backend.response.ApiResponse;

class GlobalExceptionTests {

    @Test
    void dataIntegrityViolationShouldReturnApiResponseConflict() {
        GlobalException exceptionHandler = new GlobalException();

        ResponseEntity<ApiResponse> response = exceptionHandler.handleDataIntegrityViolationException(
                new DataIntegrityViolationException("database constraint details"));

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().getMessage())
                .isEqualTo("Unable to save resource because it conflicts with existing data");
        assertThat(response.getBody().getStatus()).isEqualTo(HttpStatus.CONFLICT.value());
        assertThat(response.getBody().getError())
                .isEqualTo("Unable to save resource because it conflicts with existing data");
        assertThat(response.getBody().getErrors())
                .containsExactly("Unable to save resource because it conflicts with existing data");
        assertThat(response.getBody().getData()).isNull();
    }
}
