-- Seed data for the recommendation website PostgreSQL database.
-- Run this after the database schema has already been created.
--
-- All seeded users use this login password: secret123
-- Main seeded accounts:
--   admin@example.com / secret123
--   recruiter01@seed.local .. recruiter50@seed.local / secret123
--   applicant001@seed.local .. applicant200@seed.local / secret123

BEGIN;

ALTER TABLE IF EXISTS recruiters
    ADD COLUMN IF NOT EXISTS company_description TEXT,
    ADD COLUMN IF NOT EXISTS company_location VARCHAR(255),
    ADD COLUMN IF NOT EXISTS industry VARCHAR(255),
    ADD COLUMN IF NOT EXISTS website VARCHAR(2048),
    ADD COLUMN IF NOT EXISTS logo_url VARCHAR(2048),
    ADD COLUMN IF NOT EXISTS cover_image_url VARCHAR(2048),
    ADD COLUMN IF NOT EXISTS contact_email VARCHAR(255),
    ADD COLUMN IF NOT EXISTS contact_phone VARCHAR(255),
    ADD COLUMN IF NOT EXISTS tax_code VARCHAR(255),
    ADD COLUMN IF NOT EXISTS business_license VARCHAR(2048),
    ADD COLUMN IF NOT EXISTS company_type VARCHAR(255);

DELETE FROM permission_role
WHERE id BETWEEN 6001 AND 6100
   OR permission_id BETWEEN 5001 AND 5030;
DELETE FROM permissions WHERE id BETWEEN 5001 AND 5030;
DELETE FROM applicant_jobs WHERE id BETWEEN 4001 AND 4800;
DELETE FROM jobs WHERE id BETWEEN 3001 AND 3301;
DELETE FROM applicants WHERE id BETWEEN 2201 AND 2400;
DELETE FROM recruiters WHERE id BETWEEN 2101 AND 2150;
DELETE FROM users
WHERE id = 2001
   OR id BETWEEN 2101 AND 2150
   OR id BETWEEN 2201 AND 2400;
DELETE FROM cvs WHERE id BETWEEN 1001 AND 1200;
DELETE FROM certificates WHERE id BETWEEN 7001 AND 7200;
DELETE FROM educations WHERE id BETWEEN 8001 AND 8200;
DELETE FROM experiences WHERE id BETWEEN 9001 AND 9200;

INSERT INTO roles (id, role_name, description)
VALUES
    (1001, 'ADMIN', 'Administrator'),
    (1002, 'APPLICANT', 'Applicant'),
    (1003, 'RECRUITER', 'Recruiter')
ON CONFLICT (role_name) DO UPDATE
SET description = EXCLUDED.description;

INSERT INTO users (
    id,
    address,
    email,
    user_name,
    password,
    phone,
    refresh_token,
    role_id
)
VALUES (
    2001,
    'Ho Chi Minh City, Vietnam',
    'admin@example.com',
    'admin',
    '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
    '+84900000001',
    NULL,
    (SELECT id FROM roles WHERE role_name = 'ADMIN')
)
ON CONFLICT (id) DO UPDATE
SET
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    user_name = EXCLUDED.user_name,
    password = EXCLUDED.password,
    phone = EXCLUDED.phone,
    refresh_token = EXCLUDED.refresh_token,
    role_id = EXCLUDED.role_id;

WITH recruiter_seed AS (
    SELECT
        n,
        2100 + n AS id,
        (ARRAY['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Can Tho', 'Binh Duong'])[((n - 1) % 5) + 1] AS city,
        (ARRAY['Software Development', 'Artificial Intelligence', 'Cloud Infrastructure', 'E-commerce', 'FinTech', 'HealthTech', 'Education Technology'])[((n - 1) % 7) + 1] AS industry,
        (ARRAY['Nova', 'Green', 'Cloud', 'Bright', 'Astra', 'River', 'Summit', 'Pixel', 'Core', 'Next'])[((n - 1) % 10) + 1] AS prefix,
        (ARRAY['Labs', 'Systems', 'Works', 'Digital', 'Solutions'])[((n - 1) % 5) + 1] AS suffix
    FROM generate_series(1, 50) AS n
)
INSERT INTO users (
    id,
    address,
    email,
    user_name,
    password,
    phone,
    refresh_token,
    role_id
)
SELECT
    id,
    city || ', Vietnam',
    'recruiter' || lpad(n::text, 2, '0') || '@seed.local',
    'seed_recruiter_' || lpad(n::text, 2, '0'),
    '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
    '+84910' || lpad(n::text, 6, '0'),
    NULL,
    (SELECT id FROM roles WHERE role_name = 'RECRUITER')
