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
public class UpdateRecruiterRequest {

    @NotBlank(message = "Address is required")
    private String address;

    @NotBlank(message = "Email is required")
    private String email;

    @Pattern(regexp = "^$|^\\+[1-9]\\d{1,14}$", message = "Invalid phone number")
    private String phone;

    @NotBlank(message = "User name is required")
    private String userName;

    @NotBlank(message = "Company name is required")
    private String companyName;

    private String taxCode;

    private String establishedDate;

    private String companyDesc;
    private String companyDescription;
    private String location;
    private String companyLocation;
    private String companySize;
    private String industryType;
    private String industry;
    private String contact;
    private String avatarUrl;
    private String website;
    private String logoUrl;
    private String coverImageUrl;
    private String contactEmail;
    private String contactPhone;
    private String businessLicense;
    private String companyType;
}
