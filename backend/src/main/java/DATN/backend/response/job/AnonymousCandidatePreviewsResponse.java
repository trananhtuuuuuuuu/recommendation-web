package DATN.backend.response.job;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class AnonymousCandidatePreviewsResponse {
    private boolean available;
    private String message;
    private List<AnonymousCandidatePreviewProfileResponse> profiles;
}
