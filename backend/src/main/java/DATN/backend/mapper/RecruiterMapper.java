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
        recruiter.setAvatarUrl(firstNonBlank(request.getAvatarUrl(), request.getLogoUrl(), request.getCoverImageUrl()));
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
                null,
                recruiter.getAvatarUrl(),
                recruiter.getAvatarUrl(),
                recruiter.getContact(),
                recruiter.getPhone(),
                null,
                null,
                recruiter.getEstablishedDate() == null ? null : recruiter.getEstablishedDate().toString(),
                null,
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
        recruiter.setAvatarUrl(firstNonBlank(request.getAvatarUrl(), request.getLogoUrl(), request.getCoverImageUrl()));
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
