-- ALTER TABLE IF EXISTS cvs
--     ADD COLUMN IF NOT EXISTS cv_file_url VARCHAR(2048);

-- ALTER TABLE IF EXISTS cvs
--     ALTER COLUMN full_name DROP NOT NULL;

-- ALTER TABLE IF EXISTS applicants
--     ALTER COLUMN full_name DROP NOT NULL;

-- ALTER TABLE IF EXISTS applicant_job_descriptions
--     RENAME TO applicant_jobs;

-- ALTER TABLE IF EXISTS applicant_jobs
--     ADD COLUMN IF NOT EXISTS job_id BIGINT;

-- ALTER TABLE IF EXISTS applicant_jobs
--     ADD COLUMN IF NOT EXISTS action_type VARCHAR(255) NOT NULL DEFAULT 'APPLIED';

-- ALTER TABLE IF EXISTS recruiters
--     ADD COLUMN IF NOT EXISTS company_desc TEXT;

-- ALTER TABLE IF EXISTS recruiters
--     ADD COLUMN IF NOT EXISTS location VARCHAR(255);

-- ALTER TABLE IF EXISTS recruiters
--     ADD COLUMN IF NOT EXISTS industry_type VARCHAR(255);

-- ALTER TABLE IF EXISTS recruiters
--     ADD COLUMN IF NOT EXISTS contact VARCHAR(255);

-- ALTER TABLE IF EXISTS recruiters
--     ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(2048);

-- ALTER TABLE IF EXISTS application_forms
--     ADD COLUMN IF NOT EXISTS field_value VARCHAR(255);

-- ALTER TABLE IF EXISTS job_descriptions
--     RENAME TO jobs;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS job_desc TEXT;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS requirements TEXT;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS yoe VARCHAR(255);

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS salary_range VARCHAR(255);

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS about_company TEXT;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS experience_level VARCHAR(255);

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS industry VARCHAR(255);

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS start_date DATE;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS end_date DATE;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS custom_application_fields TEXT;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS custom_application_fields_id BIGINT;

-- ALTER TABLE IF EXISTS applicants
--     ADD COLUMN IF NOT EXISTS profile_visible_to_other_applicants BOOLEAN NOT NULL DEFAULT FALSE;

-- ALTER TABLE IF EXISTS users
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS users
--     ADD COLUMN IF NOT EXISTS created_at DATE;

-- ALTER TABLE IF EXISTS users
--     ADD COLUMN IF NOT EXISTS updated_at DATE;

-- ALTER TABLE IF EXISTS users
--     ADD COLUMN IF NOT EXISTS deleted_at DATE;

ALTER TABLE IF EXISTS users
    ALTER COLUMN email DROP NOT NULL;

ALTER TABLE IF EXISTS applicants
    DROP COLUMN IF EXISTS profile_visible_to_recruiters;

-- Structured job requirements allow the matching service to compare each CV
-- section against an explicit recruiter requirement instead of parsing prose.
ALTER TABLE IF EXISTS jobs
    ADD COLUMN IF NOT EXISTS education_requirement VARCHAR(32),
    ADD COLUMN IF NOT EXISTS education_requirement_mode VARCHAR(32),
    ADD COLUMN IF NOT EXISTS education_degrees TEXT,
    ADD COLUMN IF NOT EXISTS no_degree_requirement TEXT,
    ADD COLUMN IF NOT EXISTS education_majors TEXT,
    ADD COLUMN IF NOT EXISTS preferred_institutions TEXT,
    ADD COLUMN IF NOT EXISTS minimum_years_experience INTEGER,
    ADD COLUMN IF NOT EXISTS experience_requirement TEXT,
    ADD COLUMN IF NOT EXISTS required_skills TEXT,
    ADD COLUMN IF NOT EXISTS tech_stack TEXT,
    ADD COLUMN IF NOT EXISTS english_required BOOLEAN,
    ADD COLUMN IF NOT EXISTS english_level VARCHAR(255),
    ADD COLUMN IF NOT EXISTS english_skills TEXT,
    ADD COLUMN IF NOT EXISTS required_tools TEXT,
    ADD COLUMN IF NOT EXISTS technical_knowledge TEXT,
    ADD COLUMN IF NOT EXISTS job_desc_title VARCHAR(255),
    ADD COLUMN IF NOT EXISTS requirements_title VARCHAR(255),
    ADD COLUMN IF NOT EXISTS benefits_title VARCHAR(255);

