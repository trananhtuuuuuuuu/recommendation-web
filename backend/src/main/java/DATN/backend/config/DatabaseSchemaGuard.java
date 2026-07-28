package DATN.backend.config;

import java.sql.Connection;
import java.sql.ResultSet;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.ConnectionCallback;
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
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS about_company TEXT
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
                                ADD COLUMN IF NOT EXISTS requirements TEXT
                                """);
                if (columnExists("jobs", "requirement")) {
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET requirements = requirement
                                        WHERE requirements IS NULL AND requirement IS NOT NULL
                                        """);
                }
                addStructuredJobRequirementColumns();
                addLanguageRequirementSchema();
                addApplicantCountPrivacySchema();
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS yoe VARCHAR(255)
                                """);
                if (columnExists("jobs", "yoe") && !isTextColumn("jobs", "yoe")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE jobs
                                        ALTER COLUMN yoe TYPE VARCHAR(255)
                                        USING yoe::TEXT
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS experience_level VARCHAR(255)
                                """);
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS industry VARCHAR(255)
                                """);
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS start_date DATE
                                """);
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS end_date DATE
                                """);
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS custom_application_fields TEXT
                                """);
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS custom_application_fields_id BIGINT
                                """);
                if (columnExists("jobs", "custom_application_fields_id")
                                && !isBigIntColumn("jobs", "custom_application_fields_id")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE jobs
                                        ALTER COLUMN custom_application_fields_id TYPE BIGINT
                                        USING CASE
                                                WHEN custom_application_fields_id::TEXT ~ '^[0-9]+$'
                                                        THEN custom_application_fields_id::TEXT::BIGINT
                                                ELSE NULL
                                        END
                                        """);
                }
                if (tableExists("jobs") && tableExists("application_forms")
                                && columnExists("jobs", "custom_application_fields_id")
                                && !foreignKeyExists("jobs", "custom_application_fields_id", "application_forms")) {
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET custom_application_fields_id = NULL
                                        WHERE custom_application_fields_id IS NOT NULL
                                          AND NOT EXISTS (
                                                SELECT 1
                                                FROM application_forms
                                                WHERE application_forms.id = jobs.custom_application_fields_id
                                          )
                                        """);
                        jdbcTemplate.execute("""
                                        ALTER TABLE jobs
                                        ADD CONSTRAINT fk_jobs_custom_application_fields_id
                                        FOREIGN KEY (custom_application_fields_id)
                                        REFERENCES application_forms(id)
                                        """);
                }
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS salary_range VARCHAR(255)
                                """);
                if (columnExists("jobs", "salary_range") && !isTextColumn("jobs", "salary_range")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE jobs
                                        ALTER COLUMN salary_range TYPE VARCHAR(255)
                                        USING salary_range::TEXT
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

        private void addStructuredJobRequirementColumns() {
                for (String columnDefinition : java.util.List.of(
                                "education_requirement VARCHAR(32)",
                                "education_requirement_mode VARCHAR(32)",
                                "education_degrees TEXT",
                                "no_degree_requirement TEXT",
                                "education_majors TEXT",
                                "preferred_institutions TEXT",
                                "minimum_years_experience INTEGER",
                                "experience_requirement TEXT",
                                "required_skills TEXT",
                                "tech_stack TEXT",
                                "english_required BOOLEAN",
                                "english_level VARCHAR(255)",
                                "english_skills TEXT",
                                "required_tools TEXT",
                                "technical_knowledge TEXT",
                                "job_desc_title VARCHAR(255)",
                                "requirements_title VARCHAR(255)",
                                "benefits_title VARCHAR(255)")) {
                        jdbcTemplate.execute("""
                                        ALTER TABLE IF EXISTS jobs
                                        ADD COLUMN IF NOT EXISTS %s
                                        """.formatted(columnDefinition));
                }
                if (tableExists("jobs")) {
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET education_requirement_mode = CASE
                                                WHEN education_requirement IS NULL
                                                     OR education_requirement = 'NOT_REQUIRED'
                                                        THEN 'NOT_REQUIRED'
                                                ELSE 'MINIMUM'
                                        END
                                        WHERE education_requirement_mode IS NULL
                                        """);
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET education_degrees = CASE education_requirement
                                                WHEN 'BACHELOR' THEN '["BACHELOR"]'
                                                WHEN 'MASTER' THEN '["MASTER"]'
                                                WHEN 'PHD' THEN '["PHD"]'
                                                ELSE '[]'
                                        END
                                        WHERE education_degrees IS NULL
                                        """);
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET job_desc_title = 'Job description'
                                        WHERE job_desc_title IS NULL OR TRIM(job_desc_title) = ''
                                        """);
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET requirements_title = 'Requirements'
                                        WHERE requirements_title IS NULL OR TRIM(requirements_title) = ''
                                        """);
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET benefits_title = 'Benefits'
                                        WHERE benefits_title IS NULL OR TRIM(benefits_title) = ''
                                        """);
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET english_level = CASE UPPER(TRIM(english_level))
                                                WHEN 'A1' THEN 'Beginner'
                                                WHEN 'A2' THEN 'Elementary'
                                                WHEN 'B1' THEN 'Intermediate'
                                                WHEN 'B2' THEN 'Upper-intermediate'
                                                WHEN 'C1' THEN 'Advanced'
                                                WHEN 'C2' THEN 'Proficient'
                                                ELSE english_level
                                        END
                                        WHERE english_level IS NOT NULL
                                        """);
                        jdbcTemplate.execute("""
                                        CREATE TABLE IF NOT EXISTS job_english_certificate_requirements (
                                                job_id BIGINT NOT NULL,
                                                display_order INTEGER NOT NULL,
                                                certificate_name VARCHAR(255) NOT NULL,
                                                minimum_score VARCHAR(255) NOT NULL,
                                                PRIMARY KEY (job_id, display_order),
                                                CONSTRAINT fk_job_english_certificate_requirement
                                                        FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
                                        )
                                        """);
                }
        }

        private void addApplicantCountPrivacySchema() {
                jdbcTemplate.execute("""
                                ALTER TABLE IF EXISTS jobs
                                ADD COLUMN IF NOT EXISTS published_at TIMESTAMP WITH TIME ZONE
                                """);
                if (tableExists("jobs")) {
                        if (isPostgreSql()) {
                                jdbcTemplate.execute("""
                                                UPDATE jobs
                                                SET published_at = posted_date::TIMESTAMP
                                                        AT TIME ZONE 'Asia/Ho_Chi_Minh'
                                                WHERE published_at IS NULL AND posted_date IS NOT NULL
                                                """);
                        } else {
                                jdbcTemplate.execute("""
                                                UPDATE jobs
                                                SET published_at = CAST(posted_date AS TIMESTAMP)
                                                WHERE published_at IS NULL AND posted_date IS NOT NULL
                                                """);
                        }
                        jdbcTemplate.execute("""
                                        UPDATE jobs
                                        SET published_at = CURRENT_TIMESTAMP
                                        WHERE published_at IS NULL
                                        """);
                }
                jdbcTemplate.execute("""
                                CREATE TABLE IF NOT EXISTS privacy_releases (
                                        id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                        release_key VARCHAR(512) NOT NULL,
                                        metric_name VARCHAR(128) NOT NULL,
                                        job_id BIGINT NOT NULL,
                                        audience VARCHAR(64) NOT NULL,
                                        release_window VARCHAR(64) NOT NULL,
                                        released_value BIGINT NOT NULL,
                                        created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
                                )
                                """);
                jdbcTemplate.execute("""
                                CREATE UNIQUE INDEX IF NOT EXISTS uk_privacy_release_key
                                ON privacy_releases(release_key)
                                """);
        }

        /**
         * Creates the generic language requirement tables and migrates the
         * deprecated English-only fields without deleting legacy data.
         */
        private void addLanguageRequirementSchema() {
                if (!tableExists("jobs")) {
                        return;
                }
                jdbcTemplate.execute("""
                                CREATE TABLE IF NOT EXISTS job_language_requirements (
                                        id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                        job_id BIGINT NOT NULL,
                                        display_order INTEGER NOT NULL,
                                        language_name VARCHAR(255) NOT NULL,
                                        proficiency_level VARCHAR(255) NOT NULL,
                                        skills TEXT NOT NULL,
                                        CONSTRAINT fk_job_language_requirement
                                                FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
                                )
                                """);
                jdbcTemplate.execute("""
                                CREATE UNIQUE INDEX IF NOT EXISTS uk_job_language_requirement_order
                                ON job_language_requirements(job_id, display_order)
                                """);
                jdbcTemplate.execute("""
                                CREATE TABLE IF NOT EXISTS job_language_certificate_requirements (
                                        language_requirement_id BIGINT NOT NULL,
                                        display_order INTEGER NOT NULL,
                                        certificate_name VARCHAR(255) NOT NULL,
                                        minimum_score VARCHAR(255) NOT NULL,
                                        PRIMARY KEY (language_requirement_id, display_order),
                                        CONSTRAINT fk_language_certificate_requirement
                                                FOREIGN KEY (language_requirement_id)
                                                REFERENCES job_language_requirements(id) ON DELETE CASCADE
                                )
                                """);

                if (columnExists("jobs", "english_required")
                                && columnExists("jobs", "english_level")
                                && columnExists("jobs", "english_skills")) {
                        jdbcTemplate.execute("""
                                        INSERT INTO job_language_requirements (
                                                job_id, display_order, language_name, proficiency_level, skills
                                        )
                                        SELECT id,
                                                COALESCE((
                                                        SELECT MAX(existing.display_order) + 1
                                                        FROM job_language_requirements existing
                                                        WHERE existing.job_id = jobs.id
                                                ), 0),
                                                'English',
                                                COALESCE(NULLIF(TRIM(english_level), ''), 'Not specified'),
                                                COALESCE(NULLIF(TRIM(english_skills), ''), '[]')
                                        FROM jobs
                                        WHERE english_required = TRUE
                                          AND NOT EXISTS (
                                                SELECT 1
                                                FROM job_language_requirements language_requirement
                                                WHERE language_requirement.job_id = jobs.id
                                                  AND LOWER(language_requirement.language_name) = 'english'
                                          )
                                        """);
                }

                if (tableExists("job_english_certificate_requirements")) {
                        jdbcTemplate.execute("""
                                        INSERT INTO job_language_certificate_requirements (
                                                language_requirement_id, display_order, certificate_name, minimum_score
                                        )
                                        SELECT language_requirement.id, certificate.display_order,
                                                certificate.certificate_name, certificate.minimum_score
                                        FROM job_english_certificate_requirements certificate
                                        JOIN job_language_requirements language_requirement
                                          ON language_requirement.job_id = certificate.job_id
                                         AND LOWER(language_requirement.language_name) = 'english'
                                        WHERE NOT EXISTS (
                                                SELECT 1
                                                FROM job_language_certificate_requirements migrated
                                                WHERE migrated.language_requirement_id = language_requirement.id
                                                  AND migrated.display_order = certificate.display_order
                                        )
                                        """);
                }
        }

        private boolean isPostgreSql() {
                return Boolean.TRUE.equals(jdbcTemplate.execute((ConnectionCallback<Boolean>) connection ->
                                connection.getMetaData().getDatabaseProductName().toLowerCase().contains("postgres")));
        }

        private boolean tableExists(String tableName) {
                return Boolean.TRUE.equals(jdbcTemplate.queryForObject("""
                                SELECT COUNT(*) > 0
                                FROM information_schema.tables
                                WHERE LOWER(table_name) = LOWER(?)
                                  AND table_schema = current_schema()
                                """, Boolean.class, tableName));
        }

        private boolean columnExists(String tableName, String columnName) {
                return Boolean.TRUE.equals(jdbcTemplate.queryForObject("""
                                SELECT COUNT(*) > 0
                                FROM information_schema.columns
                                WHERE LOWER(table_name) = LOWER(?)
                                  AND LOWER(column_name) = LOWER(?)
                                  AND table_schema = current_schema()
                                """, Boolean.class, tableName, columnName));
        }

        private boolean isTextColumn(String tableName, String columnName) {
                String dataType = jdbcTemplate.query("""
                                SELECT data_type
                                FROM information_schema.columns
                                WHERE LOWER(table_name) = LOWER(?)
                                  AND LOWER(column_name) = LOWER(?)
                                  AND table_schema = current_schema()
                                """, rs -> rs.next() ? rs.getString("data_type") : null, tableName, columnName);
                return dataType != null && (dataType.contains("character") || dataType.equalsIgnoreCase("text"));
        }

        private boolean isBigIntColumn(String tableName, String columnName) {
                String dataType = jdbcTemplate.query("""
                                SELECT data_type
                                FROM information_schema.columns
                                WHERE LOWER(table_name) = LOWER(?)
                                  AND LOWER(column_name) = LOWER(?)
                                  AND table_schema = current_schema()
                                """, rs -> rs.next() ? rs.getString("data_type") : null, tableName, columnName);
                return dataType != null && dataType.equalsIgnoreCase("bigint");
        }

        private boolean foreignKeyExists(String tableName, String columnName, String referencedTableName) {
                return Boolean.TRUE.equals(jdbcTemplate.execute((ConnectionCallback<Boolean>) connection -> {
                        String schema = connection.getSchema();
                        return foreignKeyExists(connection, connection.getCatalog(), schema, tableName, columnName,
                                        referencedTableName)
                                        || foreignKeyExists(connection, connection.getCatalog(), schema,
                                                        tableName.toUpperCase(), columnName,
                                                        referencedTableName.toUpperCase());
                }));
        }

        private boolean foreignKeyExists(Connection connection, String catalog, String schema, String tableName,
                        String columnName,
                        String referencedTableName) throws java.sql.SQLException {
                try (ResultSet resultSet = connection.getMetaData().getImportedKeys(catalog, schema, tableName)) {
                        while (resultSet.next()) {
                                if (columnName.equalsIgnoreCase(resultSet.getString("FKCOLUMN_NAME"))
                                                && referencedTableName
                                                                .equalsIgnoreCase(resultSet.getString("PKTABLE_NAME"))) {
                                        return true;
                                }
                        }
                }
                return false;
        }
}
