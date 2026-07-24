package DATN.backend;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;

import java.sql.Date;
import java.time.LocalDate;
import java.nio.file.Files;
import java.nio.file.Path;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.http.HttpHeaders;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestConstructor;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.mock.web.MockMultipartFile;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.Enum.GenderEnum;
import DATN.backend.model.Applicant;
import DATN.backend.model.ApplicantJob;
import DATN.backend.model.Cv;
import DATN.backend.model.Education;
import DATN.backend.model.Experience;
import DATN.backend.model.Job;
import DATN.backend.model.Recruiter;
import DATN.backend.model.Role;
import DATN.backend.repository.ApplicantJobRepository;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.CvRepository;
import DATN.backend.repository.EducationRepository;
import DATN.backend.repository.ExperienceRepository;
import DATN.backend.repository.JobRepository;
import DATN.backend.repository.PrivacyReleaseRepository;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.repository.RoleRepository;
import DATN.backend.repository.UserRepository;
import DATN.backend.security.InforInsideToken;
import DATN.backend.security.JwtService;
import DATN.backend.response.cv.CvAnalysisResponse;
import DATN.backend.response.cv.CvExperienceResponse;
import DATN.backend.response.applicant.CvJobMatchResponse;
import DATN.backend.service.InterfaceService.InterfaceCvAiService;
import DATN.backend.service.InterfaceService.InterfaceCvMatchService;

@SpringBootTest
@AutoConfiguration
@TestConstructor(autowireMode = TestConstructor.AutowireMode.ALL)
class BackendEndpointsIntegrationTests {

  private final MockMvc mockMvc;
  private final UserRepository userRepository;
  private final ApplicantRepository applicantRepository;
  private final ApplicantJobRepository applicantJobRepository;
  private final CvRepository cvRepository;
  private final ExperienceRepository experienceRepository;
  private final EducationRepository educationRepository;
  private final RecruiterRepository recruiterRepository;
  private final RoleRepository roleRepository;
  private final JobRepository jobDescriptionRepository;
  private final PrivacyReleaseRepository privacyReleaseRepository;
  private final PasswordEncoder passwordEncoder;
  private final JwtService jwtService;

  @MockitoBean
  private InterfaceCvAiService cvAiService;

  @MockitoBean
  private InterfaceCvMatchService cvMatchService;

