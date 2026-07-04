package DATN.backend.request.applicant;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonSetter;

import DATN.backend.utils.StringListConverter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UploadCvRequest {

    private String fullName;

    private String address;
    private String phone;
    private String objective;
    private List<String> skills;
    private String cvFileUrl;
    private MultipartFile cvFile;

    @JsonSetter("skills")
    public void setSkillsFromJson(Object skills) {
        this.skills = StringListConverter.fromAny(skills);
    }
}
