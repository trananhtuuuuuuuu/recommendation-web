package DATN.backend.dto;

import DATN.backend.Enum.ApplicantStatusEnum;
import DATN.backend.Enum.GenderEnum;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ApplicantDto {
    private Long id;
    private String address;
    private String email;
    private String phone;
    private String userName;
    private Long RoleId;
    private String fullName;
    private GenderEnum gender;
    private ApplicantStatusEnum status;
    private Long cvId;
}