  BackendEndpointsIntegrationTests(WebApplicationContext webApplicationContext, UserRepository userRepository,
      ApplicantRepository applicantRepository,
      ApplicantJobRepository applicantJobRepository, CvRepository cvRepository,
      ExperienceRepository experienceRepository, EducationRepository educationRepository,
      RecruiterRepository recruiterRepository, RoleRepository roleRepository,
      PrivacyReleaseRepository privacyReleaseRepository,
      JobRepository jobDescriptionRepository, PasswordEncoder passwordEncoder,
      JwtService jwtService) {
    this.mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext)
        .apply(springSecurity())
        .build();
    this.userRepository = userRepository;
    this.applicantRepository = applicantRepository;
    this.applicantJobRepository = applicantJobRepository;
    this.cvRepository = cvRepository;
    this.experienceRepository = experienceRepository;
    this.educationRepository = educationRepository;
    this.recruiterRepository = recruiterRepository;
    this.roleRepository = roleRepository;
    this.privacyReleaseRepository = privacyReleaseRepository;
    this.jobDescriptionRepository = jobDescriptionRepository;
    this.passwordEncoder = passwordEncoder;
    this.jwtService = jwtService;
  }

  @BeforeEach
  void cleanDatabase() {
    applicantJobRepository.deleteAll();
    privacyReleaseRepository.deleteAll();
    jobDescriptionRepository.deleteAll();
    applicantRepository.deleteAll();
    recruiterRepository.deleteAll();
    userRepository.deleteAll();
    cvRepository.deleteAll();
    educationRepository.deleteAll();
    experienceRepository.deleteAll();
    roleRepository.deleteAll();
  }

  @Test
  void homeEndpointShouldBeAccessible() throws Exception {
    mockMvc.perform(get("/api/v1/home"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("Home endpoint"));
  }

  @Test
  void applicantRegistrationShouldCreateApplicant() throws Exception {
    mockMvc.perform(post("/api/v1/registrations/applicant")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "address": "Hanoi",
              "email": "applicant@example.com",
              "password": "secret123",
              "phone": "0787549324",
              "userName": "applicant01",
              "fullName": "Applicant One"
            }
            """))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.userName").value("applicant01"))
        .andExpect(jsonPath("$.data.email").value("applicant@example.com"));
  }

  @Test
  void applicantRegistrationShouldOnlyRequireUserNameAndPassword() throws Exception {
    mockMvc.perform(post("/api/v1/registrations/applicant")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "userName": "minimalapplicant",
              "password": "secret123"
            }
            """))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.userName").value("minimalapplicant"))
        .andExpect(jsonPath("$.data.email").doesNotExist())
        .andExpect(jsonPath("$.data.fullName").doesNotExist())
        .andExpect(jsonPath("$.data.roleName").value("APPLICANT"));
  }

  @Test
  void applicantRegistrationValidationShouldReturnErrorsArray() throws Exception {
    mockMvc.perform(post("/api/v1/registrations/applicant")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "email": "",
              "password": "",
              "userName": ""
            }
            """))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.message").value("Validation failed"))
        .andExpect(jsonPath("$.errors").isArray());
  }

  @Test
  void loginShouldReturnTokenAfterApplicantRegistration() throws Exception {
    mockMvc.perform(post("/api/v1/registrations/applicant")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "address": "Hanoi",
              "email": "login@example.com",
              "password": "secret123",
              "phone": "0787549324",
              "userName": "loginuser",
              "fullName": "Login User"
            }
            """))
        .andExpect(status().isCreated());

    mockMvc.perform(post("/api/v1/auth")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "userName": "loginuser",
              "password": "secret123"
            }
            """))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.token").isNotEmpty())
        .andExpect(jsonPath("$.data.roleName").value("APPLICANT"));
  }

  @Test
  void recruiterRegistrationShouldCreateRecruiter() throws Exception {
    mockMvc.perform(post("/api/v1/registrations/recruiters")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "address": "Hanoi",
              "email": "recruiter-register@example.com",
              "password": "secret123",
              "phone": "+84909998888",
              "userName": "recruiterregister",
              "companyName": "Register Corp",
              "taxCode": "TAX-REGISTER",
              "establishedDate": "2020-01-01"
            }
            """))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.userName").value("recruiterregister"))
        .andExpect(jsonPath("$.data.companyName").value("Register Corp"));
  }

  @Test
  void applicantUpdateShouldAcceptCommonPhoneNumberFormats() throws Exception {
    Applicant applicant = seedApplicant("phone-formats", "phone-formats@example.com");
    String[] acceptedPhoneNumbers = {
        "0901234567",
        "090-123-4567",
        "+84 90 123 4567",
        "(+84) 90.123.4567",
        "(028) 3822-1234",
        "VN (+84) 90-123-4567"
    };

    for (String phoneNumber : acceptedPhoneNumbers) {
      mockMvc.perform(put("/api/v1/applicants/{applicantId}", applicant.getId())
          .contentType(MediaType.APPLICATION_JSON)
          .content("""
              {
                "phone": "%s"
              }
              """.formatted(phoneNumber)))
          .andExpect(status().isOk())
          .andExpect(jsonPath("$.data.phone").value(phoneNumber));
    }

    mockMvc.perform(put("/api/v1/applicants/{applicantId}", applicant.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "phone": "0916044262Thu"
            }
            """))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.message").value("Validation failed"))
        .andExpect(jsonPath("$.errors").value(org.hamcrest.Matchers.hasItem("Invalid phone number")));

    String overlongPhoneNumber = "1".repeat(51);
    mockMvc.perform(put("/api/v1/applicants/{applicantId}", applicant.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content(
            """
            {
              "phone": "%s"
            }
            """.formatted(overlongPhoneNumber)))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.message").value("Validation failed"))
        .andExpect(jsonPath("$.errors")
            .value(org.hamcrest.Matchers.hasItem("Phone number must not exceed 50 characters")));

    MockMultipartFile cvFile = new MockMultipartFile(
        "cvFile",
        "formatted-phone-cv.pdf",
        MediaType.APPLICATION_PDF_VALUE,
        "sample cv".getBytes());

    mockMvc.perform(multipart("/api/v1/applicants/upload-cv/{applicantId}", applicant.getId())
        .file(cvFile)
        .param("phone", "0916044262Thu"))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.message").value("Validation failed"))
        .andExpect(jsonPath("$.errors").value(org.hamcrest.Matchers.hasItem("Invalid phone number")));

    mockMvc.perform(multipart("/api/v1/applicants/upload-cv/{applicantId}", applicant.getId())
        .file(cvFile)
        .param("fullName", "Applicant One")
        .param("address", "Ho Chi Minh City")
        .param("phone", "VN (+84) 90-123-4567")
        .param("objective", "")
        .param("skills", "")
        .param("experience", "")
        .param("education", "")
        .param("certifications", "")
        .param("cvFileUrl", ""))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.phone").value("VN (+84) 90-123-4567"))
        .andExpect(jsonPath("$.data.cvFileUrl").isNotEmpty());

    mockMvc.perform(delete("/api/v1/applicants/{applicantId}/cv-file", applicant.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant)))
        .andExpect(status().isOk());
  }

  @Test
  void profileUpdatesShouldPersistExplicitlyEmptyFields() throws Exception {
    Applicant applicant = seedApplicant("clearable-applicant", "clearable-applicant@example.com");
    String applicantPassword = applicant.getPassword();
    Cv cv = seedCv("Java, Spring Boot", "2024-2025");
    cv.setFullName("Applicant CV");
    cv.setPhone("+84901234567");
    cv.setObjective("Backend developer");
    applicant.setCv(cv);
    applicantRepository.save(applicant);

    mockMvc.perform(put("/api/v1/applicants/{applicantId}", applicant.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "address": "",
              "email": "",
              "phone": "",
              "userName": "",
              "fullName": "",
              "gender": "",
              "status": ""
            }
            """))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.address").value(""))
        .andExpect(jsonPath("$.data.email").value(""))
        .andExpect(jsonPath("$.data.phone").value(""))
        .andExpect(jsonPath("$.data.userName").value("clearable-applicant"))
        .andExpect(jsonPath("$.data.fullName").value(""))
        .andExpect(jsonPath("$.data.gender").doesNotExist())
        .andExpect(jsonPath("$.data.status").doesNotExist());

    Applicant clearedApplicant = applicantRepository.findById(applicant.getId()).orElseThrow();
    org.assertj.core.api.Assertions.assertThat(clearedApplicant.getEmail()).isEmpty();
    org.assertj.core.api.Assertions.assertThat(clearedApplicant.getUserName()).isEqualTo("clearable-applicant");
    org.assertj.core.api.Assertions.assertThat(clearedApplicant.getPassword()).isEqualTo(applicantPassword);
    org.assertj.core.api.Assertions.assertThat(clearedApplicant.getFullName()).isEmpty();
    org.assertj.core.api.Assertions.assertThat(clearedApplicant.getGender()).isNull();
    org.assertj.core.api.Assertions.assertThat(clearedApplicant.getStatus()).isNull();

    mockMvc.perform(multipart("/api/v1/applicants/upload-cv/{applicantId}", applicant.getId())
        .param("fullName", "")
        .param("address", "")
        .param("phone", "")
        .param("objective", "")
        .param("skills", "")
        .param("experience", "")
        .param("education", "")
        .param("certifications", "")
        .param("cvFileUrl", ""))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.fullName").value(""))
        .andExpect(jsonPath("$.data.address").value(""))
        .andExpect(jsonPath("$.data.phone").value(""))
        .andExpect(jsonPath("$.data.objective").value(""))
        .andExpect(jsonPath("$.data.experience").doesNotExist())
        .andExpect(jsonPath("$.data.education").doesNotExist())
        .andExpect(jsonPath("$.data.certifications").doesNotExist());

    Cv clearedCv = applicantRepository.findById(applicant.getId()).orElseThrow().getCv();
    org.assertj.core.api.Assertions.assertThat(clearedCv.getFullName()).isEmpty();
    org.assertj.core.api.Assertions.assertThat(clearedCv.getAddress()).isEmpty();
    org.assertj.core.api.Assertions.assertThat(clearedCv.getPhone()).isEmpty();
    org.assertj.core.api.Assertions.assertThat(clearedCv.getObjective()).isEmpty();
    org.assertj.core.api.Assertions.assertThat(clearedCv.getSkills()).isEmpty();
    org.assertj.core.api.Assertions.assertThat(clearedCv.getExperienceObj()).isNull();
    org.assertj.core.api.Assertions.assertThat(clearedCv.getEducationObj()).isNull();

    Recruiter recruiter = seedRecruiter("clearable-recruiter", "clearable-recruiter@example.com");
    String recruiterPassword = recruiter.getPassword();
    mockMvc.perform(put("/api/v1/recruiters/{recruiterId}", recruiter.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "address": "",
              "email": "",
              "phone": "",
              "userName": "",
              "companyName": "",
              "companyDescription": "",
              "companyLocation": "",
              "companySize": "",
              "industry": "",
              "website": "",
              "contactEmail": "",
              "contactPhone": "",
              "taxCode": "",
              "businessLicense": "",
              "establishedDate": "",
              "companyType": ""
            }
            """))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.email").value(""))
        .andExpect(jsonPath("$.data.userName").value("clearable-recruiter"))
        .andExpect(jsonPath("$.data.companyName").value(""))
        .andExpect(jsonPath("$.data.companyDescription").value(""))
        .andExpect(jsonPath("$.data.companyLocation").value(""))
        .andExpect(jsonPath("$.data.contactEmail").value(""))
        .andExpect(jsonPath("$.data.contactPhone").value(""));

    Recruiter clearedRecruiter = recruiterRepository.findById(recruiter.getId()).orElseThrow();
    org.assertj.core.api.Assertions.assertThat(clearedRecruiter.getUserName()).isEqualTo("clearable-recruiter");
    org.assertj.core.api.Assertions.assertThat(clearedRecruiter.getPassword()).isEqualTo(recruiterPassword);
  }

  @Test
  void applicantEndpointsShouldReadUpdateSaveJobAndUploadCv() throws Exception {
    Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
    Job job = seedJob(recruiter, "Backend Engineer");

    mockMvc.perform(get("/api/v1/applicants"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data[0].userName").doesNotExist())
        .andExpect(jsonPath("$.data[0].privacyApplied").doesNotExist());

    mockMvc.perform(get("/api/v1/applicants/{applicantId}", applicant.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.email").doesNotExist())
        .andExpect(jsonPath("$.data.fullName").value("Candidate"));

    mockMvc.perform(get("/api/v1/applicants/{applicantId}", applicant.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.email").value("applicant@example.com"))
        .andExpect(jsonPath("$.data.userName").value("applicant01"));

    mockMvc.perform(put("/api/v1/applicants/{applicantId}", applicant.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "address": "Da Nang",
              "email": "updated-applicant@example.com",
              "phone": "0787549324",
              "userName": "updatedapplicant",
              "fullName": "",
              "gender": "Female",
              "status": "Normal"
            }
            """))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.userName").value("applicant01"))
        .andExpect(jsonPath("$.data.fullName").value(""))
        .andExpect(jsonPath("$.data.phone").value("0787549324"))
        .andExpect(jsonPath("$.data.address").value("Da Nang"))
        .andExpect(jsonPath("$.data.status").value("Normal"));

    mockMvc.perform(get("/api/v1/applicants/{applicantId}", applicant.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.fullName").value("Candidate"))
        .andExpect(jsonPath("$.data.email").doesNotExist())
        .andExpect(jsonPath("$.data.phone").doesNotExist());

    mockMvc.perform(get("/api/v1/applicants/{applicantId}", applicant.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(recruiter)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.userName").doesNotExist())
        .andExpect(jsonPath("$.data.password").doesNotExist())
        .andExpect(jsonPath("$.data.fullName").value(""))
        .andExpect(jsonPath("$.data.email").value("updated-applicant@example.com"))
        .andExpect(jsonPath("$.data.phone").value("0787549324"))
        .andExpect(jsonPath("$.data.address").value("Da Nang"));

    mockMvc.perform(post("/api/v1/applicants/save/job")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "applicantId": %d,
              "jobDescriptionId": %d,
              "coverLetter": "I can help this team",
              "portfolioUrl": "https://portfolio.example.com",
              "applicationAnswers": "{\\"years_in_role\\":\\"3\\",\\"english_level\\":\\"Advanced\\"}"
            }
            """
            .formatted(applicant.getId(), job.getId())))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.jobTitle").value("Backend Engineer"));

    mockMvc.perform(post("/api/v1/applicants/apply/job")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "applicantId": %d,
              "jobDescriptionId": %d
            }
            """.formatted(applicant.getId(), job.getId())))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.jobTitle").value("Backend Engineer"));

    mockMvc.perform(get("/api/v1/applicants/saved-jobs").param("applicantId", applicant.getId().toString()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.content[0].jobDescriptionId").value(job.getId()))
        .andExpect(jsonPath("$.data.content[0].jobType").value("Full-time"))
        .andExpect(jsonPath("$.data.content[0].status").value("SAVED"))
        .andExpect(jsonPath("$.data.page").value(0))
        .andExpect(jsonPath("$.data.size").value(5))
        .andExpect(jsonPath("$.data.totalElements").value(1))
        .andExpect(jsonPath("$.data.totalPages").value(1))
        .andExpect(jsonPath("$.data.first").value(true))
        .andExpect(jsonPath("$.data.last").value(true));

    mockMvc.perform(get("/api/v1/applicants/applied-jobs").param("applicantId",
        applicant.getId().toString()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.content[0].jobDescriptionId").value(job.getId()))
        .andExpect(jsonPath("$.data.content[0].status").value("APPLIED"))
        .andExpect(jsonPath("$.data.page").value(0))
        .andExpect(jsonPath("$.data.totalElements").value(1));

    mockMvc.perform(post("/api/v1/applicants/upload-cv/{applicantId}", applicant.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content(
            """
                {
                  "fullName": "",
                  "address": "Da Nang",
                  "phone": "+84901234567",
                  "objective": "Build good software",
                                                                                                "skills": "Java, Spring Boot",
                                                                                                "experience": {
                                                                                                  "companyName": "Acme",
                                                                                                  "jobTitle": "Backend Intern",
                                                                                                  "field": "Java",
                                                                                                  "contribution": "Built APIs",
                                                                                                  "isPresent": false
                                                                                                },
                                                                                                 "education": {
                                                                                                  "name": "HCMUS - Computer Science",
                                                                                                  "major": "Computer Science",
                                                                                                  "degree": "BSc"
                                                                                                 },
                                                                                                 "certifications": {
                                                                                                  "name": "AWS Cloud Practitioner",
                                                                                                  "provider": "AWS"
                                                                                                 },
                                                                                                "cvFileUrl": "https://example.com/cv/updated-applicant.pdf"
                }
                """))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.fullName").value(""))
        .andExpect(jsonPath("$.data.skills[0]").value("Java"))
        .andExpect(jsonPath("$.data.skills[1]").value("Spring Boot"))
        .andExpect(jsonPath("$.data.experience.companyName").value("Acme"))
        .andExpect(jsonPath("$.data.experience.jobTitle").value("Backend Intern"))
        .andExpect(jsonPath("$.data.experience.field").value("Java"))
        .andExpect(jsonPath("$.data.experience.contribution").value("Built APIs"))
        .andExpect(jsonPath("$.data.education.name").value("HCMUS - Computer Science"))
        .andExpect(jsonPath("$.data.education.major").value("Computer Science"))
        .andExpect(jsonPath("$.data.education.degree").value("BSc"))
        .andExpect(jsonPath("$.data.certifications.name").value("AWS Cloud Practitioner"))
        .andExpect(jsonPath("$.data.certifications.provider").value("AWS"))
        .andExpect(jsonPath("$.data.cvFileUrl")
            .value("https://example.com/cv/updated-applicant.pdf"));

    mockMvc.perform(multipart("/api/v1/applicants/upload-cv/{applicantId}", applicant.getId())
        .param("fullName", "Applicant One")
        .param("address", "Ho Chi Minh City")
        .param("phone", "+84987654321")
        .param("objective", "Build reliable products")
        .param("skills", "React\nTypeScript\nSpring Boot")
        .param("experience",
            "{\"companyName\":\"CloudBridge\",\"jobTitle\":\"Frontend Engineer\",\"field\":\"React\",\"contribution\":\"Improved profile editing\",\"isPresent\":false}")
        .param("education",
            "{\"name\":\"HCMUS - Software Engineering\",\"major\":\"Software Engineering\",\"degree\":\"BSc\"}")
        .param("certifications", "{\"name\":\"AWS Cloud Practitioner\",\"provider\":\"AWS\"}"))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.skills[0]").value("React"))
        .andExpect(jsonPath("$.data.skills[1]").value("TypeScript"))
        .andExpect(jsonPath("$.data.skills[2]").value("Spring Boot"))
        .andExpect(jsonPath("$.data.experience.companyName").value("CloudBridge"))
        .andExpect(jsonPath("$.data.experience.jobTitle").value("Frontend Engineer"))
        .andExpect(jsonPath("$.data.experience.field").value("React"))
        .andExpect(jsonPath("$.data.experience.contribution").value("Improved profile editing"))
        .andExpect(jsonPath("$.data.education.name").value("HCMUS - Software Engineering"))
        .andExpect(jsonPath("$.data.certifications.name").value("AWS Cloud Practitioner"));

    mockMvc.perform(delete("/api/v1/applicants/{applicantId}/cv-file", applicant.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("CV file deleted successfully"))
        .andExpect(jsonPath("$.data.cvFileUrl").doesNotExist());
  }

  @Test
  void applicantShouldRemoveSavedJobAndWithdrawApplication() throws Exception {
    Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
    Applicant otherApplicant = seedApplicant("applicant02", "other-applicant@example.com");
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
    Job job = seedJob(recruiter, "Backend Engineer");
    ApplicantJob savedRelation = applicantJobRepository
        .save(new ApplicantJob(applicant, job, "SAVED"));
    ApplicantJob appliedRelation = applicantJobRepository
        .save(new ApplicantJob(applicant, job, "APPLIED"));

    mockMvc.perform(delete("/api/v1/applicants/{applicantId}/saved-jobs/{applicantJobId}",
        applicant.getId(), savedRelation.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("Saved job removed successfully"))
        .andExpect(jsonPath("$.data.applicantJobId").value(savedRelation.getId()));

    mockMvc.perform(delete("/api/v1/applicants/{applicantId}/applied-jobs/{applicantJobId}",
        applicant.getId(), appliedRelation.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("Application withdrawn successfully"))
        .andExpect(jsonPath("$.data.applicantJobId").value(appliedRelation.getId()));

    ApplicantJob protectedRelation = applicantJobRepository
        .save(new ApplicantJob(applicant, job, "SAVED"));
    mockMvc.perform(delete("/api/v1/applicants/{applicantId}/saved-jobs/{applicantJobId}",
        applicant.getId(), protectedRelation.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(otherApplicant)))
        .andExpect(status().isForbidden())
        .andExpect(jsonPath("$.errors[0]")
            .value("You can only manage jobs in your own applicant account"));
  }

  @Test
  void applicantJobEndpointsShouldReturnPagedMetadata() throws Exception {
    Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");

    Long newestSavedJobId = null;
    for (int index = 1; index <= 7; index++) {
      Job job = seedJob(recruiter, "Saved Job " + index);
      applicantJobRepository.save(new ApplicantJob(applicant, job, "SAVED"));
      newestSavedJobId = job.getId();
    }

    for (int index = 1; index <= 6; index++) {
      Job job = seedJob(recruiter, "Applied Job " + index);
      applicantJobRepository.save(new ApplicantJob(applicant, job, "APPLIED"));
    }

    mockMvc.perform(get("/api/v1/applicants/saved-jobs")
        .param("applicantId", applicant.getId().toString())
        .param("page", "0")
        .param("size", "5"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.content.length()").value(5))
        .andExpect(jsonPath("$.data.content[0].jobDescriptionId").value(newestSavedJobId))
        .andExpect(jsonPath("$.data.page").value(0))
        .andExpect(jsonPath("$.data.size").value(5))
        .andExpect(jsonPath("$.data.totalElements").value(7))
        .andExpect(jsonPath("$.data.totalPages").value(2))
        .andExpect(jsonPath("$.data.first").value(true))
        .andExpect(jsonPath("$.data.last").value(false));

    mockMvc.perform(get("/api/v1/applicants/saved-jobs")
        .param("applicantId", applicant.getId().toString())
        .param("page", "1")
        .param("size", "5"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.content.length()").value(2))
        .andExpect(jsonPath("$.data.page").value(1))
        .andExpect(jsonPath("$.data.last").value(true));

    mockMvc.perform(get("/api/v1/applicants/applied-jobs")
        .param("applicantId", applicant.getId().toString())
        .param("size", "99"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.content.length()").value(6))
        .andExpect(jsonPath("$.data.size").value(20))
        .andExpect(jsonPath("$.data.totalElements").value(6));
  }

  @Test
  void applicantShouldAnalyzeCvWithAuthenticatedAiEndpoint() throws Exception {
    Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
    Applicant otherApplicant = seedApplicant("applicant02", "other-applicant@example.com");
    MockMultipartFile cvFile = new MockMultipartFile(
        "cvFile",
        "applicant.pdf",
        MediaType.APPLICATION_PDF_VALUE,
        "sample cv".getBytes());
    when(cvAiService.analyzeCv(any())).thenReturn(new CvAnalysisResponse(
        "Applicant One",
        "applicant@example.com",
        "+84901234567",
        "Ho Chi Minh City",
        "Backend engineer",
        java.util.List.of("Java", "Spring Boot"),
        java.util.List.of(new CvExperienceResponse(
            "Example Corp",
            "Backend Engineer",
            "2024 - Present",
            "Built secure APIs",
            "Java",
            "")),
        java.util.List.of("HCMUS - Computer Science"),
        java.util.List.of("AWS Cloud Practitioner"),
        "layoutlmv3",
        0.94,
        java.util.List.of()));

    mockMvc.perform(multipart("/api/v1/applicants/{applicantId}/analyze-cv", applicant.getId())
        .file(cvFile)
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("CV analyzed successfully"))
        .andExpect(jsonPath("$.data.fullName").value("Applicant One"))
        .andExpect(jsonPath("$.data.skills[0]").value("Java"))
        .andExpect(jsonPath("$.data.extractionMode").value("layoutlmv3"));

    mockMvc.perform(multipart("/api/v1/applicants/{applicantId}/analyze-cv", applicant.getId())
        .file(cvFile)
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(otherApplicant)))
        .andExpect(status().isForbidden())
        .andExpect(jsonPath("$.errors[0]")
            .value("You can only manage jobs in your own applicant account"));
  }

  @Test
  void recruiterAndJobEndpointsShouldReadCreateAndUpdateJobs() throws Exception {
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
    Job existingJob = seedJob(recruiter, "Backend Engineer");

    mockMvc.perform(get("/api/v1/recruiters"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data[0].companyName").value("Example Corp"));

    mockMvc.perform(get("/api/v1/recruiters/{recruiterId}", recruiter.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.userName").value("recruiter01"));

    mockMvc.perform(put("/api/v1/recruiters/{recruiterId}", recruiter.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content(
            """
                {
                  "address": "Ho Chi Minh City",
                  "email": "updated-recruiter@example.com",
                  "phone": "+84909998888",
                  "userName": "updatedrecruiter",
                  "companyName": "Updated Corp",
                  "taxCode": "TAX-UPDATED",
                  "establishedDate": "2020-01-01",
                  "companyDescription": "General Java and React requirements",
                  "website": "https://updated.example.com",
                  "logoUrl": "https://example.com/recruiters/logo.png",
                  "coverImageUrl": "https://example.com/recruiters/cover.png",
                  "contactEmail": "hiring@example.com",
                  "contactPhone": "+84901234567",
                  "businessLicense": "https://example.com/license.pdf",
                  "companyType": "Private"
                }
                """))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.companyName").value("Updated Corp"))
        .andExpect(jsonPath("$.data.companyDescription")
            .value("General Java and React requirements"))
        .andExpect(jsonPath("$.data.logoUrl")
            .value("https://example.com/recruiters/logo.png"))
        .andExpect(jsonPath("$.data.coverImageUrl")
            .value("https://example.com/recruiters/cover.png"))
        .andExpect(jsonPath("$.data.website").value("https://updated.example.com"))
        .andExpect(jsonPath("$.data.taxCode").value("TAX-UPDATED"))
        .andExpect(jsonPath("$.data.contactEmail").value("hiring@example.com"))
        .andExpect(jsonPath("$.data.companyType").value("Private"));

    MockMultipartFile recruiterLogo = new MockMultipartFile(
        "image",
        "company-logo.png",
        MediaType.IMAGE_PNG_VALUE,
        new byte[] { (byte) 0x89, 0x50, 0x4E, 0x47 });
    try {
      mockMvc.perform(multipart("/api/v1/recruiters/{recruiterId}/images/logo", recruiter.getId())
          .file(recruiterLogo)
          .header(HttpHeaders.AUTHORIZATION, authorizationHeader(recruiter)))
          .andExpect(status().isOk())
          .andExpect(jsonPath("$.message").value("Recruiter image uploaded successfully"))
          .andExpect(jsonPath("$.data.logoUrl")
              .value(org.hamcrest.Matchers.startsWith("/uploads/recruiters/" + recruiter.getId() + "/logo-")));
    } finally {
      Recruiter recruiterWithLogo = recruiterRepository.findById(recruiter.getId()).orElseThrow();
      String logoUrl = recruiterWithLogo.getLogoUrl();
      if (logoUrl != null && logoUrl.startsWith("/uploads/recruiters/")) {
        Path logoPath = Path.of(logoUrl.substring(1));
        Files.deleteIfExists(logoPath);
        Files.deleteIfExists(logoPath.getParent());
      }
    }

    mockMvc.perform(multipart("/api/v1/recruiters/{recruiterId}/images/logo", recruiter.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(recruiter)))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.errors[0]").value("Image file is required"));

    mockMvc.perform(get("/api/v1/recruiters/jobs/{recruiterId}", recruiter.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data[0].jobTitle").value("Backend Engineer"));

    mockMvc.perform(post("/api/v1/recruiters/jobs/{recruiterId}", recruiter.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "jobTitle": "Frontend Engineer",
              "aboutCompany": "Product team",
              "jobDescription": "Build UI",
              "requirements": "React\\nTypeScript",
              "benefits": "Health insurance\\nLearning budget",
              "location": "Remote",
              "salaryRange": "3K$",
              "jobType": "Full-time",
              "yoe": 3,
              "experienceLevel": "Senior",
              "industry": "Software",
              "postedDate": "2026-05-16",
              "applyingDeadline": "2026-06-16",
              "startDate": "2026-07-01",
              "endDate": "2027-07-01",
              "customApplicationFields": "[{\\"id\\":\\"portfolio_url\\",\\"label\\":\\"Portfolio URL\\",\\"type\\":\\"url\\"}]"
            }
            """))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.jobTitle").value("Frontend Engineer"))
        .andExpect(jsonPath("$.data.aboutCompany").value("Product team"))
        .andExpect(jsonPath("$.data.requirements").value("React\nTypeScript"))
        .andExpect(jsonPath("$.data.benefits[0]").value("Health insurance"))
        .andExpect(jsonPath("$.data.benefits[1]").value("Learning budget"))
        .andExpect(jsonPath("$.data.salaryRange").value("3K$"))
        .andExpect(jsonPath("$.data.jobType").value("Full-time"))
        .andExpect(jsonPath("$.data.yoe").value("3"))
        .andExpect(jsonPath("$.data.experienceLevel").value("Senior"))
        .andExpect(jsonPath("$.data.industry").value("Software"))
        .andExpect(jsonPath("$.data.applyingDeadline").value("2026-06-16"))
        .andExpect(jsonPath("$.data.startDate").value("2026-07-01"))
        .andExpect(jsonPath("$.data.endDate").value("2027-07-01"))
        .andExpect(jsonPath("$.data.customApplicationFields")
            .value("[{\"id\":\"portfolio_url\",\"label\":\"Portfolio URL\",\"type\":\"url\"}]"));

    mockMvc.perform(post("/api/v1/recruiters/jobs/{recruiterId}", recruiter.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "jobTitle": "Title Only Job"
            }
            """))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.data.jobTitle").value("Title Only Job"))
        .andExpect(jsonPath("$.data.jobType").doesNotExist())
        .andExpect(jsonPath("$.data.salaryRange").doesNotExist())
        .andExpect(jsonPath("$.data.applyingDeadline").doesNotExist());

    mockMvc.perform(put("/api/v1/recruiters/jobs/{recruiterId}/{jobId}", recruiter.getId(),
        existingJob.getId())
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {
              "jobTitle": "Senior Backend Engineer",
              "aboutCompany": "Platform team",
              "jobDescription": "Build APIs",
              "requirements": "",
              "benefits": "",
              "location": "Hybrid",
              "experienceLevel": "Lead",
              "industry": "Platform",
              "postedDate": "2026-05-16",
              "customApplicationFields": ""
            }
            """))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.jobTitle").value("Senior Backend Engineer"))
        .andExpect(jsonPath("$.data.aboutCompany").value("Platform team"))
        .andExpect(jsonPath("$.data.location").value("Hybrid"))
        .andExpect(jsonPath("$.data.experienceLevel").value("Lead"))
        .andExpect(jsonPath("$.data.industry").value("Platform"))
        .andExpect(jsonPath("$.data.customApplicationFields").doesNotExist());
  }

  @Test
  void browseJobsEndpointsShouldListDetailAndApplicantCount() throws Exception {
    Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
    applicant.setShowFullName(true);
    applicant.setShowContactInfo(true);
    applicantRepository.save(applicant);
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
    Job jobDescription = seedJob(recruiter, "Backend Engineer");
    ApplicantJob application = new ApplicantJob(applicant, jobDescription);
    application.setCoverLetter("I build reliable APIs");
    application.setPortfolioUrl("https://portfolio.example.com");
    application.setApplicationAnswers("{\"years_in_role\":\"3\"}");
    applicantJobRepository.save(application);

    mockMvc.perform(get("/api/v1/browse-jobs"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.content[0].jobTitle").value("Backend Engineer"))
        .andExpect(jsonPath("$.data.page").value(0))
        .andExpect(jsonPath("$.data.size").value(10))
        .andExpect(jsonPath("$.data.totalElements").value(1))
        .andExpect(jsonPath("$.data.first").value(true))
        .andExpect(jsonPath("$.data.last").value(true));

    mockMvc.perform(get("/api/v1/browse-jobs/{jobId}", jobDescription.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.id").value(jobDescription.getId()));

    mockMvc.perform(get("/api/v1/browse-jobs/applicants/{jobId}", jobDescription.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.applicantCount").value(1));

    mockMvc.perform(get("/api/v1/browse-jobs/applicants/{jobId}/list", jobDescription.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data[0].applicationOrder").value(1))
        .andExpect(jsonPath("$.data[0].applicant.fullName").value("Applicant One"))
        .andExpect(jsonPath("$.data[0].applicant.email").value("applicant@example.com"))
        .andExpect(jsonPath("$.data[0].coverLetter").value("I build reliable APIs"))
        .andExpect(jsonPath("$.data[0].portfolioUrl").value("https://portfolio.example.com"))
        .andExpect(jsonPath("$.data[0].applicationAnswers").value("{\"years_in_role\":\"3\"}"));
  }

  @Test
  void applicantFacingCountShouldBeDifferentiallyPrivateStickyAndDistinct() throws Exception {
    Applicant viewer = seedApplicant("viewer", "viewer@example.com");
    Applicant duplicateApplicant = seedApplicant("duplicate", "duplicate@example.com");
    Applicant savedOnlyApplicant = seedApplicant("savedonly", "savedonly@example.com");
    Applicant withdrawnApplicant = seedApplicant("withdrawn", "withdrawn@example.com");
    Applicant browsingApplicant = seedApplicant("browser", "browser@example.com");
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
    Job job = seedJob(recruiter, "Backend Engineer");

    applicantJobRepository.save(new ApplicantJob(viewer, job, "APPLIED"));
    applicantJobRepository.save(new ApplicantJob(duplicateApplicant, job, "APPLIED"));
    applicantJobRepository.save(new ApplicantJob(duplicateApplicant, job, "APPLIED"));
    applicantJobRepository.save(new ApplicantJob(savedOnlyApplicant, job, "SAVED"));
    applicantJobRepository.save(new ApplicantJob(withdrawnApplicant, job, "WITHDRAWN"));

    mockMvc.perform(get("/api/v1/browse-jobs/applicants/{jobId}", job.getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.applicantCount").value(3));

    org.assertj.core.api.Assertions
        .assertThat(applicantJobRepository.countDistinctApplicantsByJobAndActionType(job.getId(), "APPLIED"))
        .isEqualTo(2);

    mockMvc.perform(get("/api/v1/jobs/{jobId}/applicant-count", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(viewer)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.jobId").value(job.getId()))
        .andExpect(jsonPath("$.data.approximateApplicantCount").isNumber())
        .andExpect(jsonPath("$.data.displayText").value(org.hamcrest.Matchers.startsWith("Approximately ")))
        .andExpect(jsonPath("$.data.approximate").value(true))
        .andExpect(jsonPath("$.data.rawCount").doesNotExist())
        .andExpect(jsonPath("$.data.noise").doesNotExist());

    mockMvc.perform(get("/api/v1/jobs/{jobId}/applicant-count", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(browsingApplicant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.displayText").value(org.hamcrest.Matchers.startsWith("Approximately ")));

    String firstResponse = mockMvc.perform(get("/api/v1/jobs/{jobId}/applicant-count", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(viewer)))
        .andReturn().getResponse().getContentAsString();
    String secondResponse = mockMvc.perform(get("/api/v1/jobs/{jobId}/applicant-count", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(duplicateApplicant)))
        .andReturn().getResponse().getContentAsString();
    org.assertj.core.api.Assertions.assertThat(secondResponse).isEqualTo(firstResponse);
  }

  @Test
  void anonymousCandidatePreviewShouldBeConsentBasedScopedAndRateLimited() throws Exception {
    Applicant viewer = seedApplicant("viewer", "viewer@example.com");
    Applicant savedOnly = seedApplicant("savedonly", "savedonly@example.com");
    Applicant optedOut = seedApplicant("optedout", "optedout@example.com");
    Applicant recruiterVisibleOnly = seedApplicant("recruiteronly", "recruiteronly@example.com");
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
    Job job = seedJob(recruiter, "Backend Engineer");

    applicantJobRepository.save(new ApplicantJob(viewer, job, "APPLIED"));
    applicantJobRepository.save(new ApplicantJob(savedOnly, job, "SAVED"));
    applicantJobRepository.save(new ApplicantJob(optedOut, job, "APPLIED"));
    recruiterVisibleOnly.setProfileVisibleToRecruiters(true);
    recruiterVisibleOnly.setProfileVisibleToOtherApplicants(false);
    applicantRepository.save(recruiterVisibleOnly);
    applicantJobRepository.save(new ApplicantJob(recruiterVisibleOnly, job, "APPLIED"));

    mockMvc.perform(get("/api/v1/jobs/{jobId}/anonymous-candidate-previews", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(viewer)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.available").value(false))
        .andExpect(jsonPath("$.data.profiles.length()").value(0));

    for (int index = 0; index < 3; index++) {
      Applicant candidate = seedApplicant("candidate" + index, "candidate" + index + "@example.com");
      candidate.setProfileVisibleToOtherApplicants(true);
      candidate.setAddress("Ho Chi Minh City");
      candidate.setCv(seedCv("Java, Spring Boot, PostgreSQL", "1-3 years"));
      applicantRepository.save(candidate);
      applicantJobRepository.save(new ApplicantJob(candidate, job, "APPLIED"));
    }

    mockMvc.perform(get("/api/v1/jobs/{jobId}/anonymous-candidate-previews", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(savedOnly)))
        .andExpect(status().isForbidden());

    mockMvc.perform(get("/api/v1/jobs/{jobId}/anonymous-candidate-previews", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(viewer)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.available").value(true))
        .andExpect(jsonPath("$.data.profiles.length()").value(2))
        .andExpect(jsonPath("$.data.profiles[0].anonymousProfileId")
            .value(org.hamcrest.Matchers.startsWith("candidate-")))
        .andExpect(jsonPath("$.data.profiles[0].skillCategories[0]").value("Backend"))
        .andExpect(jsonPath("$.data.profiles[0].educationLevel").value("Bachelor's degree"))
        .andExpect(jsonPath("$.data.profiles[0].generalRegion").value("Southern Vietnam"))
        .andExpect(jsonPath("$.data.profiles[0].id").doesNotExist())
        .andExpect(jsonPath("$.data.profiles[0].applicantId").doesNotExist())
        .andExpect(jsonPath("$.data.profiles[0].fullName").doesNotExist())
        .andExpect(jsonPath("$.data.profiles[0].email").doesNotExist())
        .andExpect(jsonPath("$.data.profiles[0].phone").doesNotExist())
        .andExpect(jsonPath("$.data.profiles[0].address").doesNotExist())
        .andExpect(jsonPath("$.data.profiles[0].cvFileUrl").doesNotExist())
        .andExpect(jsonPath("$.data.page").doesNotExist());

    mockMvc.perform(get("/api/v1/jobs/{jobId}/anonymous-candidate-previews", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(viewer)))
        .andExpect(status().isOk());

    mockMvc.perform(get("/api/v1/jobs/{jobId}/anonymous-candidate-previews", job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(viewer)))
        .andExpect(status().isForbidden())
        .andExpect(jsonPath("$.errors[0]").value("Anonymous candidate preview rate limit exceeded"));
  }

  @Test
  void applicantShouldMatchCvToJobWithAuthenticatedEndpoint() throws Exception {
    Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
    Applicant otherApplicant = seedApplicant("applicant02", "other-applicant@example.com");
    Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
    Job job = seedJob(recruiter, "Backend Engineer");

    CvJobMatchResponse mockResult = new CvJobMatchResponse(
        applicant.getId(),
        job.getId(),
        true,
        0.82,
        82,
        "Recommendation is mainly driven by a strong technical skills match (88%).",
        java.util.List.of("Add an AWS certification if it is relevant to your target role."),
        java.util.Map.of("SKILL", 0.88, "EXPERIENCE", 0.70),
        java.util.List.of(),
        "tfidf",
        "svm",
        false,
        null,
        null,
        null);
    when(cvMatchService.matchApplicantToJob(any(), any(), any())).thenReturn(mockResult);

    // Happy path: owner token → 200 with match data
    mockMvc.perform(post("/api/v1/applicants/{applicantId}/match/{jobId}",
        applicant.getId(), job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant))
        .contentType(MediaType.APPLICATION_JSON)
        .content("{\"llm\":false,\"method\":\"tfidf\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("CV matched successfully"))
        .andExpect(jsonPath("$.data.matchPercent").value(82))
        .andExpect(jsonPath("$.data.passedFilter").value(true))
        .andExpect(jsonPath("$.data.scoringMethod").value("tfidf"))
        .andExpect(jsonPath("$.data.modelUsed").value("svm"))
        .andExpect(jsonPath("$.data.differentialPrivacyApplied").value(false))
        .andExpect(jsonPath("$.data.privacyEpsilon").doesNotExist())
        .andExpect(jsonPath("$.data.suggestions[0]").value("Add an AWS certification if it is relevant to your target role."));

    // Body omitted (default options) → still 200
    mockMvc.perform(post("/api/v1/applicants/{applicantId}/match/{jobId}",
        applicant.getId(), job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(applicant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data.matchScore").value(0.82));

    // Other applicant's token → 403 Forbidden
    mockMvc.perform(post("/api/v1/applicants/{applicantId}/match/{jobId}",
        applicant.getId(), job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(otherApplicant))
        .contentType(MediaType.APPLICATION_JSON)
        .content("{}"))
        .andExpect(status().isForbidden())
        .andExpect(jsonPath("$.errors[0]")
            .value("You can only manage jobs in your own applicant account"));
  }

  @Test
  void postingRecruiterShouldAiRankApplicantsByRawMatchScore() throws Exception {
    Recruiter recruiter = seedRecruiter("ranking-recruiter", "ranking@example.com");
    Recruiter otherRecruiter = seedRecruiter("other-recruiter", "other-recruiter@example.com");
    Job job = seedJob(recruiter, "Platform Engineer");
    Applicant firstApplicant = seedApplicant("first-candidate", "first@example.com");
    Applicant secondApplicant = seedApplicant("second-candidate", "second@example.com");
    firstApplicant.setCv(seedCv("Java, SQL", "2 years"));
    secondApplicant.setCv(seedCv("Java, Spring Boot, PostgreSQL", "5 years"));
    applicantRepository.save(firstApplicant);
    applicantRepository.save(secondApplicant);
    applicantJobRepository.save(new ApplicantJob(firstApplicant, job, "APPLIED"));
    applicantJobRepository.save(new ApplicantJob(secondApplicant, job, "APPLIED"));

    when(cvMatchService.matchApplicantToJob(any(), any(), any())).thenAnswer(invocation -> {
      Long applicantId = invocation.getArgument(0);
      int percent = applicantId.equals(secondApplicant.getId()) ? 91 : 64;
      return new CvJobMatchResponse(
          applicantId, job.getId(), true, percent / 100.0, percent,
          "AI score for candidate", java.util.List.of(), java.util.Map.of("SKILL", percent / 100.0),
          java.util.List.of(), "tfidf", "svm", false, null, null, null);
    });

    mockMvc.perform(get("/api/v1/recruiters/jobs/{recruiterId}/{jobId}/applicants",
        recruiter.getId(), job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(recruiter)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.data[0].applicationOrder").value(1))
        .andExpect(jsonPath("$.data[1].applicationOrder").value(2));

    mockMvc.perform(post("/api/v1/recruiters/jobs/{recruiterId}/{jobId}/ai-match",
        recruiter.getId(), job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(recruiter))
        .contentType(MediaType.APPLICATION_JSON)
        .content("{\"llm\":true,\"method\":\"tfidf\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("Job applicants matched and ranked"))
        .andExpect(jsonPath("$.data[0].applicationOrder").value(2))
        .andExpect(jsonPath("$.data[0].match.matchPercent").value(91))
        .andExpect(jsonPath("$.data[0].match.reason").doesNotExist())
        .andExpect(jsonPath("$.data[0].match.suggestions").isEmpty())
        .andExpect(jsonPath("$.data[0].match.perFieldScores").isEmpty())
        .andExpect(jsonPath("$.data[0].match.differentialPrivacyApplied").value(false))
        .andExpect(jsonPath("$.data[1].applicationOrder").value(1))
        .andExpect(jsonPath("$.data[1].match.matchPercent").value(64));

    verify(cvMatchService, times(2)).matchApplicantToJob(
        any(),
        eq(job.getId()),
        argThat(options -> Boolean.FALSE.equals(options.getLlm()) && "tfidf".equals(options.getMethod())));

    mockMvc.perform(post("/api/v1/recruiters/jobs/{recruiterId}/{jobId}/applicants/{applicantId}/ai-match",
        recruiter.getId(), job.getId(), firstApplicant.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(recruiter))
        .contentType(MediaType.APPLICATION_JSON)
        .content("{\"llm\":true,\"method\":\"tfidf\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("Applicant AI suggestion generated"))
        .andExpect(jsonPath("$.data.applicationOrder").value(1))
        .andExpect(jsonPath("$.data.match.matchPercent").value(64));

    mockMvc.perform(post("/api/v1/recruiters/jobs/{recruiterId}/{jobId}/ai-match",
        recruiter.getId(), job.getId())
        .header(HttpHeaders.AUTHORIZATION, authorizationHeader(otherRecruiter))
        .contentType(MediaType.APPLICATION_JSON)
        .content("{}"))
        .andExpect(status().isForbidden())
        .andExpect(jsonPath("$.errors[0]")
            .value("Only the posting recruiter can access applicants for this job"));
  }

  private Applicant seedApplicant(String userName, String email) {
    Role role = roleRepository.findByRoleName("APPLICANT")
        .orElseGet(() -> roleRepository.save(new Role("APPLICANT", "Applicant")));
    Applicant applicant = new Applicant();
    applicant.setAddress("Hanoi");
    applicant.setEmail(email);
    applicant.setUserName(userName);
    applicant.setPassword(passwordEncoder.encode("secret123"));
    applicant.setPhone("+84901234567");
    applicant.setFullName("Applicant One");
    applicant.setGender(GenderEnum.Male);
    applicant.setStatus(ApplicantStatusEnum.OpenToWork);
    applicant.setProfileVisibleToRecruiters(false);
    applicant.setRole(role);
    return applicantRepository.save(applicant);
  }

  private Recruiter seedRecruiter(String userName, String email) {
    Role role = roleRepository.findByRoleName("RECRUITER")
        .orElseGet(() -> roleRepository.save(new Role("RECRUITER", "Recruiter")));
    Recruiter recruiter = new Recruiter();
    recruiter.setAddress("Hanoi");
    recruiter.setEmail(email);
    recruiter.setUserName(userName);
    recruiter.setPassword(passwordEncoder.encode("secret123"));
    recruiter.setPhone("+84909998888");
    recruiter.setCompanyName("Example Corp");
    recruiter.setCompanyDesc("Example recruiter");
    recruiter.setLocation("Hanoi");
    recruiter.setEstablishedDate(Date.valueOf("2020-01-01"));
    recruiter.setRole(role);
    return recruiterRepository.save(recruiter);
  }

  private Job seedJob(Recruiter recruiter, String jobTitle) {
    Job jobDescription = new Job();
    jobDescription.setJobTitle(jobTitle);
    jobDescription.setJobType("Full-time");
    jobDescription.setLocation("Remote");
    jobDescription.setPostedDate(Date.valueOf(LocalDate.now()));
    jobDescription.setRecruiter(recruiter);
    return jobDescriptionRepository.save(jobDescription);
  }

  private Cv seedCv(String skills, String period) {
    Experience experience = new Experience();
    experience.setCompanyName("Hidden Company");
    experience.setJobTitle("Backend Engineer");
    experience.setField("Java");
    experience.setTime(period);
    Education education = new Education();
    education.setName("Hidden University");
    education.setDegree(DATN.backend.Enum.DegreeEnum.BSc);
    Cv cv = new Cv();
    cv.setSkills(java.util.Arrays.stream(skills.split(","))
        .map(String::trim)
        .toList());
    cv.setExperienceObj(experienceRepository.save(experience));
    cv.setEducationObj(educationRepository.save(education));
    cv.setAddress("Ho Chi Minh City");
    cv.setCvFileUrl("https://example.com/private.pdf");
    return cvRepository.save(cv);
  }

  private String authorizationHeader(Applicant applicant) {
    String token = jwtService.generateToken(new InforInsideToken(
        applicant.getId(),
        applicant.getUserName(),
        applicant.getEmail(),
        "APPLICANT"));
    return "Bearer " + token;
  }

  private String authorizationHeader(Recruiter recruiter) {
    String token = jwtService.generateToken(new InforInsideToken(
        recruiter.getId(),
        recruiter.getUserName(),
        recruiter.getEmail(),
        "RECRUITER"));
    return "Bearer " + token;
  }
}
