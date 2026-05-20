package DATN.backend.request.recruiter;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RegistrationRecruiterRequest {

    @NotBlank(message = "Address is required")
    private String address;

    @NotBlank(message = "Email is required")
    private String email;

    @NotBlank(message = "Password is required")
    private String password;

    @Pattern(regexp = "^$|^\\+[1-9]\\d{1,14}$", message = "Invalid phone number")
    private String phone;

    @NotBlank(message = "User name is required")
    private String userName;

    @NotBlank(message = "Company name is required")
    private String companyName;

    @NotBlank(message = "Tax code is required")
    private String taxCode;

    @NotBlank(message = "Established date is required")
    private String establishedDate;

    private String companyDescription;
    private String companyLocation;
    private String companySize;
    private String industry;
    private String website;
    private String logoUrl;
    private String coverImageUrl;
    private String contactEmail;
    private String contactPhone;
    private String businessLicense;
    private String companyType;

    private String roleName = "RECRUITER";
}