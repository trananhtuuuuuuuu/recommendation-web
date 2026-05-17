package DATN.backend.mapper;

import DATN.backend.model.Recruiter;
import DATN.backend.request.recruiter.RegistrationRecruiterRequest;
import DATN.backend.request.recruiter.UpdateRecruiterRequest;
import DATN.backend.response.recruiter.RegistrationRecruiterResponse;
import DATN.backend.response.recruiter.RecruiterResponse;

public class RecruiterMapper {

    private RecruiterMapper() {
    }

    public static Recruiter toNewRecruiter(RegistrationRecruiterRequest request) {
        Recruiter recruiter = new Recruiter();
        recruiter.setAddress(request.getAddress());
        recruiter.setEmail(request.getEmail());
        recruiter.setPassword(request.getPassword());
        recruiter.setPhone(request.getPhone());
        recruiter.setUserName(request.getUserName());
        recruiter.setCompanyName(request.getCompanyName());
        recruiter.setCompanyDescription(request.getCompanyDescription());
        recruiter.setCompanyLocation(request.getCompanyLocation());
        recruiter.setCompanySize(request.getCompanySize());
        recruiter.setIndustry(request.getIndustry());
        recruiter.setWebsite(request.getWebsite());
        recruiter.setLogoUrl(request.getLogoUrl());
        recruiter.setContactEmail(request.getContactEmail());
        recruiter.setContactPhone(request.getContactPhone());
        recruiter.setTaxCode(request.getTaxCode());
        recruiter.setBusinessLicense(request.getBusinessLicense());
        recruiter.setEstablishedDate(request.getEstablishedDate());
        recruiter.setCompanyType(request.getCompanyType());
        return recruiter;
    }

    public static RegistrationRecruiterResponse toRegistrationResponse(Recruiter recruiter) {
        return new RegistrationRecruiterResponse(
                recruiter.getId(),
                recruiter.getUserName(),
                recruiter.getEmail(),
                recruiter.getCompanyName(),
                recruiter.getPhone(),
                recruiter.getAddress(),
                recruiter.getRole() == null ? null : recruiter.getRole().getRoleName());
    }

    public static RecruiterResponse toRecruiterResponse(Recruiter recruiter) {
        return new RecruiterResponse(
                recruiter.getId(),
                recruiter.getUserName(),
                recruiter.getEmail(),
                recruiter.getCompanyName(),
                recruiter.getCompanyDescription(),
                recruiter.getCompanyLocation(),
                recruiter.getCompanySize(),
                recruiter.getIndustry(),
                recruiter.getWebsite(),
                recruiter.getLogoUrl(),
                recruiter.getContactEmail(),
                recruiter.getContactPhone(),
                recruiter.getTaxCode(),
                recruiter.getBusinessLicense(),
                recruiter.getEstablishedDate(),
                recruiter.getCompanyType(),
                recruiter.getAddress(),
                recruiter.getPhone());
    }

    public static Recruiter updateRecruiter(Recruiter recruiter, UpdateRecruiterRequest request) {
        recruiter.setAddress(request.getAddress());
        recruiter.setEmail(request.getEmail());
        recruiter.setPhone(request.getPhone());
        recruiter.setUserName(request.getUserName());
        recruiter.setCompanyName(request.getCompanyName());
        recruiter.setCompanyDescription(request.getCompanyDescription());
        recruiter.setCompanyLocation(request.getCompanyLocation());
        recruiter.setCompanySize(request.getCompanySize());
        recruiter.setIndustry(request.getIndustry());
        recruiter.setWebsite(request.getWebsite());
        recruiter.setLogoUrl(request.getLogoUrl());
        recruiter.setContactEmail(request.getContactEmail());
        recruiter.setContactPhone(request.getContactPhone());
        recruiter.setTaxCode(request.getTaxCode());
        recruiter.setBusinessLicense(request.getBusinessLicense());
        recruiter.setEstablishedDate(request.getEstablishedDate());
        recruiter.setCompanyType(request.getCompanyType());
        return recruiter;
    }
}