FROM recruiter_seed
ON CONFLICT (id) DO UPDATE
SET
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    user_name = EXCLUDED.user_name,
    password = EXCLUDED.password,
    phone = EXCLUDED.phone,
    refresh_token = EXCLUDED.refresh_token,
    role_id = EXCLUDED.role_id;

WITH recruiter_seed AS (
    SELECT
        n,
        2100 + n AS id,
        (ARRAY['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Can Tho', 'Binh Duong'])[((n - 1) % 5) + 1] AS city,
        (ARRAY['Software Development', 'Artificial Intelligence', 'Cloud Infrastructure', 'E-commerce', 'FinTech', 'HealthTech', 'Education Technology'])[((n - 1) % 7) + 1] AS industry,
        (ARRAY['Nova', 'Green', 'Cloud', 'Bright', 'Astra', 'River', 'Summit', 'Pixel', 'Core', 'Next'])[((n - 1) % 10) + 1] AS prefix,
        (ARRAY['Labs', 'Systems', 'Works', 'Digital', 'Solutions'])[((n - 1) % 5) + 1] AS suffix
    FROM generate_series(1, 50) AS n
)
INSERT INTO recruiters (
    id,
    company_name,
    company_desc,
    location,
    company_size,
    industry_type,
    contact,
    avatar_url,
    established_date,
    company_description,
    company_location,
    industry,
    website,
    logo_url,
    cover_image_url,
    contact_email,
    contact_phone,
    tax_code,
    business_license,
    company_type
)
SELECT
    id,
    prefix || ' ' || suffix || ' ' || lpad(n::text, 2, '0'),
    prefix || ' ' || suffix || ' builds hiring-ready products for ' || lower(industry) || ' teams in Vietnam and Southeast Asia.',
    city,
    50 + (n * 17) % 950,
    industry,
    'recruiter' || lpad(n::text, 2, '0') || '@seed.local',
    'https://images.example.com/recruiters/company-' || lpad(n::text, 2, '0') || '.png',
    DATE '2010-01-01' + ((n * 97) % 5200),
    prefix || ' ' || suffix || ' builds hiring-ready products for ' || lower(industry) || ' teams in Vietnam and Southeast Asia.',
    city,
    industry,
    'https://company-' || lpad(n::text, 2, '0') || '.seed.local',
    'https://images.example.com/recruiters/company-' || lpad(n::text, 2, '0') || '.png',
    'https://images.example.com/recruiters/company-' || lpad(n::text, 2, '0') || '-cover.png',
    'recruiter' || lpad(n::text, 2, '0') || '@seed.local',
    '+84910' || lpad(n::text, 6, '0'),
    'TAX-SEED-' || lpad(n::text, 5, '0'),
    'https://files.example.com/licenses/recruiter-' || lpad(n::text, 2, '0') || '.pdf',
    CASE WHEN n % 2 = 0 THEN 'Product Company' ELSE 'Technology Services' END
FROM recruiter_seed
ON CONFLICT (id) DO UPDATE
SET
    company_name = EXCLUDED.company_name,
    company_desc = EXCLUDED.company_desc,
    location = EXCLUDED.location,
    company_size = EXCLUDED.company_size,
    industry_type = EXCLUDED.industry_type,
    contact = EXCLUDED.contact,
    avatar_url = EXCLUDED.avatar_url,
    established_date = EXCLUDED.established_date,
    company_description = EXCLUDED.company_description,
    company_location = EXCLUDED.company_location,
    industry = EXCLUDED.industry,
    website = EXCLUDED.website,
    logo_url = EXCLUDED.logo_url,
    cover_image_url = EXCLUDED.cover_image_url,
    contact_email = EXCLUDED.contact_email,
    contact_phone = EXCLUDED.contact_phone,
    tax_code = EXCLUDED.tax_code,
    business_license = EXCLUDED.business_license,
    company_type = EXCLUDED.company_type;

