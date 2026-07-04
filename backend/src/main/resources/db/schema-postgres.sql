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
--     ADD COLUMN IF NOT EXISTS requirement TEXT;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS yoe INTEGER;

-- ALTER TABLE IF EXISTS jobs
--     ADD COLUMN IF NOT EXISTS custom_application_fields_id BIGINT;
