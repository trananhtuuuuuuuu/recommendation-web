package DATN.backend.response.cv;

import java.util.List;

import DATN.backend.model.Certificate;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
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
    private List<String> skills;
    private Experience experience;
    private Education education;
    private Certificate certifications;
    private String cvFileUrl;
}