WITH applicant_seed AS (
    SELECT
        n,
        2200 + n AS user_id,
        1000 + n AS cv_id,
        (ARRAY['An', 'Binh', 'Chau', 'Dung', 'Giang', 'Hieu', 'Khanh', 'Lan', 'Minh', 'Ngoc', 'Phuc', 'Quang', 'Thao', 'Trang', 'Tuan', 'Vy'])[((n - 1) % 16) + 1] AS given_name,
        (ARRAY['Nguyen', 'Tran', 'Le', 'Pham', 'Hoang', 'Phan', 'Vu', 'Dang', 'Bui', 'Do'])[((n - 1) % 10) + 1] AS family_name,
        (ARRAY['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Can Tho', 'Hue', 'Nha Trang'])[((n - 1) % 6) + 1] AS city,
        (ARRAY['Java', 'Spring Boot', 'React', 'TypeScript', 'PostgreSQL', 'Docker', 'Python', 'Machine Learning', 'AWS', 'Testing'])[((n - 1) % 10) + 1] AS primary_skill,
        (ARRAY['Backend Engineer', 'Frontend Developer', 'Data Analyst', 'QA Engineer', 'DevOps Engineer', 'Product Analyst'])[((n - 1) % 6) + 1] AS target_role
    FROM generate_series(1, 200) AS n
)
INSERT INTO certificates (id, name, score, provider)
SELECT
    7000 + n,
    (ARRAY['AWS Cloud Practitioner', 'Google Data Analytics', 'Meta Front-End Developer', 'Oracle Java Foundations', 'ISTQB Foundation', 'Microsoft Azure Fundamentals'])[((n - 1) % 6) + 1],
    CASE WHEN n % 5 = 0 THEN NULL ELSE (70 + (n % 30))::text END,
    (ARRAY['AWS', 'Google', 'Meta', 'Oracle', 'ISTQB', 'Microsoft'])[((n - 1) % 6) + 1]
FROM applicant_seed
ON CONFLICT (id) DO UPDATE
SET
    name = EXCLUDED.name,
    score = EXCLUDED.score,
    provider = EXCLUDED.provider;

WITH applicant_seed AS (
    SELECT
        n,
        (ARRAY['Computer Science', 'Software Engineering', 'Information Systems', 'Data Science', 'Cybersecurity'])[((n - 1) % 5) + 1] AS major
    FROM generate_series(1, 200) AS n
)
INSERT INTO educations (id, name, major, degree, start_date, end_date)
SELECT
    8000 + n,
    (ARRAY['VNUHCM - University of Science', 'Hanoi University of Science and Technology', 'Da Nang University of Technology', 'FPT University', 'Ton Duc Thang University'])[((n - 1) % 5) + 1],
    major,
    (ARRAY['BSc', 'MSc', 'Associate', 'Other'])[((n - 1) % 4) + 1],
    DATE '2015-09-01' + ((n % 6) * 365),
    DATE '2019-06-15' + ((n % 6) * 365)
FROM applicant_seed
ON CONFLICT (id) DO UPDATE
SET
    name = EXCLUDED.name,
    major = EXCLUDED.major,
    degree = EXCLUDED.degree,
    start_date = EXCLUDED.start_date,
    end_date = EXCLUDED.end_date;

WITH applicant_seed AS (
    SELECT
        n,
        (ARRAY['Backend Engineer', 'Frontend Developer', 'Data Analyst', 'QA Engineer', 'DevOps Engineer', 'Product Analyst'])[((n - 1) % 6) + 1] AS target_role,
        (ARRAY['Java', 'Spring Boot', 'React', 'TypeScript', 'PostgreSQL', 'Docker', 'Python', 'Machine Learning', 'AWS', 'Testing'])[((n - 1) % 10) + 1] AS primary_skill
    FROM generate_series(1, 200) AS n
)
INSERT INTO experiences (id, company_name, job_title, field, contribution, start_date, end_date, is_present)
SELECT
    9000 + n,
    (ARRAY['Acme Digital', 'Blue Ocean Tech', 'CloudBridge', 'Future Retail', 'Mekong Analytics', 'Saigon Software'])[((n - 1) % 6) + 1],
    target_role,
    primary_skill,
    'Delivered production features, collaborated with cross-functional teams, and improved maintainability using ' || primary_skill || '.',
    DATE '2020-01-01' + ((n % 48) * 30),
    CASE WHEN n % 4 = 0 THEN NULL ELSE DATE '2022-01-01' + ((n % 36) * 30) END,
    n % 4 = 0
