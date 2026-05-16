-- Seed data for the recommendation website PostgreSQL database.
-- Run this after the database schema has already been created.
--
-- All seeded users use this login password: secret123

BEGIN;

INSERT INTO roles (id, role_name, description)
VALUES
    (1001, 'ADMIN', 'Administrator'),
    (1002, 'APPLICANT', 'Applicant'),
    (1003, 'RECRUITER', 'Recruiter')
ON CONFLICT (role_name) DO UPDATE
SET description = EXCLUDED.description;

INSERT INTO cvs (
    id,
    full_name,
    address,
    phone,
    objective,
    skills,
    experience,
    education,
    certifications
)
VALUES
    (
        1001,
        'Nguyen Van An',
        'District 1, Ho Chi Minh City',
        '+84901234501',
        'Build scalable backend systems for customer-facing products.',
        'Java, Spring Boot, PostgreSQL, Docker, REST API',
        '2 years building internal APIs and reporting services.',
        'BSc Computer Science, HCMUS',
        'AWS Certified Cloud Practitioner'
    ),
    (
        1002,
        'Tran Thi Binh',
        'Cau Giay, Hanoi',
        '+84901234502',
        'Create polished and accessible frontend experiences.',
        'React, TypeScript, TailwindCSS, Testing Library',
        '3 years delivering React dashboards and design system components.',
        'BSc Software Engineering, HCMUS',
        'Google UX Design Certificate'
    ),
    (
        1003,
        'Le Minh Chau',
        'Hai Chau, Da Nang',
        '+84901234503',
        'Apply data and backend engineering to recommendation systems.',
        'Python, SQL, Java, Machine Learning, Spring Boot',
        'Built recommendation prototypes and batch data pipelines.',
        'BSc Data Science, HCMUS',
        'TensorFlow Developer Certificate'
    )
