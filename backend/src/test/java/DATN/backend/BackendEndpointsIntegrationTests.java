package DATN.backend;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.sql.Date;
import java.time.LocalDate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestConstructor;
import org.springframework.test.web.servlet.MockMvc;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.Enum.GenderEnum;
import DATN.backend.model.Applicant;
import DATN.backend.model.ApplicantJobDescription;
import DATN.backend.model.JobDescription;
import DATN.backend.model.Recruiter;
import DATN.backend.model.Role;
import DATN.backend.repository.ApplicantJobDescriptionRepository;
import DATN.backend.repository.ApplicantRepository;
import DATN.backend.repository.CvRepository;
import DATN.backend.repository.JobDescriptionRepository;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.repository.RoleRepository;
import DATN.backend.repository.UserRepository;

@SpringBootTest
@AutoConfigureMockMvc
@TestConstructor(autowireMode = TestConstructor.AutowireMode.ALL)
class BackendEndpointsIntegrationTests {

    private final MockMvc mockMvc;
    private final UserRepository userRepository;
    private final ApplicantRepository applicantRepository;
    private final ApplicantJobDescriptionRepository applicantJobDescriptionRepository;
    private final CvRepository cvRepository;
    private final RecruiterRepository recruiterRepository;
    private final RoleRepository roleRepository;
    private final JobDescriptionRepository jobDescriptionRepository;
    private final PasswordEncoder passwordEncoder;

    BackendEndpointsIntegrationTests(MockMvc mockMvc, UserRepository userRepository,
            ApplicantRepository applicantRepository,
            ApplicantJobDescriptionRepository applicantJobDescriptionRepository, CvRepository cvRepository,
            RecruiterRepository recruiterRepository, RoleRepository roleRepository,
            JobDescriptionRepository jobDescriptionRepository, PasswordEncoder passwordEncoder) {
        this.mockMvc = mockMvc;
        this.userRepository = userRepository;
        this.applicantRepository = applicantRepository;
        this.applicantJobDescriptionRepository = applicantJobDescriptionRepository;
        this.cvRepository = cvRepository;
        this.recruiterRepository = recruiterRepository;
        this.roleRepository = roleRepository;
        this.jobDescriptionRepository = jobDescriptionRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @BeforeEach
    void cleanDatabase() {
        applicantJobDescriptionRepository.deleteAll();
        jobDescriptionRepository.deleteAll();
        applicantRepository.deleteAll();
        recruiterRepository.deleteAll();
        userRepository.deleteAll();
        cvRepository.deleteAll();
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
                          "phone": "+84901234567",
                          "userName": "applicant01",
                          "fullName": "Applicant One"
                        }
                        """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.userName").value("applicant01"))
                .andExpect(jsonPath("$.data.email").value("applicant@example.com"));
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
                          "phone": "+84901234567",
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
    void applicantEndpointsShouldReadUpdateSaveJobAndUploadCv() throws Exception {
        Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
        Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
        JobDescription job = seedJob(recruiter, "Backend Engineer");

        mockMvc.perform(get("/api/v1/applicants"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].userName").value("applicant01"));

        mockMvc.perform(get("/api/v1/applicants/{applicantId}", applicant.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.email").value("applicant@example.com"));

        mockMvc.perform(put("/api/v1/applicants/{applicantId}", applicant.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "address": "Da Nang",
                          "email": "updated-applicant@example.com",
                          "phone": "+84901234567",
                          "userName": "updatedapplicant",
                          "fullName": "Updated Applicant",
                          "gender": "Female",
                          "status": "OpenToWork"
                        }
                        """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.userName").value("updatedapplicant"))
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
                        """.formatted(applicant.getId(), job.getId())))
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
                .andExpect(jsonPath("$.data[0].jobDescriptionId").value(job.getId()));

        mockMvc.perform(get("/api/v1/applicants/applied-jobs").param("applicantId", applicant.getId().toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].jobDescriptionId").value(job.getId()));

        mockMvc.perform(post("/api/v1/applicants/upload-cv/{applicantId}", applicant.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "fullName": "Updated Applicant",
                          "address": "Da Nang",
                          "phone": "+84901234567",
                          "objective": "Build good software",
                          "skills": "Java, Spring Boot"
                        }
                        """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.fullName").value("Updated Applicant"));
    }

