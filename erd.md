Here's the complete Mermaid ER diagram code

```mermaid
erDiagram
    USER ||--o| APLLICANT : "extends"
    USER ||--o| RECRUITER : "extends"
    ROLE ||--o{ USER : "assigned to"
    ROLE ||--o{ PERMISSION_ROLE : "has"
    PERMISSION ||--o{ PERMISSION_ROLE : "has"
    RECRUITER ||--o{ JOB : "posts"
    APLLICANT ||--|| CV : "owns"
    CV }o--|| CERTIFICATE : "references"
    CV }o--|| EDUCATION : "references"
    CV }o--|| EXPERIENCE : "references"
    APLLICANT ||--o{ APPLICANT_JOB : "applies via"
    JOB ||--o{ APPLICANT_JOB : "receives"
    APPLICANT_JOB }o--|| APPLICATION_FORM : "submits"

    APLLICANT {
        int id PK "inheritence from USER"
        string full_name
        string gender "A enum"
        string status
        int cv_id
    }

    USER {
        int id PK "parent entity"
        string email
        string password "Hash Password"
        string refresh_token
        string user_name "Used to login"
        int role_id FK
    }

    CV {
        int id PK
        text address 
        string cv_file_url
        string full_name
        text objective
        string phone
        int certificate_id FK
        int education_id FK
        int experience_id FK
    }

    JOB {
        int id PK
        date applying_deadline "nullable"
        text benefits
        int custom_application_fields_id "nullable"
        int YOE "nullable"
        text job_desc
        string job_title
        string job_type "A enum"
        string location
        date posted_date
        text requirement
        double salary_range "nullable"
        int recruiter_id FK
    }

    RECRUITER {
        int id PK "inheritence from USER"
        text company_desc
        string location
        string company_name
        int company_size
        string industry_type "A enum"
        string contact
        string phone
        string avatar_url
        date established_date
    }

    ROLE {
        int id PK
        string name
    }

    PERMISSION {
        int id PK
        string endpoint
        string method
    }

    PERMISSION_ROLE {
        int id PK
        int permission_id FK
        int role_id FK
    }

    APPLICANT_JOB {
        int id PK
        string action_type
        int applicant_id
        int job_id
        int application_form_id
    }

    APPLICATION_FORM {
        int id
        string field
        string value
        string url_file
    }

    CERTIFICATE {
        int id PK
        string name
        string score
        string provider
    }

    EDUCATION {
        int id PK
        string name
        string major
        string degree "A enum"
        date start_date
        date end_date
    }

    EXPERIENCE {
        int id PK
        string company_name
        string job_title
        string field
        text contribution
        date start_date
        date end_date
        bool isPresent
    }
```

**Notation reference for the cardinality symbols used:**
- `||--o|` → One-to-One (optional on one side)
- `||--o{` → One-to-Many
- `}o--||` → Many-to-One
- `}o--o{` → Many-to-Many (used implicitly via bridge tables like `PERMISSION_ROLE` and `APPLICANT_JOB`)

One thing to double check when you paste this in: some editors are strict about the `|o`, `||`, `o{`, `}o` syntax spacing — make sure there's no extra space between the pipes/braces and the dashes, or the parser will throw a syntax error.