ON CONFLICT (id) DO UPDATE
SET
    full_name = EXCLUDED.full_name,
    address = EXCLUDED.address,
    phone = EXCLUDED.phone,
    objective = EXCLUDED.objective,
    skills = EXCLUDED.skills,
    experience = EXCLUDED.experience,
    education = EXCLUDED.education,
    certifications = EXCLUDED.certifications;

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
VALUES
    (
        2001,
        'Ho Chi Minh City',
        'admin@example.com',
        'admin',
        '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
        '+84900000001',
        NULL,
        (SELECT id FROM roles WHERE role_name = 'ADMIN')
    ),
    (
        2101,
        'District 3, Ho Chi Minh City',
        'hr@technova.example.com',
        'technova_hr',
        '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
        '+84900000101',
        NULL,
        (SELECT id FROM roles WHERE role_name = 'RECRUITER')
    ),
    (
        2102,
        'Nam Tu Liem, Hanoi',
        'talent@greenlabs.example.com',
        'greenlabs_talent',
        '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
        '+84900000102',
        NULL,
        (SELECT id FROM roles WHERE role_name = 'RECRUITER')
    ),
    (
        2103,
        'Hai Chau, Da Nang',
        'jobs@cloudbridge.example.com',
        'cloudbridge_jobs',
        '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
        '+84900000103',
        NULL,
        (SELECT id FROM roles WHERE role_name = 'RECRUITER')
    ),
    (
        2201,
        'District 1, Ho Chi Minh City',
        'nguyen.an@example.com',
        'nguyen_an',
        '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
        '+84901234501',
        NULL,
        (SELECT id FROM roles WHERE role_name = 'APPLICANT')
    ),
    (
        2202,
        'Cau Giay, Hanoi',
        'tran.binh@example.com',
        'tran_binh',
        '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
        '+84901234502',
        NULL,
        (SELECT id FROM roles WHERE role_name = 'APPLICANT')
    ),
    (
        2203,
        'Hai Chau, Da Nang',
        'le.chau@example.com',
        'le_chau',
        '$2a$10$dPeD6d66Fyg5wkpS9SZNA.Jj.bJgb1qllauWbS7ijC1URoKshRj2i',
        '+84901234503',
        NULL,
        (SELECT id FROM roles WHERE role_name = 'APPLICANT')
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

INSERT INTO recruiters (
    id,
    company_name,
    company_description,
    company_location,
    company_size,
    industry,
    website,
    logo_url,
    contact_email,
    contact_phone,
    tax_code,
    business_license,
    established_date,
    company_type
)
VALUES
    (
        2101,
        'TechNova Software',
        'TechNova builds enterprise software for finance, retail, and logistics teams.',
        'Ho Chi Minh City',
        '101-300',
        'Software Development',
        'https://technova.example.com',
        'https://technova.example.com/logo.png',
        'hr@technova.example.com',
        '+84900000101',
        'TAX-TN-1001',
        'BL-TN-1001',
        '2018-05-20',
        'Private Company'
    ),
    (
        2102,
        'GreenLabs AI',
        'GreenLabs AI creates analytics and machine learning tools for sustainable operations.',
        'Hanoi',
        '51-100',
        'Artificial Intelligence',
        'https://greenlabs.example.com',
        'https://greenlabs.example.com/logo.png',
        'talent@greenlabs.example.com',
        '+84900000102',
        'TAX-GL-1002',
        'BL-GL-1002',
        '2020-09-12',
        'Startup'
    ),
    (
        2103,
        'CloudBridge Solutions',
        'CloudBridge helps companies modernize infrastructure and cloud-native platforms.',
        'Da Nang',
        '301-500',
        'Cloud Infrastructure',
        'https://cloudbridge.example.com',
        'https://cloudbridge.example.com/logo.png',
        'jobs@cloudbridge.example.com',
        '+84900000103',
        'TAX-CB-1003',
        'BL-CB-1003',
        '2015-03-02',
        'Joint Stock Company'
    )
ON CONFLICT (id) DO UPDATE
SET
    company_name = EXCLUDED.company_name,
    company_description = EXCLUDED.company_description,
    company_location = EXCLUDED.company_location,
    company_size = EXCLUDED.company_size,
    industry = EXCLUDED.industry,
    website = EXCLUDED.website,
    logo_url = EXCLUDED.logo_url,
    contact_email = EXCLUDED.contact_email,
    contact_phone = EXCLUDED.contact_phone,
    tax_code = EXCLUDED.tax_code,
    business_license = EXCLUDED.business_license,
    established_date = EXCLUDED.established_date,
    company_type = EXCLUDED.company_type;

INSERT INTO applicants (
    id,
    status,
    gender,
    full_name,
    cv_id
)
VALUES
    (2201, 0, 0, 'Nguyen Van An', 1001),
    (2202, 0, 1, 'Tran Thi Binh', 1002),
    (2203, 1, 0, 'Le Minh Chau', 1003)
ON CONFLICT (id) DO UPDATE
SET
    status = EXCLUDED.status,
    gender = EXCLUDED.gender,
    full_name = EXCLUDED.full_name,
    cv_id = EXCLUDED.cv_id;

INSERT INTO job_descriptions (
    id,
    job_title,
    about_company,
    job_description,
    requirements,
    benefits,
    location,
    salary_range,
    job_type,
    experience_level,
    industry,
    posted_date,
    application_deadline,
    start_date,
    end_date,
    recruiter_id
)
VALUES
    (
        3001,
        'Backend Engineer',
        'TechNova Software builds robust business platforms.',
        'Design, build, and maintain Spring Boot APIs for customer-facing services.',
        '2+ years with Java, Spring Boot, REST APIs, PostgreSQL, and Git.',
        'Hybrid work, annual bonus, training budget, health insurance.',
        'Ho Chi Minh City',
        '1800-2600 USD',
        'Full-time',
        'Mid-level',
        'Software Development',
        DATE '2026-05-01',
        DATE '2026-06-15',
        DATE '2026-07-01',
        NULL,
        2101
    ),
    (
        3002,
        'Frontend Developer',
        'TechNova Software builds robust business platforms.',
        'Develop responsive React and TypeScript interfaces for internal SaaS products.',
        'Strong React, TypeScript, TailwindCSS, component testing, and API integration.',
        'Flexible hours, laptop allowance, mentoring, health insurance.',
        'Remote',
        '1500-2300 USD',
        'Full-time',
        'Mid-level',
        'Software Development',
        DATE '2026-05-03',
        DATE '2026-06-20',
        DATE '2026-07-10',
        NULL,
        2101
    ),
    (
        3003,
        'Machine Learning Engineer',
        'GreenLabs AI creates practical analytics and AI products.',
        'Build recommendation, forecasting, and classification models for product teams.',
        'Python, SQL, model evaluation, feature engineering, and deployment experience.',
        'Research time, conference budget, flexible working policy.',
        'Hanoi',
        '2200-3200 USD',
        'Full-time',
        'Senior',
        'Artificial Intelligence',
        DATE '2026-05-05',
        DATE '2026-06-25',
        DATE '2026-07-15',
        NULL,
        2102
    ),
    (
        3004,
        'Cloud DevOps Engineer',
        'CloudBridge Solutions modernizes infrastructure for growing companies.',
        'Operate Kubernetes workloads, CI/CD pipelines, monitoring, and cloud automation.',
        'Linux, Docker, Kubernetes, Terraform, CI/CD, and AWS or GCP experience.',
        'Certification support, on-call allowance, health insurance.',
        'Da Nang',
        '2000-3000 USD',
        'Full-time',
        'Senior',
        'Cloud Infrastructure',
        DATE '2026-05-07',
        DATE '2026-07-01',
        DATE '2026-07-20',
        NULL,
        2103
    ),
    (
        3005,
        'Data Analyst Intern',
        'GreenLabs AI creates practical analytics and AI products.',
        'Prepare dashboards, clean datasets, and support analytics reporting.',
        'SQL basics, spreadsheet skills, curiosity, and clear communication.',
        'Mentorship, internship allowance, conversion opportunity.',
        'Hanoi',
        '300-500 USD',
        'Internship',
        'Entry-level',
        'Data Analytics',
        DATE '2026-05-10',
        DATE '2026-06-10',
        DATE '2026-06-24',
        DATE '2026-12-24',
        2102
    )
ON CONFLICT (id) DO UPDATE
SET
    job_title = EXCLUDED.job_title,
    about_company = EXCLUDED.about_company,
    job_description = EXCLUDED.job_description,
    requirements = EXCLUDED.requirements,
    benefits = EXCLUDED.benefits,
    location = EXCLUDED.location,
    salary_range = EXCLUDED.salary_range,
    job_type = EXCLUDED.job_type,
    experience_level = EXCLUDED.experience_level,
    industry = EXCLUDED.industry,
    posted_date = EXCLUDED.posted_date,
    application_deadline = EXCLUDED.application_deadline,
    start_date = EXCLUDED.start_date,
    end_date = EXCLUDED.end_date,
    recruiter_id = EXCLUDED.recruiter_id;

INSERT INTO applicant_job_descriptions (
    id,
    applicant_id,
    job_description_id
)
VALUES
    (4001, 2201, 3001),
    (4002, 2201, 3004),
    (4003, 2202, 3002),
    (4004, 2203, 3003),
    (4005, 2203, 3005)
ON CONFLICT (id) DO UPDATE
SET
    applicant_id = EXCLUDED.applicant_id,
    job_description_id = EXCLUDED.job_description_id;

INSERT INTO permissions (id, endpoint, method, description)
VALUES
    (5001, '/api/v1/home', 'GET', 'View home endpoint'),
    (5002, '/api/v1/browse-jobs', 'GET', 'Browse all jobs'),
    (5003, '/api/v1/browse-jobs/{jobId}', 'GET', 'View job detail'),
    (5004, '/api/v1/browse-jobs/applicants/{jobId}', 'GET', 'View applicant count for a job'),
    (5005, '/api/v1/auth', 'POST', 'Login'),
    (5006, '/api/v1/registrations/applicant', 'POST', 'Register applicant'),
    (5007, '/api/v1/registrations/recruiters', 'POST', 'Register recruiter'),
    (5008, '/api/v1/applicants', 'GET', 'Admin view applicants'),
    (5009, '/api/v1/applicants/{applicantId}', 'GET', 'View applicant profile'),
    (5010, '/api/v1/applicants/{applicantId}', 'PUT', 'Update applicant profile'),
    (5011, '/api/v1/applicants/saved-jobs', 'GET', 'View saved jobs'),
    (5012, '/api/v1/applicants/save/job', 'POST', 'Save a job'),
    (5013, '/api/v1/applicants/upload-cv/{applicantId}', 'POST', 'Upload applicant CV'),
    (5014, '/api/v1/recruiters', 'GET', 'Admin view recruiters'),
    (5015, '/api/v1/recruiters/{recruiterId}', 'GET', 'View recruiter profile'),
    (5016, '/api/v1/recruiters/jobs/{recruiterId}', 'GET', 'View recruiter jobs'),
    (5017, '/api/v1/recruiters/jobs/{recruiterId}', 'POST', 'Create recruiter job'),
    (5018, '/api/v1/recruiters/jobs/{recruiterId}/{jobId}', 'PUT', 'Update recruiter job')
ON CONFLICT (id) DO UPDATE
SET
    endpoint = EXCLUDED.endpoint,
    method = EXCLUDED.method,
    description = EXCLUDED.description;

INSERT INTO permission_role (id, permission_id, role_id)
VALUES
    (6001, 5001, (SELECT id FROM roles WHERE role_name = 'ADMIN')),
    (6002, 5001, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6003, 5001, (SELECT id FROM roles WHERE role_name = 'RECRUITER')),
    (6004, 5002, (SELECT id FROM roles WHERE role_name = 'ADMIN')),
    (6005, 5002, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6006, 5002, (SELECT id FROM roles WHERE role_name = 'RECRUITER')),
    (6007, 5003, (SELECT id FROM roles WHERE role_name = 'ADMIN')),
    (6008, 5003, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6009, 5003, (SELECT id FROM roles WHERE role_name = 'RECRUITER')),
    (6010, 5004, (SELECT id FROM roles WHERE role_name = 'RECRUITER')),
    (6011, 5008, (SELECT id FROM roles WHERE role_name = 'ADMIN')),
    (6012, 5009, (SELECT id FROM roles WHERE role_name = 'ADMIN')),
    (6013, 5009, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6014, 5010, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6015, 5011, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6016, 5012, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6017, 5013, (SELECT id FROM roles WHERE role_name = 'APPLICANT')),
    (6018, 5014, (SELECT id FROM roles WHERE role_name = 'ADMIN')),
    (6019, 5015, (SELECT id FROM roles WHERE role_name = 'ADMIN')),
    (6020, 5015, (SELECT id FROM roles WHERE role_name = 'RECRUITER')),
    (6021, 5016, (SELECT id FROM roles WHERE role_name = 'RECRUITER')),
    (6022, 5017, (SELECT id FROM roles WHERE role_name = 'RECRUITER')),
    (6023, 5018, (SELECT id FROM roles WHERE role_name = 'RECRUITER'))
ON CONFLICT (id) DO UPDATE
SET
    permission_id = EXCLUDED.permission_id,
    role_id = EXCLUDED.role_id;

SELECT setval(pg_get_serial_sequence('roles', 'id'), GREATEST((SELECT MAX(id) FROM roles), 1), true);
SELECT setval(pg_get_serial_sequence('cvs', 'id'), GREATEST((SELECT MAX(id) FROM cvs), 1), true);
SELECT setval(pg_get_serial_sequence('users', 'id'), GREATEST((SELECT MAX(id) FROM users), 1), true);
SELECT setval(pg_get_serial_sequence('job_descriptions', 'id'), GREATEST((SELECT MAX(id) FROM job_descriptions), 1), true);
SELECT setval(pg_get_serial_sequence('applicant_job_descriptions', 'id'), GREATEST((SELECT MAX(id) FROM applicant_job_descriptions), 1), true);
SELECT setval(pg_get_serial_sequence('permissions', 'id'), GREATEST((SELECT MAX(id) FROM permissions), 1), true);
SELECT setval(pg_get_serial_sequence('permission_role', 'id'), GREATEST((SELECT MAX(id) FROM permission_role), 1), true);

COMMIT;
