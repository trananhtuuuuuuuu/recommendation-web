package DATN.backend.controller.v1;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.response.ApiResponse;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.JobDescriptionRepository;
import DATN.backend.repository.RecruiterRepository;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/home")
@Tag(name = "Home", description = "Home API")
@RequiredArgsConstructor
public class HomePagecontroller {

    private final JobDescriptionRepository jobDescriptionRepository;
    private final ApplicantRepository applicantRepository;
    private final RecruiterRepository recruiterRepository;

    @GetMapping
    public ResponseEntity<ApiResponse> home() {
        return ResponseEntity.ok(ApiResponse.success("Home endpoint", HttpStatus.OK,
                Map.of(
                        "welcome", "Welcome to recommendation website backend",
                        "jobsPosted", jobDescriptionRepository.count(),
                        "activeApplicants", applicantRepository.count(),
                        "recruiters", recruiterRepository.count())));
    }

}
