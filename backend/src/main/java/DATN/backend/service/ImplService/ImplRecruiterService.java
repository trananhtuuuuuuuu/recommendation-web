package DATN.backend.service.ImplService;

import java.util.List;

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
import DATN.backend.request.recruiter.UpdateRecruiterRequest;
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

    @Override
    @Transactional
    public RegistrationRecruiterResponse registerRecruiter(RegistrationRecruiterRequest request) {
        if (userRepository.findByUserName(request.getUserName()).isPresent()) {
            throw new AlreadyExistException("User name already exists");
        }
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new AlreadyExistException("Email already exists");
        }

        Role role = roleRepository.findByRoleName(request.getRoleName())
                .orElseGet(() -> roleRepository.save(new Role(request.getRoleName(), request.getRoleName())));

        Recruiter recruiter = RecruiterMapper.toNewRecruiter(request);
        recruiter.setPassword(passwordEncoder.encode(request.getPassword()));
        recruiter.setRole(role);
        Recruiter savedRecruiter = recruiterRepository.save(recruiter);
        return RecruiterMapper.toRegistrationResponse(savedRecruiter);
    }

    @Override
    public RecruiterResponse getRecruiterById(Long recruiterId) {
        Recruiter recruiter = recruiterRepository.findById(recruiterId)
                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
        return RecruiterMapper.toRecruiterResponse(recruiter);
    }

    @Override
    public List<RecruiterResponse> getAllRecruiters() {
        return recruiterRepository.findAll().stream()
                .map(RecruiterMapper::toRecruiterResponse)
                .toList();
    }

    @Override
    @Transactional
    public RecruiterResponse updateRecruiter(Long recruiterId, UpdateRecruiterRequest request) {
        Recruiter recruiter = recruiterRepository.findById(recruiterId)
                .orElseThrow(() -> new ResourcesNotFoundException("Recruiter not found"));
        RecruiterMapper.updateRecruiter(recruiter, request);
        Recruiter savedRecruiter = recruiterRepository.save(recruiter);
        return RecruiterMapper.toRecruiterResponse(savedRecruiter);
    }
}
