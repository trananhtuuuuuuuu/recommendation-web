# The overview about this project
This repository contains the backend for the recommendation website. The backend is a Spring Boot application under the backend/ folder, exposing REST APIs (currently versioned under /api/v1). It uses layered architecture (controller -> service -> repository) with DTO/request/response models and a common ApiResponse envelope.

# The architecture of project (describ for me me each forder and subfolders responsible for what?)
- backend/
	- src/main/java/DATN/backend/
		- BackendApplication.java: Spring Boot entry point.
		- controller/
			- v1/: version 1 REST controllers (all new controllers should be added here).
			- v2/: reserved for future version 2 controllers.
		- dto/: DTOs used to transfer data between layers.
		- Enum/: shared enums such as status and gender.
		- exception/: custom exceptions and global error handling.
		- mapper/: mappers for converting between Request/DTO/Entity/Response.
		- model/: JPA entities and base model classes.
		- repository/: Spring Data JPA repositories for persistence.
		- request/: request payload classes, grouped by domain (applicant/, recruiter/).
		- response/: response payload classes, grouped by domain, plus ApiResponse.
		- service/
			- InterfaceService/: service interfaces.
			- ImplService/: service implementations.
		- utils/: shared helpers and utility classes.
	- src/main/resources/
		- application.yaml: Spring Boot configuration.
		- static/, templates/: static assets and template files if needed.
	- src/test/java/DATN/backend/: unit/integration tests for backend.
	- target/: build output (generated classes and resources).

# The follow at the backend side you should implement request -> controller and then controller catch request and validate and throw exception follow by "exception folder" and response follow ApiResponse class -> controller call to service and service mapper from Request to Entity and handle logic at there and call to Repository layer and then mapper again to Response to return for client via ApiResponse class (at service layer), the way set up the name for endpoint or class you should follow by everything already existed in my project.
Implementation flow (follow existing naming and patterns):
1) Define request model in request/<domain>/ (e.g., request/applicant/RegistrationApplicantRequest).
2) Add controller in controller/v1/ with endpoint prefix /api/v1/<resource> (follow current naming and URL style).
3) Validate request in controller or service; throw custom exceptions from exception/ (AlreadyExistException, ResourcesNotFoundException, etc.).
4) Controller returns ResponseEntity<ApiResponse> and delegates to service interfaces in service/InterfaceService.
5) Implement service in service/ImplService: map Request -> Entity (mapper/), handle business logic, call repository layer, then map Entity -> Response.
6) Service returns ApiResponse (message/status/error/data) to controller.
7) Keep class and endpoint naming consistent with existing controllers and packages.

Additional requirements for new APIs:
- All new controllers must be added in controller/v1/.
- After implementing each API, create an integration test under src/test/java/DATN/backend/.
- Run tests after changes; if any tests fail, fix the code and re-run until tests pass.
- Return all be error fields follow by ApiResponse and add those fields into errors field

## Entire currently Endpoints 
- api/v1/home → This is the home endpoint (anyone can access)

- api/v1/browse-jobs → This is the endpoint for showing all already jobs (anyone can access)

- api/v1/browse-jobs/id → This is the endpoint for showing a detail job (id is) (anyone can access)

- api/v1/browse-jobs/applicants/id → This is the endpoint for showing the number of applicants applied for the specific job (only recruiter posting this job can access this endpoint)

- api/v1/recruiters/jobs → This is the endpoint for showing all posted jobs by specific recruiter id (the only recruiter is logining can access this endpoint)

- api/v1/recruiters → This is the endpoint for showing all existing recruiter in this website (admin only)

- api/v1/registrations/recruiters → This is the endpoint for resgistration related to recruiter

api/v1/registrations/applicant → This is the endpoint for registration related to applicant

api/v1/auth → this is the endpoint for login (currently is username and password and then return response with access_token inside header for client)

api/v1/recruiters/jobs → endpoint for recruiter can post a job to website (need validate needed information for a recruiter)

api/v1/recruiters/jobs/id → endpoint for recruiter can edit a specific job (recruiter who post this job)

api/v1/recruiters/jobs/id → endpoint for recruiter can get a specific job 

api/v1/applicants → endpoint for showing all  existing applicants in website (admin only)

api/v1/applicants/id → endpoint for showing applicant’s profile 

api/v1/applicants/id → endpoint for applicant can edit their profile (authorized by token via applicant's information inside token)

api/v1/recruiters/id → endpoint for showing recruiter’s information

api/v1/applicants/saved-jobs → endpoint for showing all saved jobs by a specific applicant

api/v1/applicants/save/job → endpoint for saving a job to list job of a specific applicant

api/v1/applicants/upload-cv → endpoint for a specific applicant can upload their cv

## Implementation instructions for new features
- Let's write CRUD for each entity and you need redirect user to authentication page or authorization page in the approperiate scene and then the features i discribe you also implement for me.
- Add Swagger for each endpoint you implemented.
- Use JWT for authorization and authentication; when users refresh the page, re-validate tokens with a refresh time window you define.
- Create InforInsideToken.java class to store data for authorization and make endpoint access tracking easier.