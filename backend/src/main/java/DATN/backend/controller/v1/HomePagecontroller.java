package DATN.backend.controller.v1;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.backend.response.ApiResponse;

@RestController
@RequestMapping("/api/v1/home")
public class HomePagecontroller {

    @GetMapping
    public ResponseEntity<ApiResponse> home() {
        return ResponseEntity.ok(new ApiResponse("Home endpoint", HttpStatus.OK.value(), null, null,
                "Welcome to recommendation website backend"));
    }

}
