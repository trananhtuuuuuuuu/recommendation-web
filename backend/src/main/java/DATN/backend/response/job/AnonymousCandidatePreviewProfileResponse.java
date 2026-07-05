package DATN.backend.response.job;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class AnonymousCandidatePreviewProfileResponse {
    private String anonymousProfileId;
    private String experienceLevel;
    private List<String> skillCategories;
    private String educationLevel;
    private String generalRegion;
    private String currentRoleCategory;
}
