package DATN.backend.request.applicant;

import java.sql.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.annotation.JsonSetter;

import DATN.backend.Enum.DegreeEnum;
import DATN.backend.model.Certificate;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
import DATN.backend.utils.StringListConverter;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
public class UploadCvRequest {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private String fullName;

    private String address;

    @Size(max = 50, message = "Phone number must not exceed 50 characters")
    @Pattern(
        regexp = "^$|^(?=(?:\\D*\\d){7,15}\\D*$)(?:[A-Za-z]{2,3}\\s+)?[+()\\d][+()\\d\\s.-]*$",
        message = "Invalid phone number")
    private String phone;
    private String objective;
    private Object skills;
    private Experience experience;
    private Education education;
    private Certificate certifications;
    private String cvFileUrl;
    private MultipartFile cvFile;

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setObjective(String objective) {
        this.objective = objective;
    }

    public void setSkills(Object skills) {
        this.skills = skills;
    }

    @JsonSetter("experience")
    public void setExperience(Object experience) {
        this.experience = toExperience(experience);
    }

    @JsonSetter("education")
    public void setEducation(Object education) {
        this.education = toEducation(education);
    }

    @JsonSetter("certifications")
    public void setCertifications(Object certifications) {
        this.certifications = toCertificate(certifications);
    }

    public void setCvFileUrl(String cvFileUrl) {
        this.cvFileUrl = cvFileUrl;
    }

    public void setCvFile(MultipartFile cvFile) {
        this.cvFile = cvFile;
    }

    public String getFullName() {
        return fullName;
    }

    public String getAddress() {
        return address;
    }

    public String getPhone() {
        return phone;
    }

    public String getObjective() {
        return objective;
    }

    public List<String> getSkills() {
        return StringListConverter.fromAny(skills);
    }

    public Experience getExperience() {
        return experience;
    }

    public Education getEducation() {
        return education;
    }

    public Certificate getCertifications() {
        return certifications;
    }

    public String getCvFileUrl() {
        return cvFileUrl;
    }

    public MultipartFile getCvFile() {
        return cvFile;
    }

    public static Experience parseExperience(Object value) {
        return toExperience(value);
    }

    public static Education parseEducation(Object value) {
        return toEducation(value);
    }

    public static Certificate parseCertificate(Object value) {
        return toCertificate(value);
    }

    private static Experience toExperience(Object value) {
        if (value instanceof Experience experience) {
            return experience;
        }
        Experience structuredExperience = toExperience(toNode(value), null);
        if (structuredExperience != null) {
            return structuredExperience;
        }

        String normalizedValue = normalize(value);
        if (normalizedValue == null) {
            return null;
        }

        try {
            Experience parsedExperience = toExperience(OBJECT_MAPPER.readTree(normalizedValue), normalizedValue);
            if (parsedExperience != null) {
                return parsedExperience;
            }
        } catch (Exception exception) {
            // Legacy plain text is handled below.
        }

        Experience experience = new Experience();
        experience.setCompanyName("Experience");
        experience.setContribution(normalizedValue);
        experience.setIsPresent(false);
        return experience;
    }

    private static Education toEducation(Object value) {
        if (value instanceof Education education) {
            return education;
        }
        Education structuredEducation = toEducation(toNode(value), null);
        if (structuredEducation != null) {
            return structuredEducation;
        }

        String normalizedValue = normalize(value);
        if (normalizedValue == null) {
            return null;
        }

        try {
            Education parsedEducation = toEducation(OBJECT_MAPPER.readTree(normalizedValue), normalizedValue);
            if (parsedEducation != null) {
                return parsedEducation;
            }
        } catch (Exception exception) {
            // Legacy plain text is handled below.
        }

        Education education = new Education();
        education.setName(normalizedValue);
        return education;
    }

    private static Certificate toCertificate(Object value) {
        if (value instanceof Certificate certificate) {
            return certificate;
        }
        Certificate structuredCertificate = toCertificate(toNode(value), null);
        if (structuredCertificate != null) {
            return structuredCertificate;
        }

        String normalizedValue = normalize(value);
        if (normalizedValue == null) {
            return null;
        }

        try {
            Certificate parsedCertificate = toCertificate(OBJECT_MAPPER.readTree(normalizedValue), normalizedValue);
            if (parsedCertificate != null) {
                return parsedCertificate;
            }
        } catch (Exception exception) {
            // Legacy plain text is handled below.
        }

        Certificate certificate = new Certificate();
        certificate.setName(normalizedValue);
        return certificate;
    }

