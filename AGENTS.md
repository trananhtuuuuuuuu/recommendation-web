# The overview about this project
This repository is a full-stack recommendation website. The backend is a Spring Boot application under the backend/ folder, exposing REST APIs (currently versioned under /api/v1). It uses layered architecture (controller -> service -> repository) with DTO/request/response models and a common ApiResponse envelope. The frontend is a React + TypeScript SPA under the frontend/ folder, built with Vite, TailwindCSS, and shadcn/ui component library, communicating with the backend over HTTP.

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

- frontend/
	- src/
		- main.tsx: React application entry point (mounts App into the DOM).
		- App.tsx: Root component — sets up React Router routes and top-level providers.
		- App.css / index.css: Global styles and TailwindCSS base configuration.
		- pages/: Full-page view components, one file per route. Key pages:
			- Index.tsx: Landing / home page.
			- Auth.tsx: Shared login page for all roles.
			- ApplicantRegistration.tsx / RecruiterRegistration.tsx: Registration forms.
			- Jobs.tsx: Browse all job listings.
			- JobDetail.tsx: Detail view for a single job.
			- JobApplicants.tsx: Recruiter view — applicants for a specific job.
			- JobDescriptions.tsx / PostEditJob.tsx: Recruiter job management.
			- Profile.tsx: Applicant profile view/edit.
			- Applicants.tsx / ApplicantDetail.tsx: Admin applicant management.
			- Recruiters.tsx / RecruiterDetail.tsx / RecruiterJobs.tsx: Recruiter management.
			- SavedJobs.tsx: Applicant saved jobs list.
			- Notifications.tsx: User notifications.
			- ApplicantAuth.tsx / RecruiterAuth.tsx: Role-specific auth guard redirect pages.
			- Forbidden.tsx / NotFound.tsx: Error pages.
		- components/: Reusable components.
			- Layout.tsx: Shared page layout (navbar, sidebar, footer wrapper).
			- NavLink.tsx: Styled navigation link component.
			- RouteGuard.tsx: Protects routes based on authentication/role from AuthContext.
			- ui/: All shadcn/ui primitives (Button, Input, Dialog, Table, Select, etc.).
		- contexts/
			- AuthContext.tsx: Global auth state (current user, token, login/logout). Consumed via useContext across the app.
		- hooks/
			- use-toast.ts: Toast notification hook (wraps sonner).
			- use-mobile.tsx: Hook to detect mobile viewport.
		- lib/
			- api.ts: Axios/fetch wrapper — base URL config, request interceptors, auth token injection.
			- jobsApi.ts: API call functions specific to job-related endpoints.
			- utils.ts: Shared utility helpers (e.g., cn() for class merging).
		- test/: Frontend unit/integration tests (Vitest + Testing Library).
	- public/: Static assets served as-is (favicon, images).
	- index.html: HTML shell Vite injects the React bundle into.
	- vite.config.ts: Vite build configuration (dev server, plugins).
	- tailwind.config.ts: TailwindCSS theme configuration.
	- components.json: shadcn/ui CLI configuration (component style and paths).
	- playwright.config.ts: End-to-end test configuration (Playwright).
	- tsconfig.json / tsconfig.app.json: TypeScript compiler settings.
	- .env: Frontend environment variables (e.g., VITE_API_BASE_URL pointing to the backend).

## Frontend Tech Stack
- Framework: React 18 + TypeScript, bundled with Vite.
- Routing: React Router DOM v6.
- UI Components: shadcn/ui (Radix UI primitives + TailwindCSS).
- Forms: React Hook Form + Zod validation.
- Data Fetching: TanStack Query (React Query v5).
- Animations: Framer Motion.
- Testing: Vitest (unit) + Playwright (e2e).
- Package manager: npm (also supports bun).

## Frontend Development Instructions
- All new pages go in src/pages/ and must be registered as a route in App.tsx.
- All new reusable components go in src/components/. Use shadcn/ui primitives from src/components/ui/ rather than writing raw HTML.
- All backend API calls must go through src/lib/api.ts (never call fetch/axios directly from pages).
- Route protection (authenticated/role-based) is handled via RouteGuard.tsx — wrap new protected routes with it.
- Auth state is read from AuthContext — never store tokens in component state.
- Run the dev server with: cd frontend && npm run dev (starts on port 3000).

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