UPDATE jobs
SET education_requirement_mode = CASE
        WHEN education_requirement IS NULL OR education_requirement = 'NOT_REQUIRED'
            THEN 'NOT_REQUIRED'
        ELSE 'MINIMUM'
    END
WHERE education_requirement_mode IS NULL;

UPDATE jobs
SET education_degrees = CASE education_requirement
        WHEN 'BACHELOR' THEN '["BACHELOR"]'
        WHEN 'MASTER' THEN '["MASTER"]'
        WHEN 'PHD' THEN '["PHD"]'
        ELSE '[]'
    END
WHERE education_degrees IS NULL;

UPDATE jobs SET job_desc_title = 'Job description'
WHERE job_desc_title IS NULL OR BTRIM(job_desc_title) = '';
UPDATE jobs SET requirements_title = 'Requirements'
WHERE requirements_title IS NULL OR BTRIM(requirements_title) = '';
UPDATE jobs SET benefits_title = 'Benefits'
WHERE benefits_title IS NULL OR BTRIM(benefits_title) = '';

UPDATE jobs
SET english_level = CASE UPPER(BTRIM(english_level))
        WHEN 'A1' THEN 'Beginner'
        WHEN 'A2' THEN 'Elementary'
        WHEN 'B1' THEN 'Intermediate'
        WHEN 'B2' THEN 'Upper-intermediate'
        WHEN 'C1' THEN 'Advanced'
        WHEN 'C2' THEN 'Proficient'
        ELSE english_level
    END
WHERE english_level IS NOT NULL;

CREATE TABLE IF NOT EXISTS job_english_certificate_requirements (
    job_id BIGINT NOT NULL,
    display_order INTEGER NOT NULL,
    certificate_name VARCHAR(255) NOT NULL,
    minimum_score VARCHAR(255) NOT NULL,
    PRIMARY KEY (job_id, display_order),
    CONSTRAINT fk_job_english_certificate_requirement
        FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
);

-- ALTER TABLE IF EXISTS applicant_jobs
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN,
--     ADD COLUMN IF NOT EXISTS cover_letter TEXT,
--     ADD COLUMN IF NOT EXISTS portfolio_url VARCHAR(2048),
--     ADD COLUMN IF NOT EXISTS application_answers TEXT;

-- ALTER TABLE IF EXISTS recruiters
--     ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(2048),
--     ADD COLUMN IF NOT EXISTS logo_url VARCHAR(2048),
--     ADD COLUMN IF NOT EXISTS cover_image_url VARCHAR(2048),
--     ADD COLUMN IF NOT EXISTS website VARCHAR(2048),
--     ADD COLUMN IF NOT EXISTS contact_email VARCHAR(255),
--     ADD COLUMN IF NOT EXISTS contact_phone VARCHAR(255),
--     ADD COLUMN IF NOT EXISTS tax_code VARCHAR(255),
--     ADD COLUMN IF NOT EXISTS business_license VARCHAR(2048),
--     ADD COLUMN IF NOT EXISTS company_type VARCHAR(255);

-- UPDATE recruiters
-- SET logo_url = avatar_url
-- WHERE logo_url IS NULL AND avatar_url IS NOT NULL;

-- ALTER TABLE IF EXISTS application_forms
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS certificates
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS certificates
--     ALTER COLUMN certificate_name TYPE TEXT,
--     ALTER COLUMN point TYPE TEXT,
--     ALTER COLUMN organisation_name TYPE TEXT;