FROM applicant_seed
ON CONFLICT (id) DO UPDATE
SET
    company_name = EXCLUDED.company_name,
    job_title = EXCLUDED.job_title,
    field = EXCLUDED.field,
    contribution = EXCLUDED.contribution,
    start_date = EXCLUDED.start_date,
    end_date = EXCLUDED.end_date,
    is_present = EXCLUDED.is_present;

WITH applicant_seed AS (
    SELECT
        n,
        1000 + n AS cv_id,
        (ARRAY['An', 'Binh', 'Chau', 'Dung', 'Giang', 'Hieu', 'Khanh', 'Lan', 'Minh', 'Ngoc', 'Phuc', 'Quang', 'Thao', 'Trang', 'Tuan', 'Vy'])[((n - 1) % 16) + 1] AS given_name,
        (ARRAY['Nguyen', 'Tran', 'Le', 'Pham', 'Hoang', 'Phan', 'Vu', 'Dang', 'Bui', 'Do'])[((n - 1) % 10) + 1] AS family_name,
        (ARRAY['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Can Tho', 'Hue', 'Nha Trang'])[((n - 1) % 6) + 1] AS city,
        (ARRAY['Java', 'Spring Boot', 'React', 'TypeScript', 'PostgreSQL', 'Docker', 'Python', 'Machine Learning', 'AWS', 'Testing'])[((n - 1) % 10) + 1] AS primary_skill,
        (ARRAY['Backend Engineer', 'Frontend Developer', 'Data Analyst', 'QA Engineer', 'DevOps Engineer', 'Product Analyst'])[((n - 1) % 6) + 1] AS target_role
    FROM generate_series(1, 200) AS n
)
INSERT INTO cvs (
    id,
    full_name,
    address,
    phone,
    objective,
    skills,
    cv_file_url,
    certificate_id,
    education_id,
    experience_id
)
SELECT
    cv_id,
    family_name || ' ' || given_name || ' ' || lpad(n::text, 3, '0'),
    city || ', Vietnam',
    '+84912' || lpad(n::text, 6, '0'),
    'Grow as a ' || target_role || ' while building reliable products with measurable business impact.',
    jsonb_build_array(primary_skill, 'Git', 'REST API', 'Agile teamwork')::text,
    'https://files.example.com/cvs/applicant-' || lpad(n::text, 3, '0') || '.pdf',
    7000 + n,
    8000 + n,
    9000 + n
FROM applicant_seed
ON CONFLICT (id) DO UPDATE
SET
    full_name = EXCLUDED.full_name,
    address = EXCLUDED.address,
    phone = EXCLUDED.phone,
    objective = EXCLUDED.objective,
    skills = EXCLUDED.skills,
    cv_file_url = EXCLUDED.cv_file_url,
    certificate_id = EXCLUDED.certificate_id,
    education_id = EXCLUDED.education_id,
    experience_id = EXCLUDED.experience_id;

WITH applicant_seed AS (
    SELECT
        n,
        2200 + n AS user_id,
        (ARRAY['An', 'Binh', 'Chau', 'Dung', 'Giang', 'Hieu', 'Khanh', 'Lan', 'Minh', 'Ngoc', 'Phuc', 'Quang', 'Thao', 'Trang', 'Tuan', 'Vy'])[((n - 1) % 16) + 1] AS given_name,
        (ARRAY['Nguyen', 'Tran', 'Le', 'Pham', 'Hoang', 'Phan', 'Vu', 'Dang', 'Bui', 'Do'])[((n - 1) % 10) + 1] AS family_name,
        (ARRAY['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Can Tho', 'Hue', 'Nha Trang'])[((n - 1) % 6) + 1] AS city
    FROM generate_series(1, 200) AS n
)
INSERT INTO users (
    id,
    address,
    email,
    user_name,
    password,
    phone,
    refresh_token,
    role_id
)
SELECT
    user_id,
    city || ', Vietnam',
    'applicant' || lpad(n::text, 3, '0') || '@seed.local',
    'seed_applicant_' || lpad(n::text, 3, '0'),
    '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
    '+84912' || lpad(n::text, 6, '0'),
    NULL,
    (SELECT id FROM roles WHERE role_name = 'APPLICANT')