    private static Experience toExperience(JsonNode node, String fallbackValue) {
        if (node == null) {
            return null;
        }
        JsonNode source = node.isArray() ? firstObject(node) : node;
        if (source == null || !source.isObject()) {
            return null;
        }

        Experience experience = new Experience();
        experience.setCompanyName(defaultText(readText(source, "companyName"), "Experience"));
        experience.setJobTitle(firstText(source, "jobTitle", "position"));
        experience.setField(firstText(source, "field", "skills"));
        experience.setContribution(firstText(source, "contribution", "description"));
        experience.setStartDate(readDate(source, "startDate"));
        experience.setEndDate(readDate(source, "endDate"));
        experience.setIsPresent(readBoolean(source, "isPresent"));
        if (node.isArray()) {
            experience.setContribution(fallbackValue == null ? node.toString() : fallbackValue);
        }
        return experience;
    }

    private static Education toEducation(JsonNode node, String fallbackValue) {
        if (node == null) {
            return null;
        }
        JsonNode source = node.isArray() ? firstObject(node) : node;
        if (source == null || !source.isObject()) {
            return null;
        }

        Education education = new Education();
        education.setName(defaultText(readText(source, "name"), fallbackValue == null ? "Education" : fallbackValue));
        education.setMajor(readText(source, "major"));
        education.setDegree(readDegree(source));
        education.setStartDate(readDate(source, "startDate"));
        education.setEndDate(readDate(source, "endDate"));
        return education;
    }

    private static Certificate toCertificate(JsonNode node, String fallbackValue) {
        if (node == null) {
            return null;
        }
        JsonNode source = node.isArray() ? firstObject(node) : node;
        if (source == null || !source.isObject()) {
            return null;
        }

        Certificate certificate = new Certificate();
        certificate.setName(defaultText(readText(source, "name"), fallbackValue == null ? "Certificate" : fallbackValue));
        certificate.setProvider(readText(source, "provider"));
        certificate.setScore(readText(source, "score"));
        return certificate;
    }

    private static JsonNode toNode(Object value) {
        if (value == null || value instanceof String || value instanceof String[]) {
            return null;
        }
        if (value instanceof JsonNode node) {
            return node;
        }
        return OBJECT_MAPPER.valueToTree(value);
    }

    private static JsonNode firstObject(JsonNode node) {
        for (JsonNode item : node) {
            if (item.isObject()) {
                return item;
            }
        }
        return null;
    }

    private static String firstText(JsonNode node, String firstField, String secondField) {
        String value = readText(node, firstField);
        return value == null ? readText(node, secondField) : value;
    }

    private static String readText(JsonNode node, String fieldName) {
        JsonNode value = node.get(fieldName);
        if (value == null || value.isNull()) {
            return null;
        }
        if (value.isArray()) {
            return StringListConverter.join(StringListConverter.fromAny(value));
        }
        String text = value.asText();
        return text == null || text.isBlank() ? null : text.trim();
    }

    private static Date readDate(JsonNode node, String fieldName) {
        String value = readText(node, fieldName);
        if (value == null) {
            return null;
        }
        try {
            return Date.valueOf(value);
        } catch (IllegalArgumentException exception) {
            return null;
        }
    }

    private static Boolean readBoolean(JsonNode node, String fieldName) {
        JsonNode value = node.get(fieldName);
        if (value == null || value.isNull()) {
            return false;
        }
        return value.asBoolean(false);
    }

    private static DegreeEnum readDegree(JsonNode node) {
        String value = readText(node, "degree");
        if (value == null) {
            return null;
        }
        try {
            return DegreeEnum.valueOf(value);
        } catch (IllegalArgumentException exception) {
            return DegreeEnum.Other;
        }
    }

    private static String normalize(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof String[] array) {
            return array.length == 0 ? null : normalize(array[0]);
        }
        String normalizedValue = value.toString();
        return normalizedValue == null || normalizedValue.isBlank() ? null : normalizedValue.trim();
    }

    private static String defaultText(String value, String defaultValue) {
        return value == null || value.isBlank() ? defaultValue : value;
    }
}