-- ALTER TABLE IF EXISTS cvs
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS educations
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS educations
--     ALTER COLUMN degree TYPE TEXT,
--     ALTER COLUMN major TYPE TEXT,
--     ALTER COLUMN name TYPE TEXT,
--     ALTER COLUMN period TYPE TEXT;

-- ALTER TABLE IF EXISTS experiences
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN,
--     ADD COLUMN IF NOT EXISTS yoe VARCHAR(255),
--     ADD COLUMN IF NOT EXISTS salary_range VARCHAR(255),
--     ADD COLUMN IF NOT EXISTS about_company TEXT,
--     ADD COLUMN IF NOT EXISTS requirements TEXT,
--     ADD COLUMN IF NOT EXISTS experience_level VARCHAR(255),
--     ADD COLUMN IF NOT EXISTS industry VARCHAR(255),
--     ADD COLUMN IF NOT EXISTS start_date DATE,
--     ADD COLUMN IF NOT EXISTS end_date DATE,
--     ADD COLUMN IF NOT EXISTS custom_application_fields TEXT,
--     ADD COLUMN IF NOT EXISTS custom_application_fields_id BIGINT;

-- ALTER TABLE IF EXISTS jobs
--     ALTER COLUMN custom_application_fields_id TYPE BIGINT
--     USING CASE
--         WHEN custom_application_fields_id::TEXT ~ '^[0-9]+$'
--             THEN custom_application_fields_id::TEXT::BIGINT
--         ELSE NULL
--     END;

-- UPDATE jobs
-- SET custom_application_fields_id = NULL
-- WHERE custom_application_fields_id IS NOT NULL
--   AND NOT EXISTS (
--     SELECT 1
--     FROM application_forms
--     WHERE application_forms.id = jobs.custom_application_fields_id
--   );

-- DO $$
-- BEGIN
--     IF EXISTS (
--         SELECT 1
--         FROM information_schema.tables
--         WHERE table_schema = current_schema()
--           AND table_name = 'jobs'
--     )
--     AND EXISTS (
--         SELECT 1
--         FROM information_schema.tables
--         WHERE table_schema = current_schema()
--           AND table_name = 'application_forms'
--     )
--     AND NOT EXISTS (
--         SELECT 1
--         FROM information_schema.table_constraints tc
--         JOIN information_schema.key_column_usage kcu
--             ON tc.constraint_name = kcu.constraint_name
--             AND tc.table_schema = kcu.table_schema
--         JOIN information_schema.constraint_column_usage ccu
--             ON tc.constraint_name = ccu.constraint_name
--             AND tc.table_schema = ccu.table_schema
--         WHERE tc.constraint_type = 'FOREIGN KEY'
--           AND tc.table_schema = current_schema()
--           AND tc.table_name = 'jobs'
--           AND kcu.column_name = 'custom_application_fields_id'
--           AND ccu.table_name = 'application_forms'
--           AND ccu.column_name = 'id'
--     ) THEN
--         ALTER TABLE jobs
--             ADD CONSTRAINT fk_jobs_custom_application_fields_id
--             FOREIGN KEY (custom_application_fields_id)
--             REFERENCES application_forms(id);
--     END IF;
-- END $$;

-- ALTER TABLE IF EXISTS permission_role
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS permissions
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- ALTER TABLE IF EXISTS roles
--     ADD COLUMN IF NOT EXISTS created_at DATE,
--     ADD COLUMN IF NOT EXISTS updated_at DATE,
--     ADD COLUMN IF NOT EXISTS deleted_at DATE,
--     ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN;

-- CREATE TABLE IF NOT EXISTS privacy_releases (
--     id BIGSERIAL PRIMARY KEY,
--     release_key VARCHAR(512) NOT NULL,
--     metric_name VARCHAR(128) NOT NULL,
--     job_id BIGINT NOT NULL,
--     audience VARCHAR(64) NOT NULL,
--     release_window VARCHAR(64) NOT NULL,
--     released_value BIGINT NOT NULL,
--     created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     CONSTRAINT uk_privacy_release_key UNIQUE (release_key)
-- );
