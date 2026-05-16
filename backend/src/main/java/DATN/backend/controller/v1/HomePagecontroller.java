package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.response.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/v1/home")
@Tag(name = "Home", description = "Home API")
public class HomePagecontroller {

    @GetMapping
    public ResponseEntity<ApiResponse> home() {
        return ResponseEntity.ok(ApiResponse.success("Home endpoint", HttpStatus.OK,
                "Welcome to recommendation website backend"));
    }

}
