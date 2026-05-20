package DATN.backend.response.cv;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CvResponse {
    private Long id;
    private String fullName;
    private String address;
    private String phone;
    private String objective;
    private String skills;
    private String experience;
    private String education;
    private String certifications;
    private String cvFileUrl;
}