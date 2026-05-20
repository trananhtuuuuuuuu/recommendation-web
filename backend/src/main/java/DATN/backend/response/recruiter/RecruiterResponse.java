package DATN.backend.response.recruiter;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RecruiterResponse {
    private Long id;
    private String userName;
    private String email;
    private String companyName;
    private String companyDescription;
    private String companyLocation;
    private String companySize;
    private String industry;
    private String website;
    private String logoUrl;
    private String coverImageUrl;
    private String contactEmail;
    private String contactPhone;
    private String taxCode;
    private String businessLicense;
    private String establishedDate;
    private String companyType;
    private String address;
    private String phone;
}