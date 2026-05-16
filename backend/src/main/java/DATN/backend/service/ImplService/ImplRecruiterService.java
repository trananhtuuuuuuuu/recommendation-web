package DATN.backend.service.ImplService;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.exception.AlreadyExistException;
import DATN.backend.exception.ResourcesNotFoundException;
import DATN.backend.mapper.RecruiterMapper;
import DATN.backend.model.Recruiter;
import DATN.backend.model.Role;
import DATN.backend.repository.RecruiterRepository;
import DATN.backend.repository.RoleRepository;
import DATN.backend.repository.UserRepository;
import DATN.backend.request.recruiter.RegistrationRecruiterRequest;
import DATN.backend.response.ApiResponse;
import DATN.backend.response.recruiter.RecruiterResponse;
import DATN.backend.response.recruiter.RegistrationRecruiterResponse;
import DATN.backend.service.InterfaceService.InterfaceRecruiterService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ImplRecruiterService implements InterfaceRecruiterService {

    private final RecruiterRepository recruiterRepository;
    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RecruiterMapper recruiterMapper = new RecruiterMapper();

    @Override
    @Transactional
    public ApiResponse registerRecruiter(RegistrationRecruiterRequest request) {
        if (userRepository.findByUserName(request.getUserName()).isPresent()) {
            throw new AlreadyExistException("User name already exists");
        }
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new AlreadyExistException("Email already exists");
        }

        Role role = roleRepository.findByRoleName(request.getRoleName())
                .orElseGet(() -> roleRepository.save(new Role(request.getRoleName(), request.getRoleName())));

        Recruiter recruiter = recruiterMapper.toNewRecruiter(request);
        recruiter.setPassword(passwordEncoder.encode(request.getPassword()));
        recruiter.setRole(role);
        Recruiter savedRecruiter = recruiterRepository.save(recruiter);
        RegistrationRecruiterResponse response = recruiterMapper.toRegistrationResponse(savedRecruiter);
        return new ApiResponse("Recruiter registered successfully", HttpStatus.CREATED.value(), null, null, response);
    }

    @Override
    public ApiResponse getRecruiterById(Long recruiterId) {
        Recruiter recruiter = recruiterRepository.findById(recruiterId)
                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
        RecruiterResponse response = recruiterMapper.toRecruiterResponse(recruiter);
        return new ApiResponse("Recruiter found", HttpStatus.OK.value(), null, null, response);
    }

    @Override
    public ApiResponse getAllRecruiters() {
        List<RecruiterResponse> response = recruiterRepository.findAll().stream()
                .map(recruiterMapper::toRecruiterResponse)
                .toList();
        return new ApiResponse("Recruiters found", HttpStatus.OK.value(), null, null, response);
    }
}