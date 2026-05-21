package DATN.backend.request.applicant;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UploadCvRequest {

    private String fullName;

    private String address;
    private String phone;
    private String objective;
    private String skills;
    private String experience;
    private String education;
    private String certifications;
    private String cvFileUrl;
    private MultipartFile cvFile;
}
