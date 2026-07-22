package DATN.backend.request.recruiter;

import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Multipart request used to upload a recruiter company logo or cover image.
 */
@Getter
@Setter
@NoArgsConstructor
public class UploadRecruiterImageRequest {

    @NotNull(message = "Image file is required")
    private MultipartFile image;
}