FROM applicant_seed
ON CONFLICT (id) DO UPDATE
SET
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    user_name = EXCLUDED.user_name,
    password = EXCLUDED.password,
    phone = EXCLUDED.phone,
    refresh_token = EXCLUDED.refresh_token,
    role_id = EXCLUDED.role_id;

WITH applicant_seed AS (
    SELECT
        n,
        2200 + n AS user_id,
        1000 + n AS cv_id,
        (ARRAY['An', 'Binh', 'Chau', 'Dung', 'Giang', 'Hieu', 'Khanh', 'Lan', 'Minh', 'Ngoc', 'Phuc', 'Quang', 'Thao', 'Trang', 'Tuan', 'Vy'])[((n - 1) % 16) + 1] AS given_name,
        (ARRAY['Nguyen', 'Tran', 'Le', 'Pham', 'Hoang', 'Phan', 'Vu', 'Dang', 'Bui', 'Do'])[((n - 1) % 10) + 1] AS family_name
    FROM generate_series(1, 200) AS n
)
INSERT INTO applicants (
    id,
    status,
    gender,
    full_name,
    profile_visible_to_recruiters,
    show_full_name,
    show_contact_info,
    show_address,
    show_cv_file,
    show_objective,
    show_skills,
    show_experience,
    show_education,
    show_certifications,
    cv_id
)
SELECT
    user_id,
    CASE WHEN n % 5 = 0 THEN 1 ELSE 0 END,
    (n - 1) % 3,
    family_name || ' ' || given_name || ' ' || lpad(n::text, 3, '0'),
    n % 11 <> 0,
    n % 3 = 0,
    n % 4 = 0,
    n % 5 = 0,
    n % 6 = 0,
    true,
    true,
    n % 7 <> 0,
    true,
    n % 8 <> 0,
    cv_id
FROM applicant_seed
ON CONFLICT (id) DO UPDATE
SET
    status = EXCLUDED.status,
    gender = EXCLUDED.gender,
    full_name = EXCLUDED.full_name,
    profile_visible_to_recruiters = EXCLUDED.profile_visible_to_recruiters,
    show_full_name = EXCLUDED.show_full_name,
    show_contact_info = EXCLUDED.show_contact_info,
    show_address = EXCLUDED.show_address,
    show_cv_file = EXCLUDED.show_cv_file,
    show_objective = EXCLUDED.show_objective,
    show_skills = EXCLUDED.show_skills,
    show_experience = EXCLUDED.show_experience,
    show_education = EXCLUDED.show_education,
    show_certifications = EXCLUDED.show_certifications,
    cv_id = EXCLUDED.cv_id;

WITH job_seed AS (
    SELECT
        row_number() OVER (ORDER BY recruiter.n, slot.seq) + 3000 AS id,
        recruiter.n AS recruiter_number,
        2100 + recruiter.n AS recruiter_id,
        slot.seq,
        (ARRAY['Backend Engineer', 'Frontend Developer', 'Full Stack Developer', 'Data Analyst', 'Machine Learning Engineer', 'QA Automation Engineer', 'Cloud DevOps Engineer', 'Product Analyst', 'Mobile Developer', 'Security Engineer'])[((recruiter.n + slot.seq - 2) % 10) + 1] AS title,
        (ARRAY['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Remote', 'Hybrid'])[((recruiter.n + slot.seq - 2) % 5) + 1] AS city,
        (ARRAY['Full-time', 'Part-time', 'Contract', 'Internship'])[((recruiter.n + slot.seq - 2) % 4) + 1] AS job_type,
        (ARRAY['Java', 'React', 'TypeScript', 'Python', 'PostgreSQL', 'Docker', 'Kubernetes', 'Machine Learning', 'Testing', 'AWS'])[((recruiter.n + slot.seq - 2) % 10) + 1] AS skill
    FROM generate_series(1, 50) AS recruiter(n)
    CROSS JOIN LATERAL generate_series(1, 5 + (recruiter.n % 3)) AS slot(seq)
)
INSERT INTO jobs (
    id,
    applying_deadline,
    benefits,
    job_title,
    job_desc,
    requirement,
    location,
    salary_range,
    job_type,
    posted_date,
    yoe,
    custom_application_fields_id,
    recruiter_id
)
SELECT
    id,
    DATE '2026-08-15' + (((id - 3001) % 45)::int),
    jsonb_build_array('Health insurance', 'Annual bonus', 'Learning budget', 'Hybrid working options')::text,
    title,
    'Work with recruiter #' || lpad(recruiter_number::text, 2, '0') || ' to deliver production features for real users.',
    jsonb_build_array(skill, 'REST API', 'Git', 'Clear communication')::text,
    city,
    800 + (((id - 3001) % 12) * 250),
    job_type,
    DATE '2026-06-01' + (((id - 3001) % 30)::int),
    ((id - 3001) % 6)::int,
    NULL,
    recruiter_id
