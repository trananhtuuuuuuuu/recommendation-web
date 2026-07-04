-- -- Detailed job seed data following a full job-posting structure.
-- -- Run after roles, users, and recruiters exist.

-- INSERT INTO jobs (id, applying_deadline, benefits, job_title, job_desc, requirement, location, salary_range, job_type, posted_date, yoe, custom_application_fields_id, recruiter_id) VALUES
--     (70001, DATE '2026-02-15', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- TechLabs is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Ho Chi Minh City', 2100, 'Full-time', DATE '2026-01-01', 1, NULL, 10001),
--     (70002, DATE '2026-03-19', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- TechLabs is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hanoi', 2200, 'Full-time', DATE '2026-02-02', 2, NULL, 10001),
--     (70003, DATE '2026-04-17', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- TechLabs is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-03-03', 4, NULL, 10001),
--     (70004, DATE '2026-05-19', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- TechLabs is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Can Tho', 4000, 'Part-time', DATE '2026-04-04', 6, NULL, 10001),
--     (70005, DATE '2026-06-19', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- TechLabs is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hai Phong', 2300, 'Contract', DATE '2026-05-05', 1, NULL, 10001),
--     (70006, DATE '2026-03-21', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- GreenSystems is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hanoi', 2200, 'Full-time', DATE '2026-02-04', 2, NULL, 10002),
--     (70007, DATE '2026-04-19', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- GreenSystems is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-03-05', 4, NULL, 10002),
--     (70008, DATE '2026-05-21', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- GreenSystems is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Can Tho', 4000, 'Part-time', DATE '2026-04-06', 6, NULL, 10002),
--     (70009, DATE '2026-06-21', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- GreenSystems is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hai Phong', 2300, 'Contract', DATE '2026-05-07', 1, NULL, 10002),
--     (70010, DATE '2026-07-23', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- GreenSystems is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Bien Hoa', 500, 'Internship', DATE '2026-06-08', 0, NULL, 10002),
--     (70011, DATE '2026-02-23', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- GreenSystems is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hue', 2500, 'Remote', DATE '2026-01-09', 4, NULL, 10002),
--     (70012, DATE '2026-04-21', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- CloudHub is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-03-07', 4, NULL, 10003),
--     (70013, DATE '2026-05-23', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- CloudHub is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Can Tho', 4000, 'Part-time', DATE '2026-04-08', 6, NULL, 10003),
--     (70014, DATE '2026-06-23', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- CloudHub is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hai Phong', 2300, 'Contract', DATE '2026-05-09', 1, NULL, 10003),
--     (70015, DATE '2026-07-25', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- CloudHub is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Bien Hoa', 500, 'Internship', DATE '2026-06-10', 0, NULL, 10003),
--     (70016, DATE '2026-02-25', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- CloudHub is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hue', 2500, 'Remote', DATE '2026-01-11', 4, NULL, 10003),
--     (70017, DATE '2026-03-29', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- CloudHub is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Nha Trang', 3200, 'Full-time', DATE '2026-02-12', 6, NULL, 10003),
--     (70018, DATE '2026-04-27', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- CloudHub is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Vung Tau', 2100, 'Full-time', DATE '2026-03-13', 1, NULL, 10003),
--     (70019, DATE '2026-05-25', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- BrightStudio is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Can Tho', 4000, 'Part-time', DATE '2026-04-10', 6, NULL, 10004),
--     (70020, DATE '2026-06-25', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- BrightStudio is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Hai Phong', 2300, 'Contract', DATE '2026-05-11', 1, NULL, 10004),
--     (70021, DATE '2026-07-27', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- BrightStudio is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Bien Hoa', 500, 'Internship', DATE '2026-06-12', 0, NULL, 10004),
--     (70022, DATE '2026-02-27', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- BrightStudio is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Hue', 2500, 'Remote', DATE '2026-01-13', 4, NULL, 10004),
--     (70023, DATE '2026-03-31', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- BrightStudio is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Nha Trang', 3200, 'Full-time', DATE '2026-02-14', 6, NULL, 10004),
--     (70024, DATE '2026-06-27', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- SmartVentures is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Hai Phong', 2300, 'Contract', DATE '2026-05-13', 1, NULL, 10005),
--     (70025, DATE '2026-07-29', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- SmartVentures is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Bien Hoa', 500, 'Internship', DATE '2026-06-14', 0, NULL, 10005),
--     (70026, DATE '2026-03-01', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- SmartVentures is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Hue', 2500, 'Remote', DATE '2026-01-15', 4, NULL, 10005),
--     (70027, DATE '2026-04-02', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- SmartVentures is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Nha Trang', 3200, 'Full-time', DATE '2026-02-16', 6, NULL, 10005),
--     (70028, DATE '2026-05-01', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- SmartVentures is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Vung Tau', 2100, 'Full-time', DATE '2026-03-17', 1, NULL, 10005),
--     (70029, DATE '2026-06-02', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- SmartVentures is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-04-18', 2, NULL, 10005),
--     (70030, DATE '2026-07-31', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- NextSoftware is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Bien Hoa', 500, 'Internship', DATE '2026-06-16', 0, NULL, 10006),
--     (70031, DATE '2026-03-03', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- NextSoftware is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hue', 2500, 'Remote', DATE '2026-01-17', 4, NULL, 10006),
--     (70032, DATE '2026-04-04', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- NextSoftware is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Nha Trang', 3200, 'Full-time', DATE '2026-02-18', 6, NULL, 10006),
--     (70033, DATE '2026-05-03', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- NextSoftware is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Vung Tau', 2100, 'Full-time', DATE '2026-03-19', 1, NULL, 10006),
--     (70034, DATE '2026-06-04', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- NextSoftware is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-04-20', 2, NULL, 10006),
--     (70035, DATE '2026-07-05', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- NextSoftware is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Part-time', DATE '2026-05-21', 4, NULL, 10006),
--     (70036, DATE '2026-08-06', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- NextSoftware is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hanoi', 4000, 'Contract', DATE '2026-06-22', 6, NULL, 10006),
--     (70037, DATE '2026-03-05', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- BlueWorks is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Hue', 2500, 'Remote', DATE '2026-01-19', 4, NULL, 10007),
--     (70038, DATE '2026-04-06', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- BlueWorks is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Nha Trang', 3200, 'Full-time', DATE '2026-02-20', 6, NULL, 10007),
--     (70039, DATE '2026-05-05', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- BlueWorks is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Vung Tau', 2100, 'Full-time', DATE '2026-03-21', 1, NULL, 10007),
--     (70040, DATE '2026-06-06', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- BlueWorks is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-04-22', 2, NULL, 10007),
--     (70041, DATE '2026-07-07', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- BlueWorks is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Part-time', DATE '2026-05-23', 4, NULL, 10007),
--     (70042, DATE '2026-04-08', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- PrimeDynamics is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Nha Trang', 3200, 'Full-time', DATE '2026-02-22', 6, NULL, 10008),
--     (70043, DATE '2026-05-07', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- PrimeDynamics is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Vung Tau', 2100, 'Full-time', DATE '2026-03-23', 1, NULL, 10008),
--     (70044, DATE '2026-06-08', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- PrimeDynamics is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-04-24', 2, NULL, 10008),
--     (70045, DATE '2026-07-09', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- PrimeDynamics is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Part-time', DATE '2026-05-25', 4, NULL, 10008),
--     (70046, DATE '2026-08-10', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- PrimeDynamics is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hanoi', 4000, 'Contract', DATE '2026-06-26', 6, NULL, 10008),
--     (70047, DATE '2026-03-13', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- PrimeDynamics is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Da Nang', 500, 'Internship', DATE '2026-01-27', 0, NULL, 10008),
--     (70048, DATE '2026-05-09', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- NovaAnalytics is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Vung Tau', 2100, 'Full-time', DATE '2026-03-25', 1, NULL, 10009),
--     (70049, DATE '2026-06-10', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- NovaAnalytics is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-04-26', 2, NULL, 10009),
--     (70050, DATE '2026-07-11', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- NovaAnalytics is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Part-time', DATE '2026-05-27', 4, NULL, 10009),
--     (70051, DATE '2026-07-16', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- NovaAnalytics is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hanoi', 4000, 'Contract', DATE '2026-06-01', 6, NULL, 10009),
--     (70052, DATE '2026-02-16', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- NovaAnalytics is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Da Nang', 500, 'Internship', DATE '2026-01-02', 0, NULL, 10009),
--     (70053, DATE '2026-03-20', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- NovaAnalytics is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Can Tho', 2300, 'Remote', DATE '2026-02-03', 2, NULL, 10009),
--     (70054, DATE '2026-04-18', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- NovaAnalytics is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hai Phong', 2500, 'Full-time', DATE '2026-03-04', 4, NULL, 10009),
--     (70055, DATE '2026-05-16', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- DigitalData is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-04-01', 2, NULL, 10010),
--     (70056, DATE '2026-06-16', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- DigitalData is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Part-time', DATE '2026-05-02', 4, NULL, 10010),
--     (70057, DATE '2026-07-18', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- DigitalData is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Hanoi', 4000, 'Contract', DATE '2026-06-03', 6, NULL, 10010),
--     (70058, DATE '2026-02-18', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- DigitalData is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Da Nang', 500, 'Internship', DATE '2026-01-04', 0, NULL, 10010),
--     (70059, DATE '2026-03-22', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- DigitalData is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Can Tho', 2300, 'Remote', DATE '2026-02-05', 2, NULL, 10010),
--     (70060, DATE '2026-06-18', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- AlphaSolutions is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Part-time', DATE '2026-05-04', 4, NULL, 10011),
--     (70061, DATE '2026-07-20', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- AlphaSolutions is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hanoi', 4000, 'Contract', DATE '2026-06-05', 6, NULL, 10011),
--     (70062, DATE '2026-02-20', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- AlphaSolutions is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Da Nang', 500, 'Internship', DATE '2026-01-06', 0, NULL, 10011),
--     (70063, DATE '2026-03-24', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- AlphaSolutions is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Can Tho', 2300, 'Remote', DATE '2026-02-07', 2, NULL, 10011),
--     (70064, DATE '2026-04-22', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- AlphaSolutions is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hai Phong', 2500, 'Full-time', DATE '2026-03-08', 4, NULL, 10011),
--     (70065, DATE '2026-05-24', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- AlphaSolutions is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Bien Hoa', 3200, 'Full-time', DATE '2026-04-09', 6, NULL, 10011),
--     (70066, DATE '2026-07-22', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- VertexBridge is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hanoi', 4000, 'Contract', DATE '2026-06-07', 6, NULL, 10012),
--     (70067, DATE '2026-02-22', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- VertexBridge is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Da Nang', 500, 'Internship', DATE '2026-01-08', 0, NULL, 10012),
--     (70068, DATE '2026-03-26', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- VertexBridge is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Can Tho', 2300, 'Remote', DATE '2026-02-09', 2, NULL, 10012),
--     (70069, DATE '2026-04-24', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- VertexBridge is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hai Phong', 2500, 'Full-time', DATE '2026-03-10', 4, NULL, 10012),
--     (70070, DATE '2026-05-26', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- VertexBridge is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Bien Hoa', 3200, 'Full-time', DATE '2026-04-11', 6, NULL, 10012),
--     (70071, DATE '2026-06-26', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- VertexBridge is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hue', 2100, 'Full-time', DATE '2026-05-12', 1, NULL, 10012),
--     (70072, DATE '2026-07-28', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- VertexBridge is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Nha Trang', 2200, 'Part-time', DATE '2026-06-13', 2, NULL, 10012),
--     (70073, DATE '2026-02-24', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- QuantumLogic is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Da Nang', 500, 'Internship', DATE '2026-01-10', 0, NULL, 10013),
--     (70074, DATE '2026-03-28', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- QuantumLogic is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Can Tho', 2300, 'Remote', DATE '2026-02-11', 2, NULL, 10013),
--     (70075, DATE '2026-04-26', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- QuantumLogic is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hai Phong', 2500, 'Full-time', DATE '2026-03-12', 4, NULL, 10013),
--     (70076, DATE '2026-05-28', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- QuantumLogic is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Bien Hoa', 3200, 'Full-time', DATE '2026-04-13', 6, NULL, 10013),
--     (70077, DATE '2026-06-28', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- QuantumLogic is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hue', 2100, 'Full-time', DATE '2026-05-14', 1, NULL, 10013),
--     (70078, DATE '2026-03-30', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- PeakNetworks is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Can Tho', 2300, 'Remote', DATE '2026-02-13', 2, NULL, 10014),
--     (70079, DATE '2026-04-28', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- PeakNetworks is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hai Phong', 2500, 'Full-time', DATE '2026-03-14', 4, NULL, 10014),
--     (70080, DATE '2026-05-30', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- PeakNetworks is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Bien Hoa', 3200, 'Full-time', DATE '2026-04-15', 6, NULL, 10014),
--     (70081, DATE '2026-06-30', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- PeakNetworks is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hue', 2100, 'Full-time', DATE '2026-05-16', 1, NULL, 10014),
--     (70082, DATE '2026-08-01', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- PeakNetworks is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Nha Trang', 2200, 'Part-time', DATE '2026-06-17', 2, NULL, 10014),
--     (70083, DATE '2026-03-04', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- PeakNetworks is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Vung Tau', 2400, 'Contract', DATE '2026-01-18', 4, NULL, 10014),
--     (70084, DATE '2026-04-30', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- DeltaSoftware is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hai Phong', 2500, 'Full-time', DATE '2026-03-16', 4, NULL, 10015),
--     (70085, DATE '2026-06-01', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- DeltaSoftware is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Bien Hoa', 3200, 'Full-time', DATE '2026-04-17', 6, NULL, 10015),
--     (70086, DATE '2026-07-02', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- DeltaSoftware is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hue', 2100, 'Full-time', DATE '2026-05-18', 1, NULL, 10015),
--     (70087, DATE '2026-08-03', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- DeltaSoftware is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Nha Trang', 2200, 'Part-time', DATE '2026-06-19', 2, NULL, 10015),
--     (70088, DATE '2026-03-06', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- DeltaSoftware is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Vung Tau', 2400, 'Contract', DATE '2026-01-20', 4, NULL, 10015),
--     (70089, DATE '2026-04-07', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- DeltaSoftware is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Da Lat', 500, 'Internship', DATE '2026-02-21', 0, NULL, 10015),
--     (70090, DATE '2026-05-06', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- DeltaSoftware is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Ho Chi Minh City', 2300, 'Remote', DATE '2026-03-22', 1, NULL, 10015),
--     (70091, DATE '2026-06-03', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- OrbitWorks is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Bien Hoa', 3200, 'Full-time', DATE '2026-04-19', 6, NULL, 10016),
--     (70092, DATE '2026-07-04', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- OrbitWorks is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Hue', 2100, 'Full-time', DATE '2026-05-20', 1, NULL, 10016),
--     (70093, DATE '2026-08-05', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- OrbitWorks is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Nha Trang', 2200, 'Part-time', DATE '2026-06-21', 2, NULL, 10016),
--     (70094, DATE '2026-03-08', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- OrbitWorks is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Vung Tau', 2400, 'Contract', DATE '2026-01-22', 4, NULL, 10016),
--     (70095, DATE '2026-04-09', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- OrbitWorks is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Da Lat', 500, 'Internship', DATE '2026-02-23', 0, NULL, 10016),
--     (70096, DATE '2026-07-06', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- TechDynamics is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Hue', 2100, 'Full-time', DATE '2026-05-22', 1, NULL, 10017),
--     (70097, DATE '2026-08-07', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- TechDynamics is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Nha Trang', 2200, 'Part-time', DATE '2026-06-23', 2, NULL, 10017),
--     (70098, DATE '2026-03-10', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- TechDynamics is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Vung Tau', 2400, 'Contract', DATE '2026-01-24', 4, NULL, 10017),
--     (70099, DATE '2026-04-11', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- TechDynamics is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Da Lat', 500, 'Internship', DATE '2026-02-25', 0, NULL, 10017),
--     (70100, DATE '2026-05-10', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- TechDynamics is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Ho Chi Minh City', 2300, 'Remote', DATE '2026-03-26', 1, NULL, 10017),
--     (70101, DATE '2026-06-11', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- TechDynamics is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Hanoi', 2300, 'Full-time', DATE '2026-04-27', 2, NULL, 10017),
--     (70102, DATE '2026-08-09', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- GreenAnalytics is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Nha Trang', 2200, 'Part-time', DATE '2026-06-25', 2, NULL, 10018),
--     (70103, DATE '2026-03-12', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- GreenAnalytics is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Vung Tau', 2400, 'Contract', DATE '2026-01-26', 4, NULL, 10018),
--     (70104, DATE '2026-04-13', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- GreenAnalytics is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Da Lat', 500, 'Internship', DATE '2026-02-27', 0, NULL, 10018),
--     (70105, DATE '2026-04-15', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- GreenAnalytics is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Ho Chi Minh City', 2300, 'Remote', DATE '2026-03-01', 1, NULL, 10018),
--     (70106, DATE '2026-05-17', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- GreenAnalytics is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hanoi', 2300, 'Full-time', DATE '2026-04-02', 2, NULL, 10018),
--     (70107, DATE '2026-06-17', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- GreenAnalytics is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Da Nang', 2500, 'Full-time', DATE '2026-05-03', 4, NULL, 10018),
--     (70108, DATE '2026-07-19', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- GreenAnalytics is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Can Tho', 3200, 'Full-time', DATE '2026-06-04', 6, NULL, 10018),
--     (70109, DATE '2026-02-15', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- CloudData is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Vung Tau', 2400, 'Contract', DATE '2026-01-01', 4, NULL, 10019),
--     (70110, DATE '2026-03-19', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- CloudData is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Da Lat', 500, 'Internship', DATE '2026-02-02', 0, NULL, 10019),
--     (70111, DATE '2026-04-17', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- CloudData is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Ho Chi Minh City', 2300, 'Remote', DATE '2026-03-03', 1, NULL, 10019),
--     (70112, DATE '2026-05-19', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- CloudData is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Hanoi', 2300, 'Full-time', DATE '2026-04-04', 2, NULL, 10019),
--     (70113, DATE '2026-06-19', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- CloudData is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Da Nang', 2500, 'Full-time', DATE '2026-05-05', 4, NULL, 10019),
--     (70114, DATE '2026-03-21', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- BrightSolutions is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Da Lat', 500, 'Internship', DATE '2026-02-04', 0, NULL, 10020),
--     (70115, DATE '2026-04-19', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- BrightSolutions is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Ho Chi Minh City', 2300, 'Remote', DATE '2026-03-05', 1, NULL, 10020),
--     (70116, DATE '2026-05-21', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- BrightSolutions is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hanoi', 2300, 'Full-time', DATE '2026-04-06', 2, NULL, 10020),
--     (70117, DATE '2026-06-21', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- BrightSolutions is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Da Nang', 2500, 'Full-time', DATE '2026-05-07', 4, NULL, 10020),
--     (70118, DATE '2026-07-23', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- BrightSolutions is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Can Tho', 3200, 'Full-time', DATE '2026-06-08', 6, NULL, 10020),
--     (70119, DATE '2026-02-23', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- BrightSolutions is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hai Phong', 2100, 'Part-time', DATE '2026-01-09', 1, NULL, 10020),
--     (70120, DATE '2026-04-21', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- SmartBridge is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Ho Chi Minh City', 2300, 'Remote', DATE '2026-03-07', 1, NULL, 10021),
--     (70121, DATE '2026-05-23', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- SmartBridge is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hanoi', 2300, 'Full-time', DATE '2026-04-08', 2, NULL, 10021),
--     (70122, DATE '2026-06-23', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- SmartBridge is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Da Nang', 2500, 'Full-time', DATE '2026-05-09', 4, NULL, 10021),
--     (70123, DATE '2026-07-25', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- SmartBridge is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Can Tho', 3200, 'Full-time', DATE '2026-06-10', 6, NULL, 10021),
--     (70124, DATE '2026-02-25', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- SmartBridge is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hai Phong', 2100, 'Part-time', DATE '2026-01-11', 1, NULL, 10021),
--     (70125, DATE '2026-03-29', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- SmartBridge is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Bien Hoa', 2200, 'Contract', DATE '2026-02-12', 2, NULL, 10021),
--     (70126, DATE '2026-04-27', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- SmartBridge is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hue', 500, 'Internship', DATE '2026-03-13', 0, NULL, 10021),
--     (70127, DATE '2026-05-25', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- NextLogic is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Hanoi', 2300, 'Full-time', DATE '2026-04-10', 2, NULL, 10022),
--     (70128, DATE '2026-06-25', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- NextLogic is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Da Nang', 2500, 'Full-time', DATE '2026-05-11', 4, NULL, 10022),
--     (70129, DATE '2026-07-27', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- NextLogic is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Can Tho', 3200, 'Full-time', DATE '2026-06-12', 6, NULL, 10022),
--     (70130, DATE '2026-02-27', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- NextLogic is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Hai Phong', 2100, 'Part-time', DATE '2026-01-13', 1, NULL, 10022),
--     (70131, DATE '2026-03-31', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- NextLogic is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Bien Hoa', 2200, 'Contract', DATE '2026-02-14', 2, NULL, 10022),
--     (70132, DATE '2026-06-27', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- BlueNetworks is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Da Nang', 2500, 'Full-time', DATE '2026-05-13', 4, NULL, 10023),
--     (70133, DATE '2026-07-29', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- BlueNetworks is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Can Tho', 3200, 'Full-time', DATE '2026-06-14', 6, NULL, 10023),
--     (70134, DATE '2026-03-01', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- BlueNetworks is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hai Phong', 2100, 'Part-time', DATE '2026-01-15', 1, NULL, 10023),
--     (70135, DATE '2026-04-02', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- BlueNetworks is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Bien Hoa', 2200, 'Contract', DATE '2026-02-16', 2, NULL, 10023),
--     (70136, DATE '2026-05-01', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- BlueNetworks is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hue', 500, 'Internship', DATE '2026-03-17', 0, NULL, 10023),
--     (70137, DATE '2026-06-02', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- BlueNetworks is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Nha Trang', 4000, 'Remote', DATE '2026-04-18', 6, NULL, 10023),
--     (70138, DATE '2026-07-31', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- PrimeLabs is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Can Tho', 3200, 'Full-time', DATE '2026-06-16', 6, NULL, 10024),
--     (70139, DATE '2026-03-03', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- PrimeLabs is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hai Phong', 2100, 'Part-time', DATE '2026-01-17', 1, NULL, 10024),
--     (70140, DATE '2026-04-04', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- PrimeLabs is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Bien Hoa', 2200, 'Contract', DATE '2026-02-18', 2, NULL, 10024),
--     (70141, DATE '2026-05-03', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- PrimeLabs is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hue', 500, 'Internship', DATE '2026-03-19', 0, NULL, 10024),
--     (70142, DATE '2026-06-04', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- PrimeLabs is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Nha Trang', 4000, 'Remote', DATE '2026-04-20', 6, NULL, 10024),
--     (70143, DATE '2026-07-05', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- PrimeLabs is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Vung Tau', 2300, 'Full-time', DATE '2026-05-21', 1, NULL, 10024),
--     (70144, DATE '2026-08-06', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- PrimeLabs is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Da Lat', 2300, 'Full-time', DATE '2026-06-22', 2, NULL, 10024),
--     (70145, DATE '2026-03-05', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- NovaSystems is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hai Phong', 2100, 'Part-time', DATE '2026-01-19', 1, NULL, 10025),
--     (70146, DATE '2026-04-06', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- NovaSystems is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Bien Hoa', 2200, 'Contract', DATE '2026-02-20', 2, NULL, 10025),
--     (70147, DATE '2026-05-05', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- NovaSystems is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hue', 500, 'Internship', DATE '2026-03-21', 0, NULL, 10025),
--     (70148, DATE '2026-06-06', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- NovaSystems is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Nha Trang', 4000, 'Remote', DATE '2026-04-22', 6, NULL, 10025),
--     (70149, DATE '2026-07-07', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- NovaSystems is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Vung Tau', 2300, 'Full-time', DATE '2026-05-23', 1, NULL, 10025),
--     (70150, DATE '2026-04-08', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- DigitalHub is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Bien Hoa', 2200, 'Contract', DATE '2026-02-22', 2, NULL, 10026),
--     (70151, DATE '2026-05-07', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- DigitalHub is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hue', 500, 'Internship', DATE '2026-03-23', 0, NULL, 10026),
--     (70152, DATE '2026-06-08', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- DigitalHub is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Nha Trang', 4000, 'Remote', DATE '2026-04-24', 6, NULL, 10026),
--     (70153, DATE '2026-07-09', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- DigitalHub is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Vung Tau', 2300, 'Full-time', DATE '2026-05-25', 1, NULL, 10026),
--     (70154, DATE '2026-08-10', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- DigitalHub is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Da Lat', 2300, 'Full-time', DATE '2026-06-26', 2, NULL, 10026),
--     (70155, DATE '2026-03-13', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- DigitalHub is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Ho Chi Minh City', 2500, 'Full-time', DATE '2026-01-27', 4, NULL, 10026),
--     (70156, DATE '2026-05-09', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- AlphaStudio is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hue', 500, 'Internship', DATE '2026-03-25', 0, NULL, 10027),
--     (70157, DATE '2026-06-10', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- AlphaStudio is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Nha Trang', 4000, 'Remote', DATE '2026-04-26', 6, NULL, 10027),
--     (70158, DATE '2026-07-11', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- AlphaStudio is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Vung Tau', 2300, 'Full-time', DATE '2026-05-27', 1, NULL, 10027),
--     (70159, DATE '2026-07-16', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- AlphaStudio is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Da Lat', 2300, 'Full-time', DATE '2026-06-01', 2, NULL, 10027),
--     (70160, DATE '2026-02-16', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- AlphaStudio is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Ho Chi Minh City', 2500, 'Full-time', DATE '2026-01-02', 4, NULL, 10027),
--     (70161, DATE '2026-03-20', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- AlphaStudio is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hanoi', 3200, 'Part-time', DATE '2026-02-03', 6, NULL, 10027),
--     (70162, DATE '2026-04-18', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- AlphaStudio is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Da Nang', 2100, 'Contract', DATE '2026-03-04', 1, NULL, 10027),
--     (70163, DATE '2026-05-16', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- VertexVentures is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Nha Trang', 4000, 'Remote', DATE '2026-04-01', 6, NULL, 10028),
--     (70164, DATE '2026-06-16', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- VertexVentures is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Vung Tau', 2300, 'Full-time', DATE '2026-05-02', 1, NULL, 10028),
--     (70165, DATE '2026-07-18', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- VertexVentures is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Da Lat', 2300, 'Full-time', DATE '2026-06-03', 2, NULL, 10028),
--     (70166, DATE '2026-02-18', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- VertexVentures is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Ho Chi Minh City', 2500, 'Full-time', DATE '2026-01-04', 4, NULL, 10028),
--     (70167, DATE '2026-03-22', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- VertexVentures is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Hanoi', 3200, 'Part-time', DATE '2026-02-05', 6, NULL, 10028),
--     (70168, DATE '2026-06-18', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- QuantumSolutions is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Vung Tau', 2300, 'Full-time', DATE '2026-05-04', 1, NULL, 10029),
--     (70169, DATE '2026-07-20', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- QuantumSolutions is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Da Lat', 2300, 'Full-time', DATE '2026-06-05', 2, NULL, 10029),
--     (70170, DATE '2026-02-20', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- QuantumSolutions is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Ho Chi Minh City', 2500, 'Full-time', DATE '2026-01-06', 4, NULL, 10029),
--     (70171, DATE '2026-03-24', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- QuantumSolutions is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Hanoi', 3200, 'Part-time', DATE '2026-02-07', 6, NULL, 10029),
--     (70172, DATE '2026-04-22', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- QuantumSolutions is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Da Nang', 2100, 'Contract', DATE '2026-03-08', 1, NULL, 10029),
--     (70173, DATE '2026-05-24', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- QuantumSolutions is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Can Tho', 500, 'Internship', DATE '2026-04-09', 0, NULL, 10029),
--     (70174, DATE '2026-07-22', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- PeakBridge is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Da Lat', 2300, 'Full-time', DATE '2026-06-07', 2, NULL, 10030),
--     (70175, DATE '2026-02-22', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- PeakBridge is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Ho Chi Minh City', 2500, 'Full-time', DATE '2026-01-08', 4, NULL, 10030),
--     (70176, DATE '2026-03-26', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- PeakBridge is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hanoi', 3200, 'Part-time', DATE '2026-02-09', 6, NULL, 10030),
--     (70177, DATE '2026-04-24', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- PeakBridge is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Da Nang', 2100, 'Contract', DATE '2026-03-10', 1, NULL, 10030),
--     (70178, DATE '2026-05-26', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- PeakBridge is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Can Tho', 500, 'Internship', DATE '2026-04-11', 0, NULL, 10030),
--     (70179, DATE '2026-06-26', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- PeakBridge is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hai Phong', 2400, 'Remote', DATE '2026-05-12', 4, NULL, 10030),
--     (70180, DATE '2026-07-28', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- PeakBridge is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Bien Hoa', 4000, 'Full-time', DATE '2026-06-13', 6, NULL, 10030),
--     (70181, DATE '2026-02-24', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- DeltaLogic is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Ho Chi Minh City', 2500, 'Full-time', DATE '2026-01-10', 4, NULL, 10031),
--     (70182, DATE '2026-03-28', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- DeltaLogic is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Hanoi', 3200, 'Part-time', DATE '2026-02-11', 6, NULL, 10031),
--     (70183, DATE '2026-04-26', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- DeltaLogic is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Da Nang', 2100, 'Contract', DATE '2026-03-12', 1, NULL, 10031),
--     (70184, DATE '2026-05-28', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- DeltaLogic is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Can Tho', 500, 'Internship', DATE '2026-04-13', 0, NULL, 10031),
--     (70185, DATE '2026-06-28', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- DeltaLogic is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Hai Phong', 2400, 'Remote', DATE '2026-05-14', 4, NULL, 10031),
--     (70186, DATE '2026-03-30', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- OrbitNetworks is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hanoi', 3200, 'Part-time', DATE '2026-02-13', 6, NULL, 10032),
--     (70187, DATE '2026-04-28', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- OrbitNetworks is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Da Nang', 2100, 'Contract', DATE '2026-03-14', 1, NULL, 10032),
--     (70188, DATE '2026-05-30', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- OrbitNetworks is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Can Tho', 500, 'Internship', DATE '2026-04-15', 0, NULL, 10032),
--     (70189, DATE '2026-06-30', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- OrbitNetworks is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hai Phong', 2400, 'Remote', DATE '2026-05-16', 4, NULL, 10032),
--     (70190, DATE '2026-08-01', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- OrbitNetworks is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Bien Hoa', 4000, 'Full-time', DATE '2026-06-17', 6, NULL, 10032),
--     (70191, DATE '2026-03-04', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- OrbitNetworks is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hue', 2300, 'Full-time', DATE '2026-01-18', 1, NULL, 10032),
--     (70192, DATE '2026-04-30', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- TechLabs 2 is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Da Nang', 2100, 'Contract', DATE '2026-03-16', 1, NULL, 10033),
--     (70193, DATE '2026-06-01', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- TechLabs 2 is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Can Tho', 500, 'Internship', DATE '2026-04-17', 0, NULL, 10033),
--     (70194, DATE '2026-07-02', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- TechLabs 2 is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hai Phong', 2400, 'Remote', DATE '2026-05-18', 4, NULL, 10033),
--     (70195, DATE '2026-08-03', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- TechLabs 2 is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Bien Hoa', 4000, 'Full-time', DATE '2026-06-19', 6, NULL, 10033),
--     (70196, DATE '2026-03-06', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- TechLabs 2 is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hue', 2300, 'Full-time', DATE '2026-01-20', 1, NULL, 10033),
--     (70197, DATE '2026-04-07', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- TechLabs 2 is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Nha Trang', 2300, 'Full-time', DATE '2026-02-21', 2, NULL, 10033),
--     (70198, DATE '2026-05-06', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- TechLabs 2 is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Vung Tau', 2500, 'Part-time', DATE '2026-03-22', 4, NULL, 10033),
--     (70199, DATE '2026-06-03', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- GreenSystems 2 is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Can Tho', 500, 'Internship', DATE '2026-04-19', 0, NULL, 10034),
--     (70200, DATE '2026-07-04', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- GreenSystems 2 is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Hai Phong', 2400, 'Remote', DATE '2026-05-20', 4, NULL, 10034),
--     (70201, DATE '2026-08-05', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- GreenSystems 2 is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Bien Hoa', 4000, 'Full-time', DATE '2026-06-21', 6, NULL, 10034),
--     (70202, DATE '2026-03-08', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- GreenSystems 2 is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Hue', 2300, 'Full-time', DATE '2026-01-22', 1, NULL, 10034),
--     (70203, DATE '2026-04-09', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- GreenSystems 2 is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Nha Trang', 2300, 'Full-time', DATE '2026-02-23', 2, NULL, 10034),
--     (70204, DATE '2026-07-06', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- CloudHub 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hai Phong', 2400, 'Remote', DATE '2026-05-22', 4, NULL, 10035),
--     (70205, DATE '2026-08-07', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- CloudHub 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Bien Hoa', 4000, 'Full-time', DATE '2026-06-23', 6, NULL, 10035),
--     (70206, DATE '2026-03-10', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- CloudHub 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hue', 2300, 'Full-time', DATE '2026-01-24', 1, NULL, 10035),
--     (70207, DATE '2026-04-11', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- CloudHub 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Nha Trang', 2300, 'Full-time', DATE '2026-02-25', 2, NULL, 10035),
--     (70208, DATE '2026-05-10', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- CloudHub 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Vung Tau', 2500, 'Part-time', DATE '2026-03-26', 4, NULL, 10035),
--     (70209, DATE '2026-06-11', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- CloudHub 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Da Lat', 3200, 'Contract', DATE '2026-04-27', 6, NULL, 10035),
--     (70210, DATE '2026-08-09', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- BrightStudio 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Bien Hoa', 4000, 'Full-time', DATE '2026-06-25', 6, NULL, 10036),
--     (70211, DATE '2026-03-12', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- BrightStudio 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hue', 2300, 'Full-time', DATE '2026-01-26', 1, NULL, 10036),
--     (70212, DATE '2026-04-13', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- BrightStudio 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Nha Trang', 2300, 'Full-time', DATE '2026-02-27', 2, NULL, 10036),
--     (70213, DATE '2026-04-15', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- BrightStudio 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Vung Tau', 2500, 'Part-time', DATE '2026-03-01', 4, NULL, 10036),
--     (70214, DATE '2026-05-17', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- BrightStudio 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Da Lat', 3200, 'Contract', DATE '2026-04-02', 6, NULL, 10036),
--     (70215, DATE '2026-06-17', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- BrightStudio 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Ho Chi Minh City', 500, 'Internship', DATE '2026-05-03', 0, NULL, 10036),
--     (70216, DATE '2026-07-19', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- BrightStudio 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hanoi', 2200, 'Remote', DATE '2026-06-04', 2, NULL, 10036),
--     (70217, DATE '2026-02-15', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- SmartVentures 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hue', 2300, 'Full-time', DATE '2026-01-01', 1, NULL, 10037),
--     (70218, DATE '2026-03-19', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- SmartVentures 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Nha Trang', 2300, 'Full-time', DATE '2026-02-02', 2, NULL, 10037),
--     (70219, DATE '2026-04-17', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- SmartVentures 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Vung Tau', 2500, 'Part-time', DATE '2026-03-03', 4, NULL, 10037),
--     (70220, DATE '2026-05-19', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- SmartVentures 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Da Lat', 3200, 'Contract', DATE '2026-04-04', 6, NULL, 10037),
--     (70221, DATE '2026-06-19', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- SmartVentures 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Ho Chi Minh City', 500, 'Internship', DATE '2026-05-05', 0, NULL, 10037),
--     (70222, DATE '2026-03-21', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- NextSoftware 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Nha Trang', 2300, 'Full-time', DATE '2026-02-04', 2, NULL, 10038),
--     (70223, DATE '2026-04-19', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- NextSoftware 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Vung Tau', 2500, 'Part-time', DATE '2026-03-05', 4, NULL, 10038),
--     (70224, DATE '2026-05-21', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- NextSoftware 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Da Lat', 3200, 'Contract', DATE '2026-04-06', 6, NULL, 10038),
--     (70225, DATE '2026-06-21', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- NextSoftware 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Ho Chi Minh City', 500, 'Internship', DATE '2026-05-07', 0, NULL, 10038),
--     (70226, DATE '2026-07-23', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- NextSoftware 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hanoi', 2200, 'Remote', DATE '2026-06-08', 2, NULL, 10038),
--     (70227, DATE '2026-02-23', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- NextSoftware 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-01-09', 4, NULL, 10038),
--     (70228, DATE '2026-04-21', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- BlueWorks 2 is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Vung Tau', 2500, 'Part-time', DATE '2026-03-07', 4, NULL, 10039),
--     (70229, DATE '2026-05-23', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- BlueWorks 2 is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Da Lat', 3200, 'Contract', DATE '2026-04-08', 6, NULL, 10039),
--     (70230, DATE '2026-06-23', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- BlueWorks 2 is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Ho Chi Minh City', 500, 'Internship', DATE '2026-05-09', 0, NULL, 10039),
--     (70231, DATE '2026-07-25', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- BlueWorks 2 is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hanoi', 2200, 'Remote', DATE '2026-06-10', 2, NULL, 10039),
--     (70232, DATE '2026-02-25', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- BlueWorks 2 is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-01-11', 4, NULL, 10039),
--     (70233, DATE '2026-03-29', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- BlueWorks 2 is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Can Tho', 4000, 'Full-time', DATE '2026-02-12', 6, NULL, 10039),
--     (70234, DATE '2026-04-27', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- BlueWorks 2 is a cloud infrastructure company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cloud infrastructure is helpful but not required"]', 'Hai Phong', 2300, 'Full-time', DATE '2026-03-13', 1, NULL, 10039),
--     (70235, DATE '2026-05-25', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- PrimeDynamics 2 is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Da Lat', 3200, 'Contract', DATE '2026-04-10', 6, NULL, 10040),
--     (70236, DATE '2026-06-25', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- PrimeDynamics 2 is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Ho Chi Minh City', 500, 'Internship', DATE '2026-05-11', 0, NULL, 10040),
--     (70237, DATE '2026-07-27', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- PrimeDynamics 2 is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Hanoi', 2200, 'Remote', DATE '2026-06-12', 2, NULL, 10040),
--     (70238, DATE '2026-02-27', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- PrimeDynamics 2 is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-01-13', 4, NULL, 10040),
--     (70239, DATE '2026-03-31', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- PrimeDynamics 2 is a fintech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in fintech is helpful but not required"]', 'Can Tho', 4000, 'Full-time', DATE '2026-02-14', 6, NULL, 10040),
--     (70240, DATE '2026-06-27', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- NovaAnalytics 2 is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Ho Chi Minh City', 500, 'Internship', DATE '2026-05-13', 0, NULL, 10041),
--     (70241, DATE '2026-07-29', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- NovaAnalytics 2 is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Hanoi', 2200, 'Remote', DATE '2026-06-14', 2, NULL, 10041),
--     (70242, DATE '2026-03-01', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- NovaAnalytics 2 is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-01-15', 4, NULL, 10041),
--     (70243, DATE '2026-04-02', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- NovaAnalytics 2 is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Can Tho', 4000, 'Full-time', DATE '2026-02-16', 6, NULL, 10041),
--     (70244, DATE '2026-05-01', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- NovaAnalytics 2 is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Hai Phong', 2300, 'Full-time', DATE '2026-03-17', 1, NULL, 10041),
--     (70245, DATE '2026-06-02', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- NovaAnalytics 2 is an e-commerce company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in e-commerce is helpful but not required"]', 'Bien Hoa', 2300, 'Part-time', DATE '2026-04-18', 2, NULL, 10041),
--     (70246, DATE '2026-07-31', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- DigitalData 2 is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hanoi', 2200, 'Remote', DATE '2026-06-16', 2, NULL, 10042),
--     (70247, DATE '2026-03-03', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- DigitalData 2 is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-01-17', 4, NULL, 10042),
--     (70248, DATE '2026-04-04', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- DigitalData 2 is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Can Tho', 4000, 'Full-time', DATE '2026-02-18', 6, NULL, 10042),
--     (70249, DATE '2026-05-03', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- DigitalData 2 is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hai Phong', 2300, 'Full-time', DATE '2026-03-19', 1, NULL, 10042),
--     (70250, DATE '2026-06-04', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- DigitalData 2 is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Bien Hoa', 2300, 'Part-time', DATE '2026-04-20', 2, NULL, 10042),
--     (70251, DATE '2026-07-05', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- DigitalData 2 is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Hue', 2500, 'Contract', DATE '2026-05-21', 4, NULL, 10042),
--     (70252, DATE '2026-08-06', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- DigitalData 2 is a cybersecurity company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in cybersecurity is helpful but not required"]', 'Nha Trang', 500, 'Internship', DATE '2026-06-22', 0, NULL, 10042),
--     (70253, DATE '2026-03-05', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- AlphaSystems is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Da Nang', 2400, 'Full-time', DATE '2026-01-19', 4, NULL, 10043),
--     (70254, DATE '2026-04-06', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- AlphaSystems is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Can Tho', 4000, 'Full-time', DATE '2026-02-20', 6, NULL, 10043),
--     (70255, DATE '2026-05-05', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- AlphaSystems is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Hai Phong', 2300, 'Full-time', DATE '2026-03-21', 1, NULL, 10043),
--     (70256, DATE '2026-06-06', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- AlphaSystems is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Bien Hoa', 2300, 'Part-time', DATE '2026-04-22', 2, NULL, 10043),
--     (70257, DATE '2026-07-07', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- AlphaSystems is a healthtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in healthtech is helpful but not required"]', 'Hue', 2500, 'Contract', DATE '2026-05-23', 4, NULL, 10043),
--     (70258, DATE '2026-04-08', '["Team building trips", "Mentorship program", "Training budget", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- VertexHub is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Can Tho', 4000, 'Full-time', DATE '2026-02-22', 6, NULL, 10044),
--     (70259, DATE '2026-05-07', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- VertexHub is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hai Phong', 2300, 'Full-time', DATE '2026-03-23', 1, NULL, 10044),
--     (70260, DATE '2026-06-08', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- VertexHub is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Bien Hoa', 2300, 'Part-time', DATE '2026-04-24', 2, NULL, 10044),
--     (70261, DATE '2026-07-09', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- VertexHub is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Hue', 2500, 'Contract', DATE '2026-05-25', 4, NULL, 10044),
--     (70262, DATE '2026-08-10', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- VertexHub is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Nha Trang', 500, 'Internship', DATE '2026-06-26', 0, NULL, 10044),
--     (70263, DATE '2026-03-13', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- VertexHub is an edtech company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in edtech is helpful but not required"]', 'Vung Tau', 2100, 'Remote', DATE '2026-01-27', 1, NULL, 10044),
--     (70264, DATE '2026-05-09', '["Stock options", "Hybrid work", "Flexible working hours", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- QuantumStudio is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hai Phong', 2300, 'Full-time', DATE '2026-03-25', 1, NULL, 10045),
--     (70265, DATE '2026-06-10', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- QuantumStudio is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Bien Hoa', 2300, 'Part-time', DATE '2026-04-26', 2, NULL, 10045),
--     (70266, DATE '2026-07-11', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- QuantumStudio is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Hue', 2500, 'Contract', DATE '2026-05-27', 4, NULL, 10045),
--     (70267, DATE '2026-07-16', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- QuantumStudio is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Nha Trang', 500, 'Internship', DATE '2026-06-01', 0, NULL, 10045),
--     (70268, DATE '2026-02-16', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- QuantumStudio is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Vung Tau', 2100, 'Remote', DATE '2026-01-02', 1, NULL, 10045),
--     (70269, DATE '2026-03-20', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- QuantumStudio is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-02-03', 2, NULL, 10045),
--     (70270, DATE '2026-04-18', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- QuantumStudio is a logistics company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in logistics is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Full-time', DATE '2026-03-04', 4, NULL, 10045),
--     (70271, DATE '2026-05-16', '["Conference and certification support", "Annual performance bonus", "Laptop allowance", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- PeakVentures is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Bien Hoa.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Bien Hoa', 2300, 'Part-time', DATE '2026-04-01', 2, NULL, 10046),
--     (70272, DATE '2026-06-16', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- PeakVentures is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Hue', 2500, 'Contract', DATE '2026-05-02', 4, NULL, 10046),
--     (70273, DATE '2026-07-18', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- PeakVentures is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Nha Trang', 500, 'Internship', DATE '2026-06-03', 0, NULL, 10046),
--     (70274, DATE '2026-02-18', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- PeakVentures is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Vung Tau', 2100, 'Remote', DATE '2026-01-04', 1, NULL, 10046),
--     (70275, DATE '2026-03-22', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- PeakVentures is a gaming company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in gaming is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-02-05', 2, NULL, 10046),
--     (70276, DATE '2026-06-18', '["Free lunch", "Health insurance", "13th month salary", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- DeltaSoftware 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hue.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hue', 2500, 'Contract', DATE '2026-05-04', 4, NULL, 10047),
--     (70277, DATE '2026-07-20', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- DeltaSoftware 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Nha Trang', 500, 'Internship', DATE '2026-06-05', 0, NULL, 10047),
--     (70278, DATE '2026-02-20', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- DeltaSoftware 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Vung Tau', 2100, 'Remote', DATE '2026-01-06', 1, NULL, 10047),
--     (70279, DATE '2026-03-24', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- DeltaSoftware 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-02-07', 2, NULL, 10047),
--     (70280, DATE '2026-04-22', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- DeltaSoftware 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Full-time', DATE '2026-03-08', 4, NULL, 10047),
--     (70281, DATE '2026-05-24', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- DeltaSoftware 2 is a telecommunications company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in telecommunications is helpful but not required"]', 'Hanoi', 4000, 'Full-time', DATE '2026-04-09', 6, NULL, 10047),
--     (70282, DATE '2026-07-22', '["Mentorship program", "Training budget", "Team building trips", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Product Designer', 'About the Company
-- OrbitWorks 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Product Designer, you will lead product design from discovery through delivery and create intuitive experiences grounded in user needs. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Nha Trang.

-- What You''ll Do
-- - Plan discovery activities and turn user needs into clear product experiences.
-- - Create user flows, wireframes, prototypes, and production-ready interface designs.
-- - Run usability studies and incorporate evidence into design decisions.
-- - Maintain consistent patterns and contribute to the product design system.
-- - Collaborate with product managers and engineers throughout implementation.
-- - Provide design direction, critique, and mentoring across complex initiatives.', '["6+ years of relevant professional experience", "Strong practical knowledge of Figma", "Working knowledge of interaction and visual design", "Experience with user research and usability testing", "Familiarity with prototyping", "Understanding of design systems", "Comfortable with stakeholder communication and leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Nha Trang', 500, 'Internship', DATE '2026-06-07', 0, NULL, 10048),
--     (70283, DATE '2026-02-22', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- OrbitWorks 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Vung Tau', 2100, 'Remote', DATE '2026-01-08', 1, NULL, 10048),
--     (70284, DATE '2026-03-26', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- OrbitWorks 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-02-09', 2, NULL, 10048),
--     (70285, DATE '2026-04-24', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- OrbitWorks 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Full-time', DATE '2026-03-10', 4, NULL, 10048),
--     (70286, DATE '2026-05-26', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- OrbitWorks 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Hanoi', 4000, 'Full-time', DATE '2026-04-11', 6, NULL, 10048),
--     (70287, DATE '2026-06-26', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- OrbitWorks 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Da Nang', 2300, 'Part-time', DATE '2026-05-12', 1, NULL, 10048),
--     (70288, DATE '2026-07-28', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- OrbitWorks 2 is a consulting company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in consulting is helpful but not required"]', 'Can Tho', 2300, 'Contract', DATE '2026-06-13', 2, NULL, 10048),
--     (70289, DATE '2026-02-24', '["Hybrid work", "Flexible working hours", "Stock options", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior Backend Engineer', 'About the Company
-- TechDynamics 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior Backend Engineer, you will build and evolve backend services, APIs, and platform components that support reliable products at scale. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Vung Tau.

-- What You''ll Do
-- - Develop robust backend services and well-documented APIs.
-- - Propose practical system designs and improve existing architecture.
-- - Write maintainable, testable code and review changes from teammates.
-- - Automate build, testing, and deployment workflows with CI/CD.
-- - Monitor reliability, latency, and resource usage and resolve production issues.
-- - Work with relational databases, caching, messaging, and observability tools.', '["1+ years of relevant professional experience", "Strong practical knowledge of Java", "Working knowledge of Spring Boot", "Experience with REST API design", "Familiarity with PostgreSQL", "Understanding of Redis or Kafka", "Comfortable with Linux and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Vung Tau', 2100, 'Remote', DATE '2026-01-10', 1, NULL, 10049),
--     (70290, DATE '2026-03-28', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- TechDynamics 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-02-11', 2, NULL, 10049),
--     (70291, DATE '2026-04-26', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- TechDynamics 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Full-time', DATE '2026-03-12', 4, NULL, 10049),
--     (70292, DATE '2026-05-28', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- TechDynamics 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Hanoi', 4000, 'Full-time', DATE '2026-04-13', 6, NULL, 10049),
--     (70293, DATE '2026-06-28', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- TechDynamics 2 is a software development company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in software development is helpful but not required"]', 'Da Nang', 2300, 'Part-time', DATE '2026-05-14', 1, NULL, 10049),
--     (70294, DATE '2026-03-30', '["Annual performance bonus", "Laptop allowance", "Conference and certification support", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Frontend Developer', 'About the Company
-- GreenAnalytics 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Frontend Developer, you will create fast, accessible, and maintainable web experiences used by customers and internal teams. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Lat.

-- What You''ll Do
-- - Build responsive user interfaces and reusable frontend components.
-- - Translate product and design requirements into reliable application flows.
-- - Improve performance, accessibility, browser compatibility, and test coverage.
-- - Integrate frontend applications with secure backend APIs.
-- - Contribute to code reviews, technical planning, and engineering standards.
-- - Collaborate closely with designers, backend engineers, and product stakeholders.', '["2+ years of relevant professional experience", "Strong practical knowledge of React", "Working knowledge of TypeScript", "Experience with modern CSS or TailwindCSS", "Familiarity with state management such as Redux", "Understanding of frontend testing", "Comfortable with REST APIs and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Da Lat', 2200, 'Full-time', DATE '2026-02-13', 2, NULL, 10050),
--     (70295, DATE '2026-04-28', '["Health insurance", "13th month salary", "Free lunch", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior Data Analyst', 'About the Company
-- GreenAnalytics 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior Data Analyst, you will turn complex datasets into trustworthy insights, metrics, and decision-support tools. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Ho Chi Minh City.

-- What You''ll Do
-- - Collect, clean, validate, and analyze data from multiple sources.
-- - Develop reusable SQL queries, analytical models, and reporting datasets.
-- - Create dashboards and communicate findings to technical and business teams.
-- - Define meaningful metrics and investigate unexpected changes in performance.
-- - Automate recurring analysis and improve data quality controls.
-- - Partner with engineering and product teams on data-informed decisions.', '["4+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of SQL", "Experience with Pandas or NumPy", "Familiarity with Power BI or another BI platform", "Understanding of statistics and data validation", "Comfortable with clear analytical communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Ho Chi Minh City', 2400, 'Full-time', DATE '2026-03-14', 4, NULL, 10050),
--     (70296, DATE '2026-05-30', '["Training budget", "Team building trips", "Mentorship program", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Lead Machine Learning Engineer', 'About the Company
-- GreenAnalytics 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Lead Machine Learning Engineer, you will design, train, evaluate, and productionize machine-learning systems that solve measurable business problems. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hanoi.

-- What You''ll Do
-- - Develop machine-learning models from experimentation through production deployment.
-- - Design reproducible data preparation, training, and evaluation pipelines.
-- - Select appropriate algorithms and define meaningful offline and online metrics.
-- - Collaborate with backend and platform teams to serve models reliably at scale.
-- - Monitor model quality, drift, latency, and resource consumption.
-- - Guide technical decisions and raise engineering quality across the team.', '["6+ years of relevant professional experience", "Strong practical knowledge of Python", "Working knowledge of PyTorch or TensorFlow", "Experience with Scikit-learn", "Familiarity with NumPy and Pandas", "Understanding of MLOps and model serving", "Comfortable with system design and technical leadership", "Demonstrated ability to lead technical direction, mentor teammates, and deliver complex initiatives", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hanoi', 4000, 'Full-time', DATE '2026-04-15', 6, NULL, 10050),
--     (70297, DATE '2026-06-30', '["Flexible working hours", "Stock options", "Hybrid work", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Junior DevOps Engineer', 'About the Company
-- GreenAnalytics 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Junior DevOps Engineer, you will improve delivery speed, platform reliability, and operational visibility across development and production environments. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Da Nang.

-- What You''ll Do
-- - Build and maintain CI/CD pipelines for repeatable software delivery.
-- - Automate infrastructure provisioning, configuration, and routine operations.
-- - Operate containerized applications and improve deployment safety.
-- - Monitor availability, performance, logs, and security signals.
-- - Investigate incidents and implement lasting reliability improvements.
-- - Work with developers to make systems easier to deploy, observe, and support.', '["1+ years of relevant professional experience", "Strong practical knowledge of Linux and shell scripting", "Working knowledge of Docker", "Experience with Kubernetes", "Familiarity with CI/CD platforms", "Understanding of cloud infrastructure and networking", "Comfortable with monitoring, logging, and Git", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Da Nang', 2300, 'Part-time', DATE '2026-05-16', 1, NULL, 10050),
--     (70298, DATE '2026-08-01', '["Laptop allowance", "Conference and certification support", "Annual performance bonus", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows"]', 'Mobile Developer', 'About the Company
-- GreenAnalytics 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Mobile Developer, you will build reliable mobile applications with polished user experiences and strong integration with backend services. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Can Tho.

-- What You''ll Do
-- - Develop and maintain mobile features from technical design through release.
-- - Create reusable components and clear application architecture.
-- - Integrate secure APIs, notifications, analytics, and device capabilities.
-- - Improve application performance, stability, and automated test coverage.
-- - Diagnose production issues and deliver fixes through controlled releases.
-- - Collaborate with product, design, backend, and quality engineering teams.', '["2+ years of relevant professional experience", "Strong practical knowledge of Flutter and Dart or a comparable mobile stack", "Working knowledge of mobile application architecture", "Experience with REST API integration", "Familiarity with Firebase or similar services", "Understanding of testing and release management", "Comfortable with Git and collaborative development", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Can Tho', 2300, 'Contract', DATE '2026-06-17', 2, NULL, 10050),
--     (70299, DATE '2026-03-04', '["13th month salary", "Free lunch", "Health insurance", "Competitive compensation with regular performance reviews", "Clear career development roadmap and challenging technical work", "Learning budget, internal knowledge-sharing sessions, and certification support", "Premium health insurance and employee assistance support", "Generous paid time off and tenure-based sabbatical opportunities", "Flexible working arrangements where the role allows", "Monthly team activities, employee clubs, and an annual company trip"]', 'Senior QA Automation Engineer', 'About the Company
-- GreenAnalytics 2 is an artificial intelligence company developing practical products and platforms for customers across Vietnam and the region. The team combines technical curiosity with accountability for measurable outcomes and encourages people to challenge assumptions, share ideas, and continuously improve how work is delivered.

-- The Role
-- As a Senior QA Automation Engineer, you will raise product quality by designing scalable test automation, improving coverage, and preventing production defects. You will work in a collaborative engineering environment, contribute to technical decisions, and help deliver dependable solutions for real users. The role is based in Hai Phong.

-- What You''ll Do
-- - Design and maintain automated tests for web services and user-facing applications.
-- - Develop test plans from product requirements and technical risks.
-- - Integrate automated quality checks into CI/CD pipelines.
-- - Investigate failures, document defects, and collaborate on root-cause analysis.
-- - Track quality indicators and identify opportunities to improve release confidence.
-- - Coach teammates on testability, automation practices, and quality standards.', '["4+ years of relevant professional experience", "Strong practical knowledge of Selenium or Playwright", "Working knowledge of Java or another automation language", "Experience with TestNG or a comparable framework", "Familiarity with API testing", "Understanding of CI/CD and version control", "Comfortable with risk-based testing and communication", "Demonstrated ability to own complex work independently and support less-experienced teammates", "Strong problem-solving ability, sound judgment, and attention to detail", "Ability to work thoughtfully in a collaborative, team-oriented culture", "Bachelor''s degree in Computer Science, Engineering, Design, Data, or a related discipline, or equivalent practical experience", "Prior experience in artificial intelligence is helpful but not required"]', 'Hai Phong', 500, 'Internship', DATE '2026-01-18', 0, NULL, 10050)
-- ON CONFLICT (id) DO UPDATE SET
--     applying_deadline = EXCLUDED.applying_deadline,
--     benefits = EXCLUDED.benefits,
--     job_title = EXCLUDED.job_title,
--     job_desc = EXCLUDED.job_desc,
--     requirement = EXCLUDED.requirement,
--     location = EXCLUDED.location,
--     salary_range = EXCLUDED.salary_range,
--     job_type = EXCLUDED.job_type,
--     posted_date = EXCLUDED.posted_date,
--     yoe = EXCLUDED.yoe,
--     custom_application_fields_id = EXCLUDED.custom_application_fields_id,
--     recruiter_id = EXCLUDED.recruiter_id;