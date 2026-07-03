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
                if (tableExists("applicant_job_descriptions") && !tableExists("applicant_jobs")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE applicant_job_descriptions
                                        RENAME TO applicant_jobs
                                        """);
                }
                if (columnExists("applicant_jobs", "job_description_id") && !columnExists("applicant_jobs", "job_id")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE applicant_jobs
                                        RENAME COLUMN job_description_id TO job_id
                                        """);
                } else if (columnExists("applicant_jobs", "job_description_id")
                                && columnExists("applicant_jobs", "job_id")) {
                        jdbcTemplate.execute("""
                                        UPDATE applicant_jobs
                                        SET job_id = job_description_id
                                        WHERE job_id IS NULL AND job_description_id IS NOT NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS applicant_jobs
                                ADD COLUMN IF NOT EXISTS action_type VARCHAR(255) NOT NULL DEFAULT 'APPLIED'
                                """);
                if (tableExists("applicant_jobs")) {
                        jdbcTemplate.execute("""
                                        UPDATE applicant_jobs
                                        SET action_type = 'APPLIED'
                                        WHERE action_type IS NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS application_forms
                                ADD COLUMN IF NOT EXISTS field_value VARCHAR(255)
                                """);
                if (tableExists("job_descriptions") && !tableExists("jobs")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE job_descriptions
                                        RENAME TO jobs
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS job_desc TEXT
                                """);
                if (columnExists("jobs", "job_description")) {
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET job_desc = job_description
                                        WHERE job_desc IS NULL AND job_description IS NOT NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS requirement TEXT
                                """);
                if (columnExists("jobs", "requirements")) {
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET requirement = requirements
                                        WHERE requirement IS NULL AND requirements IS NOT NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS yoe INTEGER
                                """);
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS custom_application_fields_id BIGINT
                                """);
                if (isTextColumn("jobs", "salary_range")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE jobs
                                        ALTER COLUMN salary_range TYPE DOUBLE PRECISION
                                        USING NULLIF(substring(salary_range::TEXT FROM '[0-9]+(\\.[0-9]+)?'), '')::DOUBLE PRECISION
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS recruiters
                                ADD COLUMN IF NOT EXISTS company_desc TEXT
                                """);
                if (isTextColumn("recruiters", "company_size")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE recruiters
                                        ALTER COLUMN company_size TYPE INTEGER
                                        USING NULLIF(substring(company_size::TEXT FROM '[0-9]+'), '')::INTEGER
                                        """);
                }
                if (columnExists("recruiters", "company_description")) {
                        jdbcTemplate.execute("""
                                        UPDATE recruiters
                                        SET company_desc = company_description
                                        WHERE company_desc IS NULL AND company_description IS NOT NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS recruiters
                                ADD COLUMN IF NOT EXISTS location VARCHAR(255)
                                """);
                if (columnExists("recruiters", "company_location")) {
                        jdbcTemplate.execute("""
                                        UPDATE recruiters
                                        SET location = company_location
                                        WHERE location IS NULL AND company_location IS NOT NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS recruiters
                                ADD COLUMN IF NOT EXISTS industry_type VARCHAR(255)
                                """);
                if (columnExists("recruiters", "industry")) {
                        jdbcTemplate.execute("""
                                        UPDATE recruiters
                                        SET industry_type = industry
                                        WHERE industry_type IS NULL AND industry IS NOT NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS recruiters
                                ADD COLUMN IF NOT EXISTS contact VARCHAR(255)
                                """);
                if (columnExists("recruiters", "contact_email") || columnExists("recruiters", "contact_phone")) {
                        String contactExpression = columnExists("recruiters", "contact_email")
                                        && columnExists("recruiters", "contact_phone")
                                                        ? "COALESCE(contact_email, contact_phone)"
                                                        : columnExists("recruiters", "contact_email") ? "contact_email"
                                                                        : "contact_phone";
                        jdbcTemplate.execute("""
                                        UPDATE recruiters
                                        SET contact = %s
                                        WHERE contact IS NULL
                                        """.formatted(contactExpression));
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS recruiters
                                ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(2048)
                                """);
                if (columnExists("recruiters", "logo_url") || columnExists("recruiters", "cover_image_url")) {
                        String avatarExpression = columnExists("recruiters", "logo_url")
                                        && columnExists("recruiters", "cover_image_url")
                                                        ? "COALESCE(logo_url, cover_image_url)"
                                                        : columnExists("recruiters", "logo_url") ? "logo_url"
                                                                        : "cover_image_url";
                        jdbcTemplate.execute("""
                                        UPDATE recruiters
                                        SET avatar_url = %s
                                        WHERE avatar_url IS NULL
                                        """.formatted(avatarExpression));
                }
        }

        private boolean tableExists(String tableName) {
                return Boolean.TRUE.equals(jdbcTemplate.queryForObject("""
                                SELECT COUNT(*) > 0
                                FROM information_schema.tables
                                WHERE LOWER(table_name) = LOWER(?)
                                """, Boolean.class, tableName));
        }

        private boolean columnExists(String tableName, String columnName) {
                return Boolean.TRUE.equals(jdbcTemplate.queryForObject("""
                                SELECT COUNT(*) > 0
                                FROM information_schema.columns
                                WHERE LOWER(table_name) = LOWER(?)
                                  AND LOWER(column_name) = LOWER(?)
                                """, Boolean.class, tableName, columnName));
        }

        private boolean isTextColumn(String tableName, String columnName) {
                String dataType = jdbcTemplate.query("""
                                SELECT data_type
                                FROM information_schema.columns
                                WHERE LOWER(table_name) = LOWER(?)
                                  AND LOWER(column_name) = LOWER(?)
                                """, rs -> rs.next() ? rs.getString("data_type") : null, tableName, columnName);
                return dataType != null && (dataType.contains("character") || dataType.equalsIgnoreCase("text"));
        }
}