FROM job_seed
ON CONFLICT (id) DO UPDATE
SET
    applying_deadline = EXCLUDED.applying_deadline,
    benefits = EXCLUDED.benefits,
    job_title = EXCLUDED.job_title,
    job_desc = EXCLUDED.job_desc,
    requirement = EXCLUDED.requirement,
    location = EXCLUDED.location,
    salary_range = EXCLUDED.salary_range,
    job_type = EXCLUDED.job_type,
    posted_date = EXCLUDED.posted_date,
    yoe = EXCLUDED.yoe,
    custom_application_fields_id = EXCLUDED.custom_application_fields_id,
    recruiter_id = EXCLUDED.recruiter_id;

WITH applicant_actions AS (
    SELECT
        applicant.n AS applicant_number,
        2200 + applicant.n AS applicant_id,
        action.slot,
        action.action_type,
        3001 + (((applicant.n * 7) + action.slot * 19) % 301) AS job_id
    FROM generate_series(1, 200) AS applicant(n)
    CROSS JOIN (
        VALUES
            (1, 'APPLIED'),
            (2, 'SAVED'),
            (3, 'SAVED')
    ) AS action(slot, action_type)
)
INSERT INTO applicant_jobs (
    id,
    applicant_id,
    job_id,
    action_type
)
SELECT
    row_number() OVER (ORDER BY applicant_number, slot) + 4000,
    applicant_id,
    job_id,
    action_type
FROM applicant_actions
ON CONFLICT (id) DO UPDATE
SET
    applicant_id = EXCLUDED.applicant_id,
    job_id = EXCLUDED.job_id,
    action_type = EXCLUDED.action_type;

INSERT INTO permissions (id, endpoint, method, description)
VALUES
    (5001, '/api/v1/home', 'GET', 'View home endpoint'),
    (5002, '/api/v1/browse-jobs', 'GET', 'Browse all jobs'),
    (5003, '/api/v1/browse-jobs/{jobId}', 'GET', 'View job detail'),
    (5004, '/api/v1/browse-jobs/applicants/{jobId}', 'GET', 'View applicant count for a job'),
    (5005, '/api/v1/browse-jobs/applicants/{jobId}/list', 'GET', 'View applicants for a job'),
    (5006, '/api/v1/auth', 'POST', 'Login'),
    (5007, '/api/v1/registrations/applicant', 'POST', 'Register applicant'),
    (5008, '/api/v1/registrations/recruiters', 'POST', 'Register recruiter'),
    (5009, '/api/v1/applicants', 'GET', 'Admin view applicants'),
    (5010, '/api/v1/applicants/{applicantId}', 'GET', 'View applicant profile'),
    (5011, '/api/v1/applicants/{applicantId}', 'PUT', 'Update applicant profile'),
    (5012, '/api/v1/applicants/{applicantId}/privacy', 'PUT', 'Update applicant privacy'),
    (5013, '/api/v1/applicants/saved-jobs', 'GET', 'View saved jobs'),
    (5014, '/api/v1/applicants/applied-jobs', 'GET', 'View applied jobs'),
    (5015, '/api/v1/applicants/save/job', 'POST', 'Save a job'),
    (5016, '/api/v1/applicants/apply/job', 'POST', 'Apply to a job'),
    (5017, '/api/v1/applicants/upload-cv/{applicantId}', 'POST', 'Upload applicant CV'),
    (5018, '/api/v1/applicants/{applicantId}/cv-file', 'DELETE', 'Delete uploaded CV file'),
    (5019, '/api/v1/applicants/{applicantId}/analyze-cv', 'POST', 'Analyze applicant CV'),
    (5020, '/api/v1/applicants/{applicantId}/match/{jobId}', 'POST', 'Match applicant CV to job'),
    (5021, '/api/v1/recruiters', 'GET', 'Admin view recruiters'),
    (5022, '/api/v1/recruiters/{recruiterId}', 'GET', 'View recruiter profile'),
    (5023, '/api/v1/recruiters/{recruiterId}', 'PUT', 'Update recruiter profile'),
    (5024, '/api/v1/recruiters/jobs/{recruiterId}', 'GET', 'View recruiter jobs'),
    (5025, '/api/v1/recruiters/jobs/{recruiterId}', 'POST', 'Create recruiter job'),
    (5026, '/api/v1/recruiters/jobs/{recruiterId}/{jobId}', 'GET', 'View recruiter job'),
    (5027, '/api/v1/recruiters/jobs/{recruiterId}/{jobId}', 'PUT', 'Update recruiter job'),
    (5028, '/api/v1/recruiters/jobs/{recruiterId}/{jobId}/applicants', 'GET', 'View applicants for recruiter job')
