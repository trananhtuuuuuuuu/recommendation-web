package DATN.backend.mapper;

import java.sql.Date;
import java.time.LocalDate;

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
        recruiter.setCompanyDesc(firstNonBlank(request.getCompanyDesc(), request.getCompanyDescription()));
        recruiter.setLocation(firstNonBlank(request.getLocation(), request.getCompanyLocation(), request.getAddress()));
        recruiter.setCompanySize(parseInteger(request.getCompanySize()));
        recruiter.setIndustryType(firstNonBlank(request.getIndustryType(), request.getIndustry()));
        recruiter.setContact(firstNonBlank(request.getContact(), request.getContactEmail(), request.getContactPhone()));
        recruiter.setWebsite(request.getWebsite());
        recruiter.setContactEmail(request.getContactEmail());
        recruiter.setContactPhone(request.getContactPhone());
        recruiter.setTaxCode(request.getTaxCode());
        recruiter.setBusinessLicense(request.getBusinessLicense());
        recruiter.setCompanyType(request.getCompanyType());
        recruiter.setAvatarUrl(firstNonBlank(request.getAvatarUrl(), request.getLogoUrl()));
        recruiter.setLogoUrl(firstNonBlank(request.getLogoUrl(), request.getAvatarUrl()));
        recruiter.setCoverImageUrl(request.getCoverImageUrl());
        recruiter.setEstablishedDate(parseDate(request.getEstablishedDate()));
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
                recruiter.getCompanyDesc(),
                recruiter.getLocation(),
                recruiter.getCompanySize() == null ? null : recruiter.getCompanySize().toString(),
                recruiter.getIndustryType(),
                recruiter.getWebsite(),
                firstNonBlank(recruiter.getLogoUrl(), recruiter.getAvatarUrl()),
                recruiter.getCoverImageUrl(),
                firstNonBlank(recruiter.getContactEmail(), recruiter.getContact()),
                firstNonBlank(recruiter.getContactPhone(), recruiter.getPhone()),
                recruiter.getTaxCode(),
                recruiter.getBusinessLicense(),
                recruiter.getEstablishedDate() == null ? null : recruiter.getEstablishedDate().toString(),
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
        recruiter.setCompanyDesc(firstNonBlank(request.getCompanyDesc(), request.getCompanyDescription()));
        recruiter.setLocation(firstNonBlank(request.getLocation(), request.getCompanyLocation(), request.getAddress()));
        recruiter.setCompanySize(parseInteger(request.getCompanySize()));
        recruiter.setIndustryType(firstNonBlank(request.getIndustryType(), request.getIndustry()));
        recruiter.setContact(firstNonBlank(request.getContact(), request.getContactEmail(), request.getContactPhone()));
        recruiter.setWebsite(request.getWebsite());
        recruiter.setContactEmail(request.getContactEmail());
        recruiter.setContactPhone(request.getContactPhone());
        recruiter.setTaxCode(request.getTaxCode());
        recruiter.setBusinessLicense(request.getBusinessLicense());
        recruiter.setCompanyType(request.getCompanyType());
        recruiter.setAvatarUrl(firstNonBlank(request.getAvatarUrl(), request.getLogoUrl()));
        recruiter.setLogoUrl(firstNonBlank(request.getLogoUrl(), request.getAvatarUrl()));
        recruiter.setCoverImageUrl(firstNonBlank(request.getCoverImageUrl()));
        recruiter.setEstablishedDate(parseDate(request.getEstablishedDate()));
        return recruiter;
    }

    private static String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    private static Integer parseInteger(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private static Date parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return Date.valueOf(LocalDate.parse(value));
    }
}
