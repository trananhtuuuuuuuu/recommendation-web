package DATN.backend;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import DATN.backend.Enum.DegreeEnum;
import DATN.backend.model.Certificate;
import DATN.backend.model.Education;
import DATN.backend.repository.CertificateRepository;
import DATN.backend.repository.EducationRepository;

/**
 * Verifies that extracted education and certificate text is not constrained to
 * VARCHAR(255).
 */
@SpringBootTest
@Transactional
class EducationCertificateTextPersistenceTests {

    @Autowired
    private EducationRepository educationRepository;

    @Autowired
    private CertificateRepository certificateRepository;

    @Test
    void shouldPersistEducationAndCertificateValuesLongerThanVarcharLimit() {
        String longValue = "Extracted profile content ".repeat(30);

        Education education = new Education();
        education.setDegree(DegreeEnum.Other);
        education.setMajor(longValue);
        education.setName(longValue);
        education.setTime(longValue);
        Education savedEducation = educationRepository.saveAndFlush(education);

        Certificate certificate = new Certificate();
        certificate.setScore(longValue);
        certificate.setProvider(longValue);
        certificate.setName(longValue);
        Certificate savedCertificate = certificateRepository.saveAndFlush(certificate);

        assertThat(educationRepository.findById(savedEducation.getId()))
                .get()
                .extracting(Education::getName, Education::getMajor, Education::getTime)
                .containsExactly(longValue, longValue, longValue);
        assertThat(certificateRepository.findById(savedCertificate.getId()))
                .get()
                .extracting(Certificate::getName, Certificate::getProvider, Certificate::getScore)
                .containsExactly(longValue, longValue, longValue);
    }
}