ON CONFLICT (id) DO UPDATE
SET
    endpoint = EXCLUDED.endpoint,
    method = EXCLUDED.method,
    description = EXCLUDED.description;

INSERT INTO permission_role (id, permission_id, role_id)
SELECT
    row_number() OVER (ORDER BY permission_id, role_name) + 6000,
    permission_id,
    (SELECT id FROM roles WHERE roles.role_name = grants.role_name)
FROM (
    VALUES
        (5001, 'ADMIN'), (5001, 'APPLICANT'), (5001, 'RECRUITER'),
        (5002, 'ADMIN'), (5002, 'APPLICANT'), (5002, 'RECRUITER'),
        (5003, 'ADMIN'), (5003, 'APPLICANT'), (5003, 'RECRUITER'),
        (5004, 'RECRUITER'),
        (5005, 'RECRUITER'),
        (5009, 'ADMIN'),
        (5010, 'ADMIN'), (5010, 'APPLICANT'), (5010, 'RECRUITER'),
        (5011, 'APPLICANT'),
        (5012, 'APPLICANT'),
        (5013, 'APPLICANT'),
        (5014, 'APPLICANT'),
        (5015, 'APPLICANT'),
        (5016, 'APPLICANT'),
        (5017, 'APPLICANT'),
        (5018, 'APPLICANT'),
        (5019, 'APPLICANT'),
        (5020, 'APPLICANT'),
        (5021, 'ADMIN'),
        (5022, 'ADMIN'), (5022, 'RECRUITER'),
        (5023, 'RECRUITER'),
        (5024, 'RECRUITER'),
        (5025, 'RECRUITER'),
        (5026, 'RECRUITER'),
        (5027, 'RECRUITER'),
        (5028, 'RECRUITER')
) AS grants(permission_id, role_name)
ON CONFLICT (id) DO UPDATE
SET
    permission_id = EXCLUDED.permission_id,
    role_id = EXCLUDED.role_id;

SELECT setval(pg_get_serial_sequence('roles', 'id'), GREATEST((SELECT MAX(id) FROM roles), 1), true);
SELECT setval(pg_get_serial_sequence('certificates', 'id'), GREATEST((SELECT MAX(id) FROM certificates), 1), true);
SELECT setval(pg_get_serial_sequence('educations', 'id'), GREATEST((SELECT MAX(id) FROM educations), 1), true);
SELECT setval(pg_get_serial_sequence('experiences', 'id'), GREATEST((SELECT MAX(id) FROM experiences), 1), true);
SELECT setval(pg_get_serial_sequence('cvs', 'id'), GREATEST((SELECT MAX(id) FROM cvs), 1), true);
SELECT setval(pg_get_serial_sequence('users', 'id'), GREATEST((SELECT MAX(id) FROM users), 1), true);
SELECT setval(pg_get_serial_sequence('jobs', 'id'), GREATEST((SELECT MAX(id) FROM jobs), 1), true);
SELECT setval(pg_get_serial_sequence('applicant_jobs', 'id'), GREATEST((SELECT MAX(id) FROM applicant_jobs), 1), true);
SELECT setval(pg_get_serial_sequence('permissions', 'id'), GREATEST((SELECT MAX(id) FROM permissions), 1), true);
SELECT setval(pg_get_serial_sequence('permission_role', 'id'), GREATEST((SELECT MAX(id) FROM permission_role), 1), true);

COMMIT;