    @Test
    void recruiterAndJobEndpointsShouldReadCreateAndUpdateJobs() throws Exception {
        Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
        JobDescription existingJob = seedJob(recruiter, "Backend Engineer");

        mockMvc.perform(get("/api/v1/recruiters"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].companyName").value("Example Corp"));

        mockMvc.perform(get("/api/v1/recruiters/{recruiterId}", recruiter.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.userName").value("recruiter01"));

        mockMvc.perform(put("/api/v1/recruiters/{recruiterId}", recruiter.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "address": "Ho Chi Minh City",
                          "email": "updated-recruiter@example.com",
                          "phone": "+84909998888",
                          "userName": "updatedrecruiter",
                          "companyName": "Updated Corp",
                          "taxCode": "TAX-UPDATED",
                          "establishedDate": "2020-01-01",
                          "companyDescription": "General Java and React requirements"
                        }
                        """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.companyName").value("Updated Corp"))
                .andExpect(jsonPath("$.data.companyDescription").value("General Java and React requirements"));

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
                          "location": "Remote",
                          "postedDate": "2026-05-16"
                        }
                        """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.jobTitle").value("Frontend Engineer"));

        mockMvc.perform(put("/api/v1/recruiters/jobs/{recruiterId}/{jobId}", recruiter.getId(), existingJob.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "jobTitle": "Senior Backend Engineer",
                          "aboutCompany": "Platform team",
                          "jobDescription": "Build APIs",
                          "location": "Hybrid",
                          "postedDate": "2026-05-16"
                        }
                        """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.jobTitle").value("Senior Backend Engineer"))
                .andExpect(jsonPath("$.data.location").value("Hybrid"));
    }

    @Test
    void browseJobsEndpointsShouldListDetailAndApplicantCount() throws Exception {
        Applicant applicant = seedApplicant("applicant01", "applicant@example.com");
        Recruiter recruiter = seedRecruiter("recruiter01", "recruiter@example.com");
        JobDescription jobDescription = seedJob(recruiter, "Backend Engineer");
        ApplicantJobDescription application = new ApplicantJobDescription(applicant, jobDescription);
        application.setApplicationAnswers("{\"years_in_role\":\"3\"}");
        applicantJobDescriptionRepository.save(application);

        mockMvc.perform(get("/api/v1/browse-jobs"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].jobTitle").value("Backend Engineer"));

        mockMvc.perform(get("/api/v1/browse-jobs/{jobId}", jobDescription.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(jobDescription.getId()));

        mockMvc.perform(get("/api/v1/browse-jobs/applicants/{jobId}", jobDescription.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.applicantCount").value(1));

        mockMvc.perform(get("/api/v1/browse-jobs/applicants/{jobId}/list", jobDescription.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].applicant.userName").value("applicant01"))
                .andExpect(jsonPath("$.data[0].applicationAnswers").exists());
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
        recruiter.setTaxCode("TAX-001");
        recruiter.setEstablishedDate("2020-01-01");
        recruiter.setRole(role);
        return recruiterRepository.save(recruiter);
    }

    private JobDescription seedJob(Recruiter recruiter, String jobTitle) {
        JobDescription jobDescription = new JobDescription();
        jobDescription.setJobTitle(jobTitle);
        jobDescription.setLocation("Remote");
        jobDescription.setPostedDate(Date.valueOf(LocalDate.now()));
        jobDescription.setRecruiter(recruiter);
        return jobDescriptionRepository.save(jobDescription);
    }
}
