package DATN.backend.config;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DatabaseSchemaGuard implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        jdbcTemplate.execute("""
                ALTER TABLE applicant_job_descriptions
                ADD COLUMN IF NOT EXISTS action_type VARCHAR(255) NOT NULL DEFAULT 'APPLIED'
                """);
        jdbcTemplate.execute("""
                UPDATE applicant_job_descriptions
                SET action_type = 'APPLIED'
                WHERE action_type IS NULL
                """);
        jdbcTemplate.execute("""
                ALTER TABLE applicant_job_descriptions
                ADD COLUMN IF NOT EXISTS cover_letter TEXT
                """);
        jdbcTemplate.execute("""
                ALTER TABLE applicant_job_descriptions
                ADD COLUMN IF NOT EXISTS portfolio_url VARCHAR(255)
                """);
        jdbcTemplate.execute("""
                ALTER TABLE applicant_job_descriptions
                ADD COLUMN IF NOT EXISTS application_answers TEXT
                """);
        jdbcTemplate.execute("""
                ALTER TABLE job_descriptions
                ADD COLUMN IF NOT EXISTS custom_application_fields TEXT
                """);
    }
}
