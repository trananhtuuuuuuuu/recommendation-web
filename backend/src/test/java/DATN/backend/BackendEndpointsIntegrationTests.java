package DATN.backend;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.sql.Date;
import java.time.LocalDate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import DATN.backend.model.JobDescription;
import DATN.backend.model.Recruiter;
import DATN.backend.model.Role;
import DATN.backend.repository.JobDescriptionRepository;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.repository.RoleRepository;
import DATN.backend.repository.UserRepository;

@SpringBootTest
@AutoConfigureMockMvc
class BackendEndpointsIntegrationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RecruiterRepository recruiterRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private JobDescriptionRepository jobDescriptionRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @BeforeEach
    void cleanDatabase() {
        jobDescriptionRepository.deleteAll();
        recruiterRepository.deleteAll();
        userRepository.deleteAll();
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
    void browseJobsShouldListSeededJobs() throws Exception {
        Role recruiterRole = roleRepository.save(new Role("RECRUITER", "Recruiter"));
        Recruiter recruiter = new Recruiter();
        recruiter.setAddress("Hanoi");
        recruiter.setEmail("recruiter@example.com");
        recruiter.setUserName("recruiter01");
        recruiter.setPassword(passwordEncoder.encode("secret123"));
        recruiter.setPhone("+84909998888");
        recruiter.setCompanyName("Example Corp");
        recruiter.setTaxCode("TAX-001");
        recruiter.setEstablishedDate("2020-01-01");
        recruiter.setRole(recruiterRole);
        recruiter = recruiterRepository.save(recruiter);

        JobDescription jobDescription = new JobDescription();
        jobDescription.setJobTitle("Backend Engineer");
        jobDescription.setLocation("Remote");
        jobDescription.setPostedDate(Date.valueOf(LocalDate.now()));
        jobDescription.setRecruiter(recruiter);
        jobDescriptionRepository.save(jobDescription);

        mockMvc.perform(get("/api/v1/browse-jobs"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].jobTitle").value("Backend Engineer"));
    }
}