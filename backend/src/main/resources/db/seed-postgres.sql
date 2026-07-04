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
    certifications,
    cv_file_url
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
        'AWS Certified Cloud Practitioner',
        'https://files.example.com/cv/nguyen-van-an.pdf'
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
        'Google UX Design Certificate',
        'https://files.example.com/cv/tran-thi-binh.pdf'
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
        'TensorFlow Developer Certificate',
        'https://files.example.com/cv/le-minh-chau.pdf'
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
    certifications = EXCLUDED.certifications,
    cv_file_url = EXCLUDED.cv_file_url;

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
    cover_image_url,
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
        'https://technova.example.com/cover.png',
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
        'https://greenlabs.example.com/cover.png',
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
        'https://cloudbridge.example.com/cover.png',
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
    cover_image_url = EXCLUDED.cover_image_url,
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

-- Realistic CV-matching JDs imported from ai/data/jds.json (jd_01..jd_05).
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
        3006,
        '.NET Developer',
        'Bosch Global Software Technologies (BGSV) is a 100% owned subsidiary of Robert Bosch GmbH, a leading global supplier of technology and services. BGSV is Bosch''s first software development center in Southeast Asia (since 2010 at Etown 2, HCMC) with over 4,000 associates, offering end-to-end Engineering, IT, and Business Solutions that connect sensors, software, and services.',
        'We are looking for a skilled .NET Developer with strong experience in C# and modern software engineering practices, responsible for designing, developing, and maintaining scalable applications and APIs with a focus on clean architecture and cloud-based solutions on Azure. Design, develop, and maintain applications using C# and .NET technologies. Build and maintain RESTful APIs for scalable and secure systems. Apply CQRS (Command Query Responsibility Segregation) in system design where appropriate. Implement Domain-Driven Design (DDD) principles for complex business domains. Ensure code quality by applying SOLID principles and clean code practices. Collaborate with cross-functional teams. Deploy and manage applications on Microsoft Azure. Participate in code reviews and contribute to continuous improvement.',
        '3+ years of experience. Strong experience in C# and general software engineering. Solid understanding of RESTful API design and implementation. Experience with the CQRS architecture pattern. Good knowledge of Domain-Driven Design (DDD). Strong understanding of SOLID principles. Experience working with Microsoft Azure (App Services, Functions, or similar). Very good English communication skills. Nice to have: microservices architecture, DevOps practices and CI/CD pipelines, containerization (Docker, Kubernetes).',
        'Working in one of the Best Places to Work in Vietnam and Top 30 of the most innovative companies. Dynamic and fast-growing global, English-speaking environment with global projects and onsite opportunities worldwide. Diverse training programs. 13th-month salary bonus plus attractive performance bonus and annual performance appraisal. 100% offered salary and mandatory social insurance during the 2-month probation. 15++ days annual leave plus 1 birthday leave. Premium health insurance for employee and 2 family members. Flexible working time and model. Lunch and parking allowance. Company sports activities (football, badminton, yoga, aerobic, team building).',
        'Ho Chi Minh City',
        'Negotiable (13th-month + performance bonus)',
        'Full-time (Flexible/Hybrid)',
        '3+ years',
        'Information Technology / Software (Backend, Cloud)',
        DATE '2026-06-01',
        DATE '2026-07-15',
        DATE '2026-08-01',
        NULL,
        2101
    ),
    (
        3007,
        'Database Developer',
        'A technology company building large-scale, real-world projects with extensive data systems, offering a professional and friendly working environment with training and career growth toward Database Administrator, Data Engineer, or System Analyst roles.',
        'We are looking for a Database Developer who is passionate about data and eager to grow in database system development, working closely with development teams, reporting teams, and data operations support. Participate in database analysis and design for business systems. Design, develop, modify, and optimize stored procedures, functions, triggers, indexes, and other database objects according to system requirements. Write SQL queries, generate reports, and support departments with data extraction for management and operational purposes. Collaborate with team members to troubleshoot issues and optimize system performance. Support data updates and adjustments for clients upon request. Participate in ETL processes and data integration from multiple data sources.',
        'Bachelor''s or College degree in Information Technology, Computer Science, Telecommunications, or related fields. 1 to 2 years of experience working with database management systems. Experience with databases such as SQL Server, PostgreSQL, and MongoDB. Knowledge and hands-on experience with ETL processes. Good teamwork skills, logical thinking, responsibility, and willingness to learn. Experience with Big Data or high-traffic systems is a plus.',
        'Negotiable and competitive salary based on experience and qualifications. Professional and friendly working environment with opportunities for training and skill development. Opportunity to participate in large-scale, real-world projects with extensive data systems. Full benefits and welfare policies in accordance with company regulations. Career growth opportunities toward Database Administrator, Data Engineer, or System Analyst.',
        'Ho Chi Minh City',
        'Negotiable (competitive)',
        'Full-time',
        '1+ years',
        'Information Technology / Software (Data, Databases)',
        DATE '2026-06-01',
        DATE '2026-07-15',
        DATE '2026-08-01',
        NULL,
        2102
    ),
    (
        3008,
        'Business Analyst',
        'Hitachi Digital Services is part of Hitachi''s multinational team operating in over 130 countries, a dynamic and fast-growing global enterprise offering participation in the full Software Development Life Cycle, comprehensive soft-skills training, and advanced career development overseas including the US, UK, and Japan.',
        'Join our delivery team as the vital link between business ambitions and technical execution. Collaborate with stakeholders to elicit high-precision requirements, shape technical solutions, and oversee the lifecycle from discovery through to successful deployment. Lead workshops to capture needs, mediate conflicting stakeholder priorities, and negotiate project scope boundaries. Author precise Software Specifications (SRS) and System Interface Specifications (ICD), defining communication protocols for seamless cross-system data exchange. Analyze external interfaces, constraints, and non-functional requirements within complex system architectures. Identify process logic gaps, propose cost-effective solutions, and perform rigorous impact analysis on system baseline changes. Act as a translator between technical constraints and business value. Facilitate User Acceptance Testing (UAT) and maintain end-to-end requirement traceability. Develop UI/UX mockups for HMI or web applications to validate functional flows and system interfaces.',
        '1+ years of proven experience as an IT Business Analyst. Fluent English, able to conduct interviews and presentations in 100% English, and skilled at steering clients toward feasible technical paths. Strong background in technical writing, elicitation, and system interface analysis. Familiarity with software communication standards is preferred. Solid grasp of SDLC frameworks (Waterfall, Agile, or Scrum). Degree in IT, Computer Science, or a related technical field. Acute attention to detail, proactive self-management, and advanced logical and critical thinking.',
        'Work with the multinational team of Hitachi in over 130 countries. Participate in the full Software Development Life Cycle and comprehensive soft-skills training. Competitive and attractive compensation with allowances for English and Japanese language certifications, transportation and meal subsidies, 13th salary and bonus, premium health insurance, annual health check and company trip, flexible working hours, and career development overseas (US, UK, Japan).',
        'Ho Chi Minh City',
        'Competitive (13th salary + bonus)',
        'Full-time (Flexible hours)',
        '1+ years',
        'Information Technology / Software (Business Analysis)',
        DATE '2026-06-01',
        DATE '2026-07-15',
        DATE '2026-08-01',
        NULL,
        2103
    ),
    (
        3009,
        'Data Scientist',
        'M_Service operates a high-traffic, big-scale super app, passionate about new technologies and focused on its own product rather than outsourcing, with a dynamic, flexible, and international working environment and a strong, experienced team.',
        'Design and implement statistical models, machine learning algorithms, and data pipelines to solve business problems. Collaborate with Product and Business to define the Machine Learning product, focused on recommendation systems, ranking algorithms, and classification models, or Fraud/Risk management and Financial Services. Collect, clean, and prepare data at large scale for modeling. Analyze large datasets to surface actionable insights and translate them into production-ready features. Experiment with new modeling approaches and feature strategies to push performance. Participate in productionizing Machine Learning models for live production. Design and conduct A/B tests and analyze the results. Build pipelines for continuously validating and updating models. Communicate findings and model outcomes clearly to technical and non-technical stakeholders, driving data-driven decisions.',
        '3+ years working experience with 2 years hands-on with Machine Learning, or 2+ years with a PhD degree. Good understanding of the mathematical foundations of Machine Learning algorithms. Practical experience applying Machine Learning in recommendation systems, ranking, classification, or clustering problems (personalization, search ranking, content filtering, customer segmentation, or user behavior modeling). Strong analytical mindset to extract business insights from data. Solid experience in feature engineering. A builder who brings prototypes to production, with strong product ownership and collaboration skills. Familiar with using genAI in analytics, modeling, and coding. Experience with large-scale ranking or retrieval systems is a plus.',
        'Competitive compensation package with performance-based bonus and insurance package. 13th month salary bonus and yearly performance bonus. 14 paid days off per year. Premium health care insurance. Great allowances (lunch, parking, birthday, happy hours). Salary review at least once per year based on performance. Outing and team-building activities (company trip, soccer, English club, running club). Friendly, dynamic, and flexible working environment with an experienced, strong team.',
        'Ho Chi Minh City',
        'Competitive (13th month + performance bonus)',
        'Full-time (Flexible)',
        '3+ years',
        'Information Technology / Software (Data Science, Machine Learning)',
        DATE '2026-06-01',
        DATE '2026-07-15',
        DATE '2026-08-01',
        NULL,
        2102
    ),
    (
        3010,
        'Junior Data Analyst',
        'Vexere is Vietnam''s leading technology company in travel and transportation, and the largest online bus ticketing platform with over 2,000 transport partners and 3,000+ domestic and international routes, expanded to airlines, trains, and vehicle rentals. The BI (Business Intelligence) team works in a high-tech environment powered by Google Cloud with one of the largest data lakes in Vietnam, analyzing data from 30M+ users and millions of daily transactions.',
        'Transform raw data into clear, actionable insights that guide day-to-day business decisions. Collaborate with senior analysts and cross-functional teams to collect and clean data, explore trends, and design dashboards that highlight key performance metrics. Understand business requirements and translate them into data-driven solutions. Prepare data collection plans, clean and organize data to ensure accuracy and consistency. Support senior analysts in conducting data analysis to uncover trends and insights. Utilize BI tools (Looker Studio, Tableau, Power BI) to create dashboards and reports to monitor business performance. Learn and apply best practices in data visualization, reporting, and problem-solving.',
        'Around 1 year of experience in data analysis; talented freshers with less than one year of experience are welcome. Familiarity with visualization tools (Looker/Data Studio, Tableau, Power BI). Strong knowledge of SQL (BigQuery, Microsoft SQL Server, PostgreSQL). Strong analytical skills with the ability to collect, organize, analyze, and disseminate large amounts of information with attention to detail and accuracy. Proficiency in queries, report writing, and presenting findings. Analytical mind with a problem-solving aptitude. Teamwork spirit and proactive mindset. BSc/BA in Computer Science, Engineering, Mathematics, Economics, Information Management, or Statistics is appreciated.',
        'Competitive salary based on capabilities plus quarterly KPI performance bonus; salary review twice a year; clear promotion path. Full social, health, and unemployment insurance; 12 annual leave days/year (+1 every 3 years); annual health check; discounted bus tickets; personal loan and salary advance; referral bonus; personal development training allowance up to 18 million VND/year. Hybrid working model; working hours 8:30-18:00 Monday to Friday plus Saturday mornings. Company sports clubs, monthly team-building budget, company trips and year-end parties.',
        'Ho Chi Minh City',
        'Negotiable (competitive + quarterly KPI bonus)',
        'Full-time (Hybrid)',
        'Entry level (freshers welcome)',
        'Travel & Transportation Technology',
        DATE '2026-06-01',
        DATE '2026-07-15',
        DATE '2026-08-01',
        NULL,
        2101
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
    job_description_id,
    action_type
)
VALUES
    (4001, 2201, 3001, 'APPLIED'),
    (4002, 2201, 3004, 'SAVED'),
    (4003, 2202, 3002, 'APPLIED'),
    (4004, 2203, 3003, 'APPLIED'),
    (4005, 2203, 3005, 'SAVED')
ON CONFLICT (id) DO UPDATE
SET
    applicant_id = EXCLUDED.applicant_id,
    job_description_id = EXCLUDED.job_description_id,
    action_type = EXCLUDED.action_type;

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
