# Project Features Deep Dive

Tài liệu này mô tả các feature chính của project recommendation website theo góc nhìn business, backend, frontend, AI, data flow và cách triển khai. Mục tiêu không chỉ là biết "feature làm được gì", mà còn hiểu tại sao thiết kế như vậy, ưu/nhược điểm là gì, và nếu cần maintain hoặc nâng cấp thì nên đi từ đâu.

> Lưu ý quan trọng về hiện trạng code:
>
> - Project hiện gọi cơ chế đăng nhập là JWT, nhưng `JwtService` đang tạo token HMAC tự xây dựng dạng `base64url(payload).signature`, không phải JWT chuẩn RFC 7519 dạng `header.payload.signature`. Frontend đã hỗ trợ decode biến thể này.
> - `SecurityConfig` hiện để `anyRequest().permitAll()`. Vì vậy filter vẫn đọc token và đưa thông tin vào `SecurityContext`, nhưng Spring Security chưa chặn mặc định toàn bộ protected endpoint. Một số endpoint tự kiểm tra quyền trong controller/service. Khi đưa lên production nên siết lại bằng `authenticated()` và rule theo role.
> - `ImplCvMatchService` hiện có thêm nhiễu Laplace vào match score. Về mặt privacy là một hướng bảo vệ, nhưng về nghiệp vụ recommendation có thể làm sai thứ tự ứng viên/công việc. Nếu ưu tiên ranking chính xác, nên dùng PII masking cho matching và dùng Differential Privacy chủ yếu cho applicant count.

## Tổng quan kiến trúc

Project gồm 3 khối chính:

| Khối | Công nghệ | Vai trò |
|---|---|---|
| Frontend | React, TypeScript, Vite, TailwindCSS, shadcn/ui | Hiển thị UI, route guard, gọi API, lưu token phía client |
| Backend | Spring Boot, Spring Security, Spring Data JPA, PostgreSQL | REST API, business logic, validation, authorization, persistence, gọi AI service |
| AI service | FastAPI, Python, LayoutLMv3, OCR, TF-IDF/Embedding/SVM | Trích xuất CV, chuẩn hóa CV, matching CV-JD, masking PII, hard filter, suggestion |

Luồng chuẩn của đa số feature:

```text
User thao tác UI
-> Frontend page/component
-> frontend/src/lib/api.ts hoặc jobsApi.ts
-> Backend controller
-> Service
-> Mapper/Repository/AI client nếu cần
-> Database hoặc AI service
-> Response ApiResponse
-> Frontend render/toast/navigation
```

## Feature 1: Đăng ký tài khoản ứng viên và nhà tuyển dụng

### Business logic

Stakeholder cần:

- Ứng viên có thể tạo tài khoản để quản lý hồ sơ, upload CV, lưu job, ứng tuyển và xem điểm phù hợp.
- Nhà tuyển dụng có thể tạo tài khoản để quản lý thông tin công ty, đăng job và xem ứng viên.
- Hệ thống phải phân biệt role ngay từ khi đăng ký: `APPLICANT` hoặc `RECRUITER`.
- Username và email phải duy nhất để tránh trùng định danh đăng nhập.
- Mật khẩu không được lưu plain text.

Technical team cần:

- Tạo request DTO riêng cho applicant/recruiter registration.
- Validate input.
- Kiểm tra trùng username/email.
- Hash password bằng `PasswordEncoder`.
- Tạo hoặc lấy role tương ứng.
- Lưu entity con `Applicant` hoặc `Recruiter`, kế thừa thông tin từ `User`.
- Trả response theo envelope chung `ApiResponse`.

### Backend làm gì

Code liên quan:

- `ApplicantRegistrationController`
- `RecruiterRegistrationController`
- `ImplApplicantService.registerApplicant`
- `ImplRecruiterService.registerRecruiter`
- `ApplicantMapper`
- `RecruiterMapper`
- `UserRepository`, `RoleRepository`, `ApplicantRepository`, `RecruiterRepository`

Backend nhận request:

```text
POST /api/v1/registrations/applicant
POST /api/v1/registrations/recruiters
```

Các bước backend:

1. Controller nhận JSON body và validate bằng `@Valid`.
2. Service kiểm tra username đã tồn tại chưa qua `userRepository.findByUserName`.
3. Service kiểm tra email đã tồn tại chưa qua `userRepository.findByEmail`.
4. Service lấy role từ request, nếu không có thì mặc định:
   - Applicant: `APPLICANT`
   - Recruiter: `RECRUITER`
5. Nếu role chưa tồn tại, tạo role mới bằng `roleRepository.save`.
6. Mapper chuyển request sang entity.
7. Password được hash bằng `BCryptPasswordEncoder`.
8. Entity được lưu xuống database.
9. Mapper chuyển entity sang response DTO.
10. Controller bọc response bằng `ApiResponse.success`.

### Frontend làm gì

Code liên quan:

- `ApplicantRegistration.tsx`
- `RecruiterRegistration.tsx`
- `jobsApi.ts`: `registerApplicant`, `registerRecruiter`
- `api.ts`: `apiRequest`

Frontend:

1. User nhập form đăng ký.
2. Form gom data thành object JSON.
3. Gọi `registerApplicant` hoặc `registerRecruiter`.
4. `apiRequest` gửi request không cần token vì đây là public endpoint.
5. Nếu thành công, UI có thể toast và điều hướng sang login.
6. Nếu lỗi duplicate username/email, UI hiển thị message từ `ApiResponse.errors`.

### AI làm gì

Không có AI trong feature đăng ký.

### Flow data

```text
Registration form
-> jobsApi.registerApplicant/registerRecruiter
-> apiRequest
-> RegistrationController
-> ImplApplicantService/ImplRecruiterService
-> UserRepository kiểm tra trùng
-> RoleRepository lấy/tạo role
-> PasswordEncoder hash password
-> ApplicantRepository/RecruiterRepository save
-> ApiResponse
-> Frontend toast/navigation
```

### Cách tiếp cận và lý do

Có 2 cách phổ biến:

- Một bảng `users` duy nhất chứa mọi field của mọi role.
- Một bảng user base và bảng role-specific như `applicants`, `recruiters`.

Project đang dùng hướng thứ hai: `Applicant` và `Recruiter` là các loại user có dữ liệu riêng. Cách này hợp lý vì applicant có CV, status, privacy visibility; recruiter có company profile, company name, tax code, website.

Step-by-step implementation:

1. Định nghĩa request class cho từng role.
2. Tạo controller endpoint public.
3. Trong service, kiểm tra unique username/email.
4. Dùng `PasswordEncoder` để hash password.
5. Gắn role tương ứng.
6. Lưu entity.
7. Trả registration response, không trả password.
8. Viết test duplicate username/email và đăng ký thành công.

## Feature 2: Đăng nhập, token, refresh platform và authorization

### Business logic

Stakeholder cần:

- User đăng nhập một lần, sau đó refresh website vẫn giữ trạng thái đăng nhập trong thời gian token còn hạn.
- Hệ thống biết user hiện tại là ai.
- Hệ thống biết user có role gì để cho phép hoặc chặn route/action.
- Frontend có thể redirect user chưa đăng nhập về trang auth.
- Backend có thể kiểm tra request nào thuộc applicant/recruiter/admin nào.

Technical team cần:

- Login bằng username/password.
- Verify password hash.
- Sinh token có thông tin tối thiểu: user id, username, email, role, issued time, expiry time.
- Frontend lưu token.
- Mỗi request cần auth phải gửi `Authorization: Bearer <token>`.
- Backend filter đọc token, verify signature và expiry, sau đó đưa principal vào `SecurityContext`.

### JWT chuẩn là gì

JWT chuẩn thường có 3 phần:

```text
header.payload.signature
```

#### Header

Header mô tả loại token và thuật toán ký:

```json
{
  "typ": "JWT",
  "alg": "HS256"
}
```

Header được JSON stringify rồi Base64URL encode.

#### Payload

Payload chứa claims. Claims là dữ liệu muốn gắn vào token, ví dụ:

```json
{
  "sub": "nguyenvana",
  "userId": 12,
  "email": "a@example.com",
  "role": "APPLICANT",
  "iat": 1730000000,
  "exp": 1730003600
}
```

Payload cũng được JSON stringify rồi Base64URL encode. Payload không được mã hóa, chỉ được encode. Ai có token đều có thể decode payload để đọc dữ liệu, vì vậy không nên đặt dữ liệu nhạy cảm vào token.

#### Signature

Signature dùng để chống sửa token:

```text
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secretKey
)
```

Nếu client tự sửa `role` từ `APPLICANT` thành `ADMIN`, chữ ký sẽ không còn khớp. Server verify lại signature bằng secret key. Nếu signature sai thì token bị từ chối.

Điểm cần nhớ: JWT thường là ký, không phải mã hóa. Ký giúp phát hiện token bị sửa. Mã hóa mới giúp che nội dung.

### Hiện trạng token trong project

Code liên quan:

- `JwtService`
- `JwtAuthenticationFilter`
- `SecurityConfig`
- `ImplAuthService`
- `InforInsideToken`
- `AuthContext.tsx`
- `api.ts`

Project hiện tạo token như sau:

```text
payload = userId|userName|email|roleName|issuedAt|expiresAt
encodedPayload = Base64URL(payload)
signature = HMACSHA256(encodedPayload, secret)
token = encodedPayload + "." + signature
```

Token này có ý tưởng giống JWT ở phần payload + signature, nhưng thiếu header chuẩn. Vì vậy nên gọi chính xác là "custom HMAC bearer token" hoặc nâng cấp sang JWT chuẩn nếu viết báo cáo nghiêm ngặt.

### Backend làm gì

Endpoint:

```text
POST /api/v1/auth
```

Flow backend:

1. `AuthController.login` nhận `LoginRequest`.
2. `ImplAuthService.login` tìm user bằng username.
3. Dùng `passwordEncoder.matches(rawPassword, hashedPassword)` để kiểm tra password.
4. Lấy role từ `user.getRole()`.
5. Tạo `InforInsideToken`.
6. `JwtService.generateToken` tạo token.
7. Controller trả token trong body và header `Authorization: Bearer <token>`.

Khi request sau đó gửi lên:

1. `JwtAuthenticationFilter` chạy một lần trên mỗi request.
2. Filter đọc header `Authorization`.
3. Nếu header bắt đầu bằng `Bearer `, lấy token phía sau.
4. `JwtService.parseToken` decode payload, verify signature, kiểm tra expiry.
5. Nếu hợp lệ, tạo `UsernamePasswordAuthenticationToken`.
6. Gắn principal là `InforInsideToken`.
7. Gắn authority là `ROLE_<roleName>`.
8. Đưa authentication vào `SecurityContextHolder`.
9. Controller có thể đọc `Authentication authentication`.

### Frontend làm gì

Code liên quan:

- `Auth.tsx`
- `ApplicantAuth.tsx`
- `RecruiterAuth.tsx`
- `AuthContext.tsx`
- `RouteGuard.tsx`
- `api.ts`

Frontend:

1. User nhập username/password.
2. `AuthContext.login` gọi `POST /api/v1/auth`.
3. Nếu response có token, `setToken` lưu token vào `localStorage` và `sessionStorage`.
4. `decodeJwt` decode token để lấy role/userId/expiry. Function này đã hỗ trợ cả token chuẩn 3 phần và token custom 2 phần của project.
5. `AuthContext` lưu `user`, `role`, `isAuthenticated`.
6. `apiRequest` tự gắn `Authorization: Bearer <token>` vào request nếu `auth !== false`.
7. Khi refresh page, `AuthProvider` đọc lại token từ storage.
8. Nếu token hết hạn theo `exp`, frontend clear token và user.
9. Nếu API trả `401`, `apiRequest` clear token và dispatch event `auth:expired`.
10. `RouteGuard` kiểm tra role để cho hoặc chặn route.

### AI làm gì

Không có AI trong feature auth.

### Flow data

```text
Login form
-> AuthContext.login
-> apiRequest POST /api/v1/auth
-> AuthController
-> ImplAuthService
-> UserRepository
-> PasswordEncoder.matches
-> JwtService.generateToken
-> LoginResponse + Authorization header
-> Frontend lưu token
-> Request tiếp theo gắn Authorization Bearer
-> JwtAuthenticationFilter
-> JwtService.parseToken
-> SecurityContext
-> Controller/service đọc Authentication khi cần
```

### Cách tiếp cận và lý do

Có 2 mô hình chính:

| Mô hình | Cách hoạt động | Ưu điểm | Nhược điểm |
|---|---|---|---|
| Stateful session | Server lưu session, client giữ session id trong cookie | Dễ revoke session, phù hợp app truyền thống | Server phải lưu trạng thái, khó scale nếu không có shared session store |
| Stateless token | Server không lưu session, client gửi token mỗi request | Dễ scale, phù hợp REST API/mobile/SPA | Revoke token khó hơn, cần expiry/refresh strategy |

Project chọn hướng stateless token vì frontend là SPA và backend REST API. Server không cần nhớ session, chỉ cần verify token.

Step-by-step implementation đúng chuẩn nên làm:

1. Thêm dependency Spring Security.
2. Tạo `PasswordEncoder` bean, ưu tiên BCrypt.
3. Tạo login endpoint public.
4. Hash password khi register.
5. Verify password khi login.
6. Tạo JWT chuẩn `header.payload.signature` bằng thư viện như `jjwt` hoặc `java-jwt`.
7. Cấu hình secret key và expiration trong `application.yaml` hoặc env var.
8. Tạo filter đọc `Authorization: Bearer`.
9. Verify signature và expiry.
10. Tạo Authentication object với principal và authorities.
11. Cấu hình `SecurityFilterChain` stateless.
12. Permit public endpoints: home, auth, registration, browse jobs.
13. Protect private endpoints bằng `authenticated()` và role rules.
14. Frontend lưu token, gắn token vào request, kiểm tra expiry khi refresh.
15. Viết test login thành công, sai password, token expired, endpoint forbidden.

Nâng cấp đề xuất cho project:

1. Đổi `JwtService` sang JWT chuẩn 3 phần.
2. Thêm `app.jwt.secret` và `app.jwt.expiration-minutes` từ env var, không dùng default secret trong production.
3. Sửa `SecurityConfig.anyRequest().permitAll()` thành `anyRequest().authenticated()`.
4. Dùng `requestMatchers` hoặc `@PreAuthorize` để phân quyền.
5. Không đặt email/PII không cần thiết vào token nếu không cần.

## Feature 3: Trang chủ và thống kê tổng quan

### Business logic

Stakeholder cần:

- Người dùng mới nhìn thấy website đang có bao nhiêu việc làm, nhà tuyển dụng, ứng viên.
- Trang chủ là public, không cần đăng nhập.
- Số liệu giúp tăng độ tin cậy và làm dashboard đơn giản.

### Backend làm gì

Code liên quan:

- `HomePagecontroller`
- `JobRepository`
- `ApplicantRepository`
- `RecruiterRepository`

Endpoint:

```text
GET /api/v1/home
```

Backend đếm:

- `jobDescriptionRepository.count()`
- `applicantRepository.count()`
- `recruiterRepository.count()`

Sau đó trả về:

```json
{
  "welcome": "Welcome to recommendation website backend",
  "jobsPosted": 100,
  "activeApplicants": 200,
  "recruiters": 20
}
```

### Frontend làm gì

Code liên quan:

- `Index.tsx`
- `jobsApi.fetchHome`

Frontend gọi endpoint public, render các metric card hoặc section tổng quan.

### AI làm gì

Không có AI.

### Flow data

```text
Home page
-> fetchHome()
-> GET /api/v1/home
-> HomePagecontroller
-> repositories count()
-> ApiResponse
-> frontend render metrics
```

### Cách tiếp cận

Cách đơn giản nhất là count trực tiếp từ repository. Với dữ liệu nhỏ/trung bình thì đủ. Khi dữ liệu rất lớn, có thể dùng materialized view, cache hoặc bảng thống kê riêng.

Step-by-step:

1. Tạo public endpoint `/api/v1/home`.
2. Inject repository cần count.
3. Trả DTO/map số liệu.
4. Frontend gọi API khi page load.
5. Nếu cần performance, cache count trong vài phút.

## Feature 4: Duyệt, phân trang và xem chi tiết việc làm

### Business logic

Stakeholder cần:

- Applicant hoặc visitor có thể xem danh sách job đang tuyển.
- Có thể mở chi tiết một job để đọc mô tả, yêu cầu, quyền lợi, deadline.
- Danh sách phải phân trang để không tải quá nhiều dữ liệu.

### Backend làm gì

Code liên quan:

- `BrowseJobController`
- `ImplJobService`
- `JobRepository`
- `JobMapper`
- `PageResponse`

Endpoints:

```text
GET /api/v1/browse-jobs?page=0&size=10&sort=id,desc
GET /api/v1/browse-jobs/{jobId}
```

Backend:

1. Controller nhận `page`, `size`, `sort`.
2. Chuẩn hóa page >= 0, size trong khoảng 1..20.
3. Chỉ cho sort theo field đã whitelist: `jobTitle`, `location`, `jobType`, `postedDate`, default `id`.
4. Tạo `Pageable`.
5. Service gọi `jobDescriptionRepository.findAll(pageable)`.
6. Mapper chuyển `Job` sang `JobResponse`.
7. `PageResponse.from` bọc content và metadata.

### Frontend làm gì

Code liên quan:

- `Jobs.tsx`
- `JobDetail.tsx`
- `jobsApi.fetchJobsPage`
- `jobsApi.fetchJob`

Frontend:

1. Page jobs gọi `fetchJobsPage`.
2. Render danh sách job.
3. User click job.
4. Router mở `/jobs/:id`.
5. `JobDetail` gọi `fetchJob(id)`.
6. Render detail và các action như save/apply/match nếu user là applicant.

### AI làm gì

Không có AI trong việc duyệt job cơ bản. AI chỉ tham gia khi user yêu cầu match CV với job.

### Flow data

```text
Jobs page
-> fetchJobsPage
-> BrowseJobController.getAllJobs
-> ImplJobService.getAllJobs(Pageable)
-> JobRepository.findAll(pageable)
-> JobMapper.toResponse
-> PageResponse
-> Frontend render list
```

### Cách tiếp cận

Project dùng server-side pagination. Đây là lựa chọn đúng vì danh sách job có thể tăng lớn. Frontend không nên tải toàn bộ rồi tự phân trang nếu dữ liệu lớn.

Step-by-step:

1. Thiết kế endpoint list có `page`, `size`, `sort`.
2. Whitelist sort fields để tránh query field không mong muốn.
3. Repository trả `Page<Job>`.
4. Mapper sang DTO.
5. Frontend giữ page state.
6. Khi filter/search nâng cấp, thêm query params như `keyword`, `location`, `jobType`, `minSalary`.
7. Backend thêm query method hoặc Specification/Criteria.

## Feature 5: Quản lý hồ sơ ứng viên

### Business logic

Stakeholder cần:

- Ứng viên xem và cập nhật hồ sơ cá nhân.
- Admin xem danh sách ứng viên.
- Nhà tuyển dụng chỉ được xem thông tin mà ứng viên cho phép.
- Hồ sơ gồm user info và CV info: tên, email, phone, address, objective, skills, experience, education, certifications.

### Backend làm gì

Code liên quan:

- `ApplicantController`
- `ImplApplicantService`
- `ApplicantMapper`
- `ApplicantRepository`
- `UpdateApplicantRequest`
- `UpdateApplicantPrivacyRequest`

Endpoints:

```text
GET /api/v1/applicants
GET /api/v1/applicants/{applicantId}
PUT /api/v1/applicants/{applicantId}
PUT /api/v1/applicants/{applicantId}/privacy
```

Backend:

1. Controller nhận request.
2. Với get profile, controller xác định `fullAccess`:
   - Admin: full access.
   - Applicant chính chủ: full access.
   - Người khác: recruiter-visible view.
3. Service lấy applicant.
4. Mapper trả full response hoặc privacy-filtered response.
5. Update profile dùng mapper cập nhật entity.
6. Update privacy chỉ cho applicant chính chủ qua `verifyApplicantAccess`.

### Frontend làm gì

Code liên quan:

- `Profile.tsx`
- `ApplicantDetail.tsx`
- `Applicants.tsx`
- `jobsApi.fetchApplicant`
- `jobsApi.updateApplicant`
- `jobsApi.updateApplicantPrivacy`

Frontend:

1. Authenticated applicant vào `/profiles`.
2. UI load applicant id từ `AuthContext`.
3. Gọi `fetchApplicant`.
4. Render form profile/CV.
5. User edit fields.
6. Gọi `updateApplicant`.
7. User bật/tắt privacy switches.
8. Gọi `updateApplicantPrivacy`.

### AI làm gì

Không bắt buộc. AI có thể tạo dữ liệu gợi ý cho profile qua feature CV analysis, nhưng cập nhật profile là web/backend feature.

### Flow data

```text
Profile page
-> fetchApplicant(applicantId)
-> ApplicantController.getApplicantById
-> hasFullApplicantAccess(authentication)
-> ImplApplicantService.getApplicantById
-> ApplicantRepository.findById
-> ApplicantMapper.toApplicantResponse(fullAccess)
-> UI render
```

### Cách tiếp cận

Tách full view và recruiter-visible view là đúng vì cùng một applicant nhưng mỗi audience được thấy dữ liệu khác nhau. Nếu không tách ở mapper, frontend có thể vô tình nhận dữ liệu nhạy cảm rồi chỉ ẩn bằng UI. Cách đó không an toàn.

Step-by-step:

1. Lưu các flag visibility trong `Applicant`.
2. Khi trả response cho owner/admin, trả full.
3. Khi trả response cho recruiter/other user, gọi mapper privacy-filtered.
4. Không gửi field bị ẩn về frontend.
5. Thêm notice `privacyNotice` để UI biết đang bị privacy-filter.
6. Test owner thấy full, recruiter không thấy email/phone nếu bị ẩn.

## Feature 6: Consent visibility và privacy profile

### Business logic

Stakeholder cần:

- Ứng viên kiểm soát hồ sơ của mình.
- Nhà tuyển dụng chỉ xem được những phần ứng viên cho phép.
- Hệ thống giảm rủi ro lộ email, phone, address, CV file.

Đây là feature privacy ở tầng Web/Application, không phải AI.

### Backend làm gì

Code liên quan:

- `Applicant.profileVisibleToRecruiters`
- `Applicant.showFullName`
- `Applicant.showContactInfo`
- `Applicant.showAddress`
- `Applicant.showCvFile`
- `Applicant.showObjective`
- `Applicant.showSkills`
- `Applicant.showExperience`
- `Applicant.showEducation`
- `Applicant.showCertifications`
- `ApplicantMapper.toRecruiterVisibleApplicantResponse`

Backend:

1. Lưu setting privacy trên applicant.
2. Khi recruiter xem applicant, mapper kiểm tra từng flag.
3. Field nào bị ẩn thì trả `null`.
4. Nếu full name bị ẩn thì trả tên ẩn danh.
5. Nếu contact info bị ẩn thì email/phone null.
6. Nếu CV file bị ẩn thì `cvFileUrl` null.

### Frontend làm gì

Frontend:

1. Profile page hiển thị switch/checkbox visibility.
2. User bật/tắt từng phần.
3. Gọi `PUT /api/v1/applicants/{applicantId}/privacy`.
4. Recruiter view chỉ render dữ liệu nhận được.
5. Nếu có `privacyApplied`, UI có thể hiển thị thông báo.

### AI làm gì

Không có AI. Cơ chế này kiểm soát người dùng khác nhìn thấy gì, không kiểm soát model dùng dữ liệu gì. AI privacy dùng PII masking riêng.

### Flow data

```text
Applicant toggles privacy
-> updateApplicantPrivacy
-> ApplicantController.verifyApplicantAccess
-> ImplApplicantService.updateApplicantPrivacy
-> ApplicantMapper.updateApplicantPrivacy
-> ApplicantRepository.save
-> Later recruiter views applicant
-> ApplicantMapper.toRecruiterVisibleApplicantResponse
-> hidden fields become null
```

### Cách tiếp cận

Có 2 cách:

- Ẩn ở frontend: không an toàn vì API vẫn trả data.
- Ẩn ở backend response: an toàn hơn vì client không nhận data nhạy cảm.

Project dùng backend response filtering, đây là hướng đúng.

Step-by-step:

1. Xác định các field có thể ẩn.
2. Thêm boolean flag vào entity.
3. Tạo request update privacy.
4. Chỉ cho owner update setting.
5. Mapper trả response theo audience.
6. Frontend chỉ render response nhận được.
7. Test privacy bằng API, không chỉ bằng UI.

## Feature 7: Upload CV metadata và lưu file CV

### Business logic

Stakeholder cần:

- Ứng viên lưu CV vào profile.
- Có thể upload file thật hoặc lưu metadata đã trích xuất/chỉnh sửa.
- Nếu upload lại CV thì cập nhật CV cũ thay vì tạo nhiều record gây rối.
- Có thể xóa file CV đã upload.

### Backend làm gì

Code liên quan:

- `ApplicantController.uploadCv`
- `ApplicantController.uploadCvMetadata`
- `ApplicantController.deleteUploadedCvFile`
- `ImplApplicantService.uploadCv`
- `ImplApplicantService.storeCvFile`
- `UploadCvRequest`
- `Cv`, `Experience`, `Education`, `Certificate`

Endpoints:

```text
POST /api/v1/applicants/upload-cv/{applicantId}
Content-Type: multipart/form-data

POST /api/v1/applicants/upload-cv/{applicantId}
Content-Type: application/json

DELETE /api/v1/applicants/{applicantId}/cv-file
```

Backend upload flow:

1. Controller nhận `UploadCvRequest` bằng `@ModelAttribute` nếu multipart hoặc `@RequestBody` nếu JSON.
2. `UploadCvRequest` có custom setter để parse `experience`, `education`, `certifications` từ object, array JSON hoặc legacy text.
3. Service tìm applicant.
4. Nếu có `MultipartFile cvFile`, validate content type.
5. File được lưu vào thư mục `uploads/cvs`.
6. File name được tạo bằng UUID để tránh trùng và tránh lộ tên file gốc.
7. URL lưu trong DB dạng `/uploads/cvs/<uuid>.<ext>`.
8. Nếu applicant chưa có CV, tạo `Cv` mới và link vào applicant.
9. Nếu đã có CV, update CV hiện tại in-place.
10. Lưu relation `Experience`, `Education`, `Certificate` nếu là object mới.
11. Nếu thay file, xóa file cũ.

### Frontend làm gì

Code liên quan:

- `Profile.tsx`
- `jobsApi.uploadCv`
- `jobsApi.deleteUploadedCvFile`

Frontend:

1. User chọn file.
2. Frontend tạo `FormData`.
3. Append file vào key `cvFile`.
4. Append các field metadata nếu cần.
5. Gọi `uploadCv(applicantId, formData)`.
6. `apiRequest` thấy `isForm=true` thì không set `Content-Type: application/json`; browser tự set multipart boundary.
7. UI cập nhật CV preview/profile.

### AI làm gì

Feature upload metadata/file không bắt buộc AI. AI analysis là feature riêng. Có thể kết hợp như sau:

1. User chọn CV.
2. Frontend gọi analyze CV.
3. AI trả suggested fields.
4. User review/chỉnh sửa.
5. Frontend gọi upload CV để persist.

### Flow data

```text
User selects CV file
-> FormData
-> POST /api/v1/applicants/upload-cv/{applicantId}
-> ApplicantController
-> ImplApplicantService.uploadCv
-> validate file/content type
-> Files.copy to uploads/cvs
-> ApplicantMapper.toCv/updateCv
-> save Experience/Education/Certificate
-> CvRepository.save
-> ApplicantRepository.save if first CV
-> CvResponse
-> Frontend render saved CV
```

### Cách tiếp cận

Có 3 cách lưu CV:

| Cách | Ưu điểm | Nhược điểm |
|---|---|---|
| Lưu file binary trong DB | Backup cùng DB, dễ transaction | DB phình lớn, query chậm, khó serve static |
| Lưu file trên local disk và lưu URL trong DB | Dễ làm, phù hợp đồ án/local Docker | Cần quản lý volume, scale multi-server khó |
| Lưu object storage như S3/MinIO | Production-friendly | Setup phức tạp hơn |

Project dùng local disk + URL trong DB. Đây là lựa chọn hợp lý cho đồ án và local deployment.

Step-by-step:

1. Tạo `Cv` entity chứa metadata và `cvFileUrl`.
2. Tạo endpoint multipart.
3. Validate extension/content type.
4. Dùng UUID file name.
5. Tạo thư mục upload nếu chưa có.
6. Lưu file bằng `Files.copy`.
7. Lưu URL vào `Cv`.
8. Khi update, giữ URL cũ nếu không upload file mới.
9. Khi thay file, xóa file cũ.
10. Khi delete file, set `cvFileUrl = null`.

## Feature 8: AI CV analysis và autofill profile

### Business logic

Stakeholder cần:

- Ứng viên upload CV và hệ thống tự trích xuất thông tin thay vì nhập tay từng section.
- Kết quả trích xuất phải đủ rõ để user review trước khi lưu.
- Hệ thống hỗ trợ nhiều định dạng: PDF, DOC, DOCX, ảnh.
- Nếu model LayoutLMv3 chưa có, vẫn có fallback heuristic để không làm feature chết hoàn toàn.

Technical team cần:

- Frontend gửi file CV lên backend bằng multipart.
- Backend validate file, chuyển file sang AI service.
- AI service đọc file, extract text/OCR, chạy LayoutLMv3 nếu có model, postprocess thành JSON.
- Backend deserialize JSON response thành `CvAnalysisResponse`.
- Frontend render suggested fields và cho user apply vào form.

### Backend làm gì

Code liên quan:

- `ApplicantController.analyzeCv`
- `ImplCvAiService.analyzeCv`
- `CvAnalysisResponse`
- `AiServiceUnavailableException`

Endpoint backend:

```text
POST /api/v1/applicants/{applicantId}/analyze-cv
Content-Type: multipart/form-data
field: cvFile
```

Backend flow:

1. Controller nhận `MultipartFile cvFile`.
2. Controller gọi `verifyApplicantAccess`, chỉ applicant chính chủ được analyze.
3. `ImplCvAiService.validateFile` kiểm tra:
   - File không rỗng.
   - Tối đa 15 MB.
   - Extension hợp lệ: PDF, DOC, DOCX, PNG, JPG, JPEG, WebP, BMP, TIF, TIFF.
4. Backend đọc bytes từ `MultipartFile`.
5. Tạo `ByteArrayResource` để gửi lại như một file part.
6. Dùng `RestClient` gọi AI service:

```text
POST {app.ai.base-url}/parse-cv
Content-Type: multipart/form-data
field: file
```

7. Nhận response JSON và map sang `CvAnalysisResponse`.
8. Nếu AI trả 4xx, backend trả lỗi "uploaded CV could not be analyzed".
9. Nếu AI down/timeout, backend ném `AiServiceUnavailableException` và global exception trả `503`.

### Frontend làm gì

Code liên quan:

- `Profile.tsx`
- `jobsApi.analyzeCv`

Frontend:

1. User chọn file CV.
2. Frontend tạo `FormData`.
3. Append `cvFile`.
4. Gọi `analyzeCv(applicantId, file)`.
5. Hiển thị loading state vì AI có thể chậm hơn API thường.
6. Nhận các field như `fullName`, `detectedEmail`, `phone`, `address`, `objective`, `skills`, `experience`, `education`, `certifications`.
7. User review/chỉnh sửa.
8. Nếu đồng ý, frontend gọi upload CV metadata/file để lưu vào DB.

### AI làm gì

Code liên quan:

- `ai/app/main.py`
- `ai/app/parser.py`
- `ai/app/postprocess.py`
- `ai/train_layoutlmv3_cv.ipynb`

Endpoint AI:

```text
POST /parse-cv
field: file
```

Input của AI:

- `UploadFile` từ FastAPI.
- Nội dung file được đọc thành `bytes`.
- Filename dùng để xác định suffix: `.pdf`, `.docx`, `.doc`, image.

Output của AI:

```json
{
  "fullName": "...",
  "detectedEmail": "...",
  "phone": "...",
  "address": "...",
  "objective": "...",
  "skills": ["Java", "Spring Boot"],
  "experience": [
    {
      "companyName": "...",
      "position": "...",
      "time": "...",
      "description": "...",
      "skills": "",
      "certificates": ""
    }
  ],
  "education": ["..."],
  "certifications": ["..."],
  "extractionMode": "layoutlmv3",
  "confidence": 0.88,
  "warnings": []
}
```

AI processing chi tiết:

1. `_read_upload` đọc file bytes, kiểm tra file không rỗng và không quá 15 MB.
2. `CvParser.parse(content, filename)` được gọi.
3. Parser xác định loại file.
4. Với PDF text-based, dùng PyMuPDF `page.get_text("text")`.
5. Với DOCX, dùng `python-docx` đọc paragraphs và table cells.
6. Với DOC, dùng `antiword`.
7. Với ảnh hoặc PDF scan, chuyển page thành image và OCR.
8. Nếu `AI_WITH_MODEL=true` và model được mount, parser chạy LayoutLMv3.
9. OCR tạo list `words` và `boxes`.
10. Box pixel được normalize về hệ tọa độ 0..1000.
11. LayoutLMv3 processor nhận:
    - image
    - words
    - boxes
    - max_length 512
12. Model token classification dự đoán label BIO cho từng token, ví dụ `B-SKILL`, `I-SKILL`, `B-EMAIL`, `O`.
13. Parser gom token liên tiếp thành `EntitySpan`.
14. `postprocess.build_profile` gom entity thành profile fields.
15. Nếu không có model, heuristic dùng regex/section extraction để tìm email, phone, link, skills, education.

### LayoutLMv3 input/output dễ hiểu

Một CV file không đi thẳng vào model như "PDF raw". Nó phải được chuyển thành dạng model hiểu được:

```text
File CV
-> image pages
-> OCR words
-> bounding boxes của từng word
-> normalized boxes 0..1000
-> processor tokenize words
-> tensors
-> model token classification
-> labels per token
-> entity spans
-> structured JSON
```

Ví dụ:

```text
Words: ["Nguyen", "Van", "A", "Java", "Spring", "Boot"]
Boxes: [[50,40,120,60], ...]
Predicted labels: ["B-NAME", "I-NAME", "I-NAME", "B-SKILL", "I-SKILL", "I-SKILL"]
Output spans:
- NAME: "Nguyen Van A"
- SKILL: "Java Spring Boot"
```

### Flow data

```text
Profile page
-> user selects CV
-> analyzeCv(applicantId, file)
-> apiRequest multipart
-> ApplicantController.analyzeCv
-> verifyApplicantAccess
-> ImplCvAiService.validateFile
-> RestClient multipart POST AI /parse-cv
-> FastAPI parse_cv
-> CvParser.parse
-> extract text/OCR/LayoutLMv3/postprocess
-> JSON CvAnalysisResponse
-> Backend ApiResponse
-> Frontend render suggested fields
-> user reviews
-> uploadCv persists selected fields
```

### Cách tiếp cận và lý do

Vì backend Java và AI Python khác runtime, cách tốt nhất là giao tiếp qua HTTP API. Không cần Java import Python model. Backend chỉ biết gửi file và nhận JSON.

Các cách khác:

| Cách | Nhận xét |
|---|---|
| Chạy model trực tiếp trong Java | Khó vì ecosystem NLP/document AI mạnh hơn ở Python |
| Backend gọi Python script bằng process | Dễ demo nhưng khó scale, khó timeout, khó deploy |
| AI service riêng qua HTTP | Rõ boundary, dễ scale, phù hợp microservice |

Project dùng AI service riêng qua FastAPI, đây là hướng hợp lý.

Step-by-step implementation:

1. Tạo FastAPI app với endpoint `/parse-cv`.
2. Tạo parser nhận bytes + filename.
3. Hỗ trợ text extraction cho PDF/DOCX/DOC.
4. Hỗ trợ OCR cho image/PDF scan.
5. Load LayoutLMv3 model nếu `AI_WITH_MODEL=true`.
6. Chuẩn hóa OCR output thành words + boxes.
7. Chạy token classification.
8. Postprocess entity spans thành profile JSON.
9. Backend tạo AI client bằng `RestClient`.
10. Backend validate file trước khi gọi AI.
11. Backend gửi multipart.
12. Frontend render suggested fields.
13. User review rồi persist bằng upload CV.

## Feature 9: Lưu việc làm, ứng tuyển và quản lý job đã lưu/đã ứng tuyển

### Business logic

Stakeholder cần:

- Ứng viên lưu job để xem sau.
- Ứng viên ứng tuyển job.
- Ứng viên xem danh sách job đã lưu và đã ứng tuyển.
- Ứng viên có thể bỏ lưu hoặc rút đơn ứng tuyển.
- Một applicant không nên lưu/ứng tuyển trùng cùng một job.

### Backend làm gì

Code liên quan:

- `ApplicantController.saveJob`
- `ApplicantController.applyJob`
- `ApplicantController.getSavedJobs`
- `ApplicantController.getAppliedJobs`
- `ApplicantController.removeSavedJob`
- `ApplicantController.withdrawApplication`
- `ImplApplicantService`
- `ApplicantJobRepository`
- `ApplicantJob`

Endpoints:

```text
POST /api/v1/applicants/save/job
POST /api/v1/applicants/apply/job
GET /api/v1/applicants/saved-jobs?applicantId=...
GET /api/v1/applicants/applied-jobs?applicantId=...
DELETE /api/v1/applicants/{applicantId}/saved-jobs/{applicantJobId}
DELETE /api/v1/applicants/{applicantId}/applied-jobs/{applicantJobId}
```

Backend:

1. Request chứa `applicantId` và `jobId` hoặc `jobDescriptionId`.
2. Service tìm applicant và job.
3. Với save, kiểm tra relation đã tồn tại với `actionType = "SAVED"`.
4. Với apply, kiểm tra relation đã tồn tại với `actionType = "APPLIED"`.
5. Tạo `ApplicantJob(applicant, job, actionType)`.
6. Lưu xuống DB.
7. List saved/applied dùng pageable.
8. Delete/withdraw kiểm tra applicant sở hữu relation rồi xóa.

### Frontend làm gì

Code liên quan:

- `JobDetail.tsx`
- `SavedJobs.tsx`
- `jobsApi.saveJob`
- `jobsApi.applyJob`
- `jobsApi.fetchSavedJobs`
- `jobsApi.fetchAppliedJobs`
- `jobsApi.removeSavedJob`
- `jobsApi.withdrawApplication`

Frontend:

1. Applicant click Save hoặc Apply trên job detail.
2. Frontend lấy applicantId từ auth user.
3. Gọi API tương ứng.
4. UI toast success/error.
5. Saved jobs page load paginated saved jobs.
6. Applicant click remove/withdraw thì gọi DELETE.

### AI làm gì

Không có AI trong save/apply. AI có thể dùng dữ liệu applied jobs cho privacy applicant count hoặc recruiter applicant list.

### Flow data

```text
Applicant clicks Apply
-> applyJob(applicantId, jobId)
-> ApplicantController.applyJob
-> ImplApplicantService.applyJob
-> ApplicantRepository.findById
-> JobRepository.findById
-> ApplicantJobRepository check duplicate
-> ApplicantJobRepository.save(actionType=APPLIED)
-> SavedJobResponse
-> Frontend toast/update UI
```

### Cách tiếp cận

Project dùng một bảng relation `applicant_jobs` với `actionType` để lưu cả saved và applied. Cách này đơn giản và tái sử dụng bảng. Nhược điểm là nếu nghiệp vụ application phức tạp hơn, ví dụ status review/interview/rejected, cover letter, answers, thì nên tách `saved_jobs` và `applications` hoặc mở rộng `ApplicantJob`.

Step-by-step:

1. Tạo join entity giữa applicant và job.
2. Thêm `actionType`.
3. Save/apply kiểm tra duplicate theo applicant + job + actionType.
4. List theo applicant + actionType.
5. Delete theo relation id + applicant id để tránh xóa của người khác.
6. Frontend gom API vào `jobsApi`.

## Feature 10: Nhà tuyển dụng đăng, sửa và quản lý tin tuyển dụng

### Business logic

Stakeholder cần:

- Recruiter đăng tin tuyển dụng với title, description, requirements, benefits, location, salary, job type, experience level, deadline.
- Recruiter xem danh sách job do mình đăng.
- Recruiter chỉnh sửa job do mình sở hữu.
- Recruiter không được sửa job của recruiter khác.

### Backend làm gì

Code liên quan:

- `RecruiterJobController`
- `ImplJobService`
- `RecruiterJobRequest`
- `JobMapper`
- `JobRepository`
- `RecruiterRepository`

Endpoints:

```text
GET /api/v1/recruiters/jobs/{recruiterId}
POST /api/v1/recruiters/jobs/{recruiterId}
PUT /api/v1/recruiters/jobs/{recruiterId}/{jobId}
```

Backend:

1. Create job:
   - Tìm recruiter.
   - Mapper request sang `Job`.
   - Gắn recruiter.
   - Save job.
2. Update job:
   - Tìm recruiter.
   - Tìm job.
   - Nếu job có recruiter khác, ném lỗi.
   - Mapper update fields.
   - Save job.
3. Get jobs:
   - Kiểm tra recruiter tồn tại.
   - Query job theo recruiter id.

### Frontend làm gì

Code liên quan:

- `RecruiterJobs.tsx`
- `PostEditJob.tsx`
- `jobsApi.fetchRecruiterJobs`
- `jobsApi.createRecruiterJob`
- `jobsApi.updateRecruiterJob`
- `toRecruiterJobPayload`

Frontend:

1. Recruiter vào `/recruiters/jobs`.
2. Gọi list jobs theo recruiter id.
3. Click New Job mở form.
4. Submit form gọi create.
5. Click Edit gọi update.
6. `toRecruiterJobPayload` normalize form fields trước khi gửi backend.

### AI làm gì

Không có AI khi đăng job. AI matching dùng JD này ở feature match.

### Flow data

```text
Recruiter job form
-> toRecruiterJobPayload
-> POST /api/v1/recruiters/jobs/{recruiterId}
-> RecruiterJobController
-> ImplJobService.createJob
-> RecruiterRepository.findById
-> JobMapper.toNewJob
-> JobRepository.save
-> JobResponse
-> Frontend redirect/list update
```

### Cách tiếp cận

Job thuộc recruiter theo quan hệ many-to-one. Đây là cách tự nhiên vì một recruiter có nhiều job, một job thuộc một recruiter.

Step-by-step:

1. Tạo `Job` entity chứa fields JD.
2. Tạo request DTO có validation, tối thiểu `jobTitle` required.
3. Mapper parse dates, requirements, benefits.
4. Tạo service create/update.
5. Kiểm tra ownership khi update.
6. Frontend form dùng cùng component cho create và edit.
7. Test recruiter không sửa được job của người khác.

## Feature 11: Nhà tuyển dụng xem ứng viên đã ứng tuyển

### Business logic

Stakeholder cần:

- Recruiter xem danh sách ứng viên đã apply vào job của mình.
- Recruiter chỉ được xem applicant của job do mình đăng.
- Thông tin applicant phải tôn trọng privacy visibility.

### Backend làm gì

Code liên quan:

- `RecruiterJobController.getAppliedApplicants`
- `BrowseJobController.getApplicants`
- `ImplJobService.getJobApplicants`
- `ApplicantMapper.toRecruiterVisibleApplicantResponse`

Endpoints:

```text
GET /api/v1/recruiters/jobs/{recruiterId}/{jobId}/applicants
GET /api/v1/browse-jobs/applicants/{jobId}/list
```

Backend:

1. Service tìm job.
2. Nếu có `recruiterId`, kiểm tra job thuộc recruiter đó.
3. Query `ApplicantJob` theo `jobId` và `actionType = APPLIED`.
4. Mỗi relation được map thành `JobApplicantResponse`.
5. Applicant trong response dùng recruiter-visible mapper, tức là field bị ẩn sẽ null.

### Frontend làm gì

Code liên quan:

- `JobApplicants.tsx`
- `jobsApi.fetchJobApplicants`

Frontend:

1. Recruiter mở `/jobs/:jobId/applicants`.
2. Gọi API với recruiter id.
3. Render danh sách applicant.
4. Nếu field bị privacy ẩn thì UI hiển thị trạng thái ẩn/thông báo.

### AI làm gì

Không bắt buộc trong list applied applicants. Nếu muốn recruiter xem ranking ứng viên phù hợp nhất, có thể gọi AI match cho từng applicant/job hoặc thiết kế batch matching.

### Flow data

```text
Recruiter opens applicants page
-> fetchJobApplicants(jobId, recruiterId)
-> RecruiterJobController.getAppliedApplicants
-> ImplJobService.getJobApplicants
-> JobRepository.findById + ownership check
-> ApplicantJobRepository.findByJob_IdAndActionType
-> ApplicantMapper.toRecruiterVisibleApplicantResponse
-> Frontend render privacy-safe applicant list
```

### Cách tiếp cận

Ownership check phải ở backend, không chỉ ở frontend. Frontend route guard chỉ giúp UX, không phải security boundary.

Step-by-step:

1. Relation application lưu applicant/job/action type.
2. Recruiter endpoint nhận recruiterId/jobId.
3. Service xác minh job thuộc recruiter.
4. Query applications.
5. Map applicant bằng privacy-filtered mapper.
6. Trả list.
7. Thêm test recruiter A không xem được applicants job của recruiter B.

## Feature 12: AI matching CV với Job Description

### Business logic

Stakeholder cần:

- Applicant muốn biết CV của mình phù hợp với job bao nhiêu phần trăm.
- Hệ thống phải giải thích vì sao match hoặc không match.
- Hệ thống nên chỉ tính dựa trên kỹ năng, kinh nghiệm, học vấn, nội dung nghề nghiệp, không dựa trên tên/email/phone.
- Nếu applicant thiếu CV, hệ thống báo cần upload CV trước.

### Backend làm gì

Code liên quan:

- `ApplicantController.matchJob`
- `ImplCvMatchService`
- `ImplCvAiService.matchCvToJob`
- `CvJobMatchRequest`
- `CvJobMatchResponse`

Endpoint:

```text
POST /api/v1/applicants/{applicantId}/match/{jobId}
```

Backend:

1. Controller kiểm tra applicant chính chủ bằng `verifyApplicantAccess`.
2. Service tìm applicant.
3. Nếu applicant chưa có CV, ném `Applicant has no CV to match`.
4. Service tìm job.
5. Build canonical CV từ dữ liệu CV đã lưu:
   - `SKILL`
   - `CERTIFICATION`
   - `EDUCATION`
   - `SUMMARY`
   - `CANDIDATE_LOCATION`
   - `JOB_TITLE`
   - `COMPANY`
   - `DATE`
   - `EXPERIENCE`
6. Build JD object từ job:
   - jobTitle
   - aboutCompany
   - jobDescription
   - requirements
   - benefits
   - location
   - salaryRange
   - jobType
   - experienceLevel
   - industry
7. Gọi AI service `/match` bằng JSON.
8. Nhận match score, per-field scores, hard filter, reason, suggestions.
9. Hiện tại backend thêm Laplace noise vào score bằng `addLaplaceNoise`.
10. Trả `CvJobMatchResponse`.

### Frontend làm gì

Code liên quan:

- `JobDetail.tsx`
- `Jobs.tsx`
- `jobsApi.matchCvToJob`
- `CvJobMatch`

Frontend:

1. Applicant click AI match/AI suggestion.
2. Gọi `matchCvToJob(applicantId, jobId, options)`.
3. Options hiện có `llm` và `method`.
4. Render:
   - `matchPercent`
   - `passedFilter`
   - `reason`
   - `suggestions`
   - `perFieldScores`
   - hard filter reasons nếu fail

### AI làm gì

Code liên quan:

- `ai/app/main.py` endpoint `/match`
- `recommend/pipeline.py`
- `recommend/masking.py`
- `recommend/hard_filter.py`
- `recommend/vector_space.py`
- `recommend/semantic.py`
- `recommend/decision.py`
- `recommend/llm_suggest.py`

AI flow 5 nhóm:

1. **Masking PII**
   - `mask_entities` bỏ các label như `NAME`, `EMAIL`, `PHONE`, `LINK`.
   - `scrub_text` xóa email/phone/link còn sót trong long text.
2. **Hard filter**
   - Kiểm tra location.
   - Tính years of experience.
   - Kiểm tra GPA nếu JD yêu cầu.
   - Nếu gap quá lớn, reject sớm.
3. **Vector field matching**
   - Score các field ngắn/keyword: skill, title, education, certification...
   - Dùng TF-IDF, Word2Vec hoặc embedding.
4. **Semantic field matching**
   - Score các field dài: summary, experience, project.
   - Dùng TF-IDF hoặc sentence-transformer embedding.
5. **Decision model**
   - Nếu có SVM model, dùng SVM để aggregate field scores.
   - Nếu không có, dùng weighted heuristic.
   - Sinh reason dựa trên field đóng góp nhiều.
   - Nếu bật LLM và Ollama có sẵn, sinh suggestion tự nhiên hơn.

### Flow data

```text
Applicant clicks Match
-> matchCvToJob(applicantId, jobId)
-> ApplicantController.matchJob
-> verifyApplicantAccess
-> ImplCvMatchService.matchApplicantToJob
-> ApplicantRepository.findById
-> JobRepository.findById
-> buildCanonical(Cv)
-> buildJd(Job)
-> ImplCvAiService.matchCvToJob
-> POST AI /match
-> run_match
-> mask_entities
-> run_hard_filter
-> score_vector_fields + score_semantic_fields
-> decide
-> suggest
-> MatchResult
-> Backend CvJobMatchResponse
-> Frontend render score/reason/suggestions
```

### Cách tiếp cận và lý do

Không nên đưa toàn bộ CV raw text vào một cosine similarity duy nhất vì:

- Skill match quan trọng hơn vài đoạn văn mô tả chung.
- Education/company/title có ý nghĩa riêng.
- Cần explainable result.
- PII có thể lẫn vào text.

Project dùng field-to-field matching: CV field so với JD field tương ứng. Đây là hướng tốt cho explainability.

Step-by-step:

1. Chuẩn hóa CV thành canonical schema.
2. Chuẩn hóa JD thành schema cố định.
3. Mask PII trước khi scoring.
4. Chạy hard filter để loại case rõ ràng không phù hợp.
5. Tính similarity từng field.
6. Dùng model/weighted average tổng hợp thành score.
7. Sinh reason từ field mạnh/yếu.
8. Frontend hiển thị score và suggestion.
9. Nếu cần ranking toàn bộ jobs, chạy matching cho nhiều job và sort descending.

Ghi chú về Differential Privacy trên match score:

- Code hiện có `differentialPrivacyApplied=true`.
- Tuy nhiên với matching/ranking, thêm nhiễu có thể làm sai thứ tự.
- Nếu báo cáo nhấn mạnh recommendation quality, nên nói rằng PII masking là privacy chính trong AI matching, còn DP phù hợp hơn với aggregate count.
- Nếu vẫn giữ DP score, cần giải thích đây là trade-off privacy-utility và nên dùng epsilon đủ lớn để nhiễu nhỏ.

## Feature 13: PII masking trong AI matching

### Business logic

Stakeholder cần:

- Điểm matching không bị ảnh hưởng bởi tên, email, phone, link cá nhân.
- Hệ thống giảm thiên vị dựa trên danh tính.
- Dữ liệu đưa vào AI scoring chỉ nên là thông tin nghề nghiệp.

### Backend làm gì

Backend build canonical CV từ DB và gửi cho AI. Backend hiện chưa tự mask trong Java; masking được thực hiện ở AI pipeline.

### Frontend làm gì

Không xử lý masking. Frontend chỉ hiển thị kết quả.

### AI làm gì

Code liên quan:

- `recommend/masking.py`
- `recommend/config.py`

AI:

1. Nhận `entitiesByLabel`.
2. Bỏ toàn bộ label PII như `NAME`, `EMAIL`, `PHONE`, `LINK`.
3. Với long text như summary/experience/project, regex xóa email/phone/link inline.
4. Trả masked dict cho các bước vector/semantic.

### Flow data

```text
Backend sends canonical CV
-> AI /match
-> run_match
-> mask_entities
-> masked entities
-> hard filter/vector/semantic/decision
```

### Cách tiếp cận

Có 2 thời điểm mask:

- Mask trước khi lưu DB.
- Mask chỉ trước khi đưa vào AI.

Project dùng mask trước AI. Cách này giữ được hồ sơ đầy đủ cho owner nhưng không cho model dùng PII. Nếu yêu cầu privacy cao hơn, có thể kết hợp cả hai: lưu PII tách riêng, encrypt, và luôn mask trước mọi AI/logging.

Step-by-step:

1. Xác định labels PII.
2. Bỏ label PII khỏi scoring input.
3. Scrub PII trong text tự do.
4. Không log raw CV/canonical có PII.
5. Test masking bằng text có email/phone/link.

## Feature 14: Differential Privacy cho applicant count

### Business logic

Stakeholder cần:

- Applicant muốn biết job có nhiều người ứng tuyển không.
- Hệ thống không nên công bố raw count chính xác cho applicant khác vì có thể suy luận ai vừa apply.
- Ví dụ count tăng từ 10 lên 11 ngay sau khi biết một người apply, người quan sát có thể đoán hành vi cá nhân.

### Backend làm gì

Code liên quan:

- `JobPrivacyController.getApplicantCount`
- `ImplApplicantPrivacyService.getDifferentiallyPrivateApplicantCount`
- `PrivacyRelease`
- `PrivacyReleaseRepository`
- `PrivacyProperties`

Endpoint:

```text
GET /api/v1/jobs/{jobId}/applicant-count
```

Backend:

1. Chỉ applicant đã authenticated được gọi endpoint này.
2. Kiểm tra job tồn tại.
3. Đọc config:
   - epsilon
   - release window
   - release secret
4. Tạo release key theo job + audience + window.
5. Nếu window hiện tại đã có release trong DB, reuse released value.
6. Nếu chưa có:
   - Count raw distinct applicants với `APPLIED`.
   - Sinh noise discrete Laplace bằng HMAC secret + release key.
   - `releasedCount = max(0, rawCount + noise)`.
   - Lưu vào `privacy_releases`.
7. Trả approximate count và display text.

Tại sao reuse cùng release trong window?

- Nếu mỗi lần refresh sinh noise mới, attacker có thể gọi nhiều lần rồi lấy trung bình để gần raw count.
- Reuse release trong cùng window giúp count ổn định và khó bị averaging attack.

### Frontend làm gì

Code liên quan:

- `JobDetail.tsx`
- `jobsApi.fetchApplicantActivityCount`

Frontend:

1. Applicant mở job detail.
2. Gọi `/api/v1/jobs/{jobId}/applicant-count`.
3. Hiển thị text như "Approximately 12 candidates have applied".
4. Không hiển thị raw count nếu đang dùng privacy endpoint.

### AI làm gì

Không có AI. Đây là privacy/statistics feature ở backend.

### Flow data

```text
Applicant opens job detail
-> fetchApplicantActivityCount(jobId)
-> JobPrivacyController
-> requireApplicant(authentication)
-> ImplApplicantPrivacyService
-> JobRepository.existsById
-> PrivacyReleaseRepository.findByReleaseKey
-> if missing: ApplicantJobRepository.countDistinctApplicantsByJobAndActionType
-> sampleDiscreteLaplace
-> PrivacyReleaseRepository.save
-> ApplicantActivityCountResponse
-> Frontend render approximate count
```

### Cách tiếp cận

Applicant count là aggregate query có sensitivity = 1: thêm hoặc bỏ một applicant chỉ làm count thay đổi tối đa 1. Vì vậy phù hợp với Differential Privacy.

Step-by-step:

1. Xác định query cần bảo vệ: count applicants per job.
2. Xác định audience: applicant.
3. Chọn epsilon.
4. Chọn release window, ví dụ 7 ngày.
5. Dùng deterministic seed từ HMAC để tạo noise ổn định trong window.
6. Lưu released value.
7. Không log raw count/noise/secret.
8. Frontend hiển thị "approximately".

## Feature 15: Anonymous candidate previews

### Business logic

Stakeholder cần:

- Applicant đã apply một job có thể xem vài profile ẩn danh của những candidate khác để hiểu mức cạnh tranh.
- Không được lộ danh tính candidate khác.
- Chỉ hiển thị khi có đủ số lượng candidate để giảm rủi ro nhận diện.
- Cần rate limit để tránh scraping.

### Backend làm gì

Code liên quan:

- `JobPrivacyController.getAnonymousCandidatePreviews`
- `ImplApplicantPrivacyService.getAnonymousCandidatePreviews`
- `AnonymousCandidatePreviewsResponse`
- `AnonymousCandidatePreviewProfileResponse`

Endpoint:

```text
GET /api/v1/jobs/{jobId}/anonymous-candidate-previews
```

Backend:

1. Kiểm tra requester là applicant.
2. Kiểm tra job tồn tại.
3. Kiểm tra applicant đã apply job này.
4. Đọc config:
   - enabled
   - minimum eligible candidates
   - maximum previews
   - rotation window
   - rate limit per window
5. Enforce rate limit theo applicant + job + window.
6. Query eligible candidate applications, loại chính viewer.
7. Nếu số eligible < minimum, trả unavailable.
8. Sort candidates bằng HMAC để sample deterministic trong window.
9. Trả tối đa `maximumPreviews`.
10. Mỗi preview chỉ gồm:
    - anonymousProfileId
    - experience bucket
    - skill categories
    - education level
    - general region
    - current role category

### Frontend làm gì

Code liên quan:

- `JobDetail.tsx`
- `jobsApi.fetchAnonymousCandidatePreviews`

Frontend:

1. Applicant xem job đã apply.
2. Gọi preview endpoint.
3. Nếu `available=false`, hiển thị message.
4. Nếu available, render anonymous profiles.
5. Không render tên/email/phone/CV link vì backend không trả.

### AI làm gì

Không có model AI. Backend dùng rule-based bucketing và categorization từ CV fields.

### Flow data

```text
Applicant requests anonymous previews
-> JobPrivacyController
-> requireApplicant
-> ImplApplicantPrivacyService
-> requireExistingJob
-> requireAppliedViewer
-> enforceRateLimit
-> findEligibleAnonymousPreviewApplications
-> HMAC deterministic sampling
-> toAnonymousProfile
-> AnonymousCandidatePreviewsResponse
-> Frontend render limited profiles
```

### Cách tiếp cận

Không nên hiển thị "top candidate" thật hoặc raw CV vì dễ nhận diện. Dùng buckets làm mất chi tiết định danh:

- "4+ years" thay vì timeline cụ thể.
- "Backend" thay vì full skills list quá độc đáo.
- "Southern Vietnam" thay vì địa chỉ.

Step-by-step:

1. Chỉ cho applicant đã apply xem.
2. Đặt minimum group size.
3. Chỉ trả fields tổng quát.
4. Dùng HMAC token cho anonymous id.
5. Rotate theo window.
6. Rate limit request.
7. Test unavailable khi candidate quá ít.

## Feature 16: Quản lý hồ sơ nhà tuyển dụng

### Business logic

Stakeholder cần:

- Recruiter xem/cập nhật thông tin công ty.
- Applicant/admin có thể xem thông tin recruiter/company.
- Admin xem danh sách recruiter.

### Backend làm gì

Code liên quan:

- `RecruiterController`
- `ImplRecruiterService`
- `RecruiterMapper`

Endpoints:

```text
GET /api/v1/recruiters
GET /api/v1/recruiters/{recruiterId}
PUT /api/v1/recruiters/{recruiterId}
```

Backend:

1. List recruiters từ repository.
2. Get recruiter by id.
3. Update recruiter bằng mapper.
4. Trả DTO, không trả password.

### Frontend làm gì

Code liên quan:

- `Recruiters.tsx`
- `RecruiterDetail.tsx`
- `RecruiterJobs.tsx`
- `jobsApi.fetchRecruiters`
- `jobsApi.fetchRecruiter`
- `jobsApi.updateRecruiter`

Frontend:

1. Admin xem danh sách recruiter.
2. Applicant/recruiter/admin xem detail company.
3. Recruiter update profile công ty.

### AI làm gì

Không có AI.

### Flow data

```text
Recruiter profile page
-> fetchRecruiter/updateRecruiter
-> RecruiterController
-> ImplRecruiterService
-> RecruiterRepository
-> RecruiterMapper
-> ApiResponse
-> Frontend render
```

### Cách tiếp cận

Recruiter profile nên tách khỏi job vì cùng một công ty có nhiều job. Khi job cần company info, có thể lấy từ recruiter hoặc copy snapshot tùy yêu cầu. Project đang gắn `Job.recruiter`.

Step-by-step:

1. Tạo recruiter entity.
2. Tạo mapper response.
3. Tạo list/detail/update endpoints.
4. Frontend route guard theo role.
5. Test không trả password.

## Feature 17: Admin quản lý applicant và recruiter

### Business logic

Stakeholder cần:

- Admin xem danh sách applicant.
- Admin xem danh sách recruiter.
- Admin xem detail user để hỗ trợ vận hành.

### Backend làm gì

Code liên quan:

- `ApplicantController.getAllApplicants`
- `RecruiterController.getAllRecruiters`
- `ApplicantMapper.toApplicantResponse(fullAccess)`
- `RecruiterMapper`

Backend:

1. Applicant list đọc `Authentication`.
2. Nếu admin, `fullAccess=true`.
3. Nếu không admin, trả privacy-filtered applicants.
4. Recruiter list hiện trả toàn bộ recruiter response.

### Frontend làm gì

Code liên quan:

- `Applicants.tsx`
- `ApplicantDetail.tsx`
- `Recruiters.tsx`
- `RecruiterDetail.tsx`
- `RouteGuard`

Frontend:

1. Admin routes:
   - `/admin/applicants`
   - `/admin/recruiters`
2. `RouteGuard roles={["ADMIN"]}` chặn user không phải admin.
3. Gọi API và render table/detail.

### AI làm gì

Không có AI.

### Flow data

```text
Admin opens /admin/applicants
-> RouteGuard checks role ADMIN
-> fetchApplicants
-> ApplicantController.getAllApplicants
-> isAdmin(authentication)
-> ImplApplicantService.getAllApplicants(fullAccess)
-> ApplicantMapper
-> Frontend render table
```

### Cách tiếp cận

Frontend route guard giúp UX, backend authorization mới là security boundary. Project hiện cần siết thêm backend security cho admin endpoints nếu production.

Step-by-step:

1. Tạo admin-only frontend routes.
2. Backend kiểm tra role admin.
3. Trả full data cho admin.
4. Trả filtered hoặc forbidden cho non-admin tùy yêu cầu.
5. Test applicant/recruiter không gọi được admin endpoints.

## Feature 18: API envelope, validation và exception handling

### Business logic

Stakeholder cần:

- Frontend nhận response nhất quán.
- Lỗi validation, not found, forbidden, conflict, AI unavailable phải dễ hiển thị.
- Technical team debug dễ hơn.

### Backend làm gì

Code liên quan:

- `ApiResponse`
- `GlobalException`
- Custom exceptions:
  - `AlreadyExistException`
  - `ResourcesNotFoundException`
  - `ForbiddenException`
  - `AiServiceUnavailableException`

Backend:

1. Controller trả `ApiResponse.success`.
2. Exception được bắt ở `GlobalException`.
3. Lỗi được bọc vào `ApiResponse.failure`.
4. Validation errors đưa vào `errors`.
5. HTTP status đúng nghĩa:
   - 400 validation/illegal argument
   - 403 forbidden
   - 404 not found
   - 409 conflict
   - 503 AI unavailable

### Frontend làm gì

Code liên quan:

- `api.ts`
- `ApiError`

Frontend:

1. `apiRequest` parse response.
2. Nếu `res.ok=false`, ném `ApiError`.
3. `ApiError` giữ `status`, `errors`, `payload`.
4. UI có thể toast message hoặc hiển thị field errors.
5. Nếu `401`, clear token và dispatch `auth:expired`.

### AI làm gì

AI service tự trả HTTP status. Backend map AI errors sang API envelope chung.

### Flow data

```text
Invalid request
-> Controller validation fails
-> GlobalException.handleMethodArgumentNotValidException
-> ApiResponse.failure(errors)
-> apiRequest throws ApiError
-> UI toast/form error
```

### Cách tiếp cận

Envelope giúp frontend không phải xử lý mỗi endpoint một kiểu. Nhược điểm là cần thống nhất nghiêm: mọi endpoint phải theo cùng format.

Step-by-step:

1. Tạo `ApiResponse`.
2. Controller luôn dùng success/failure.
3. Tạo global exception handler.
4. Frontend tạo API client tập trung.
5. Không gọi `fetch` trực tiếp từ page.
6. Test response shape.

## Feature 19: Swagger/OpenAPI documentation

### Business logic

Stakeholder cần:

- Developer/tester xem endpoint và thử API dễ hơn.
- Báo cáo đồ án có thể chụp Swagger làm minh chứng.

### Backend làm gì

Code liên quan:

- `OpenApiConfig`
- `@Tag`
- `@Operation`
- Swagger endpoints trong `SecurityConfig` permit:
  - `/swagger-ui/**`
  - `/v3/api-docs/**`
  - `/swagger-ui.html`

Backend:

1. Mỗi controller có `@Tag`.
2. Mỗi endpoint có `@Operation`.
3. Swagger UI tự render docs.

### Frontend làm gì

Không có.

### AI làm gì

FastAPI cũng có docs mặc định cho AI service, ví dụ `/docs`, nếu được expose.

### Flow data

```text
Developer opens Swagger UI
-> Springdoc scans controllers
-> OpenAPI JSON
-> Swagger UI render endpoints
```

### Cách tiếp cận

Swagger giúp API contract rõ. Với project nhiều endpoint, đây là feature hỗ trợ maintain rất đáng giá.

Step-by-step:

1. Thêm springdoc dependency.
2. Tạo `OpenApiConfig`.
3. Annotate controller.
4. Permit swagger endpoints.
5. Cập nhật docs khi thêm API.

## Feature 20: Frontend routing, role guard và lazy loading

### Business logic

Stakeholder cần:

- User chưa đăng nhập không vào được trang private.
- Applicant/recruiter/admin chỉ thấy đúng chức năng.
- App tải nhanh, không load toàn bộ pages ngay lần đầu.

### Frontend làm gì

Code liên quan:

- `App.tsx`
- `RouteGuard.tsx`
- `AuthContext.tsx`

Frontend:

1. `BrowserRouter` định nghĩa routes.
2. Public routes: home, jobs, job detail, auth, registration.
3. Authenticated routes: profile, notifications.
4. Applicant-only: saved jobs.
5. Recruiter-only: recruiter jobs, create/edit job.
6. Admin-only: applicants, recruiters.
7. Pages được `lazy()` để code splitting.
8. `Suspense` hiển thị loading.

### Backend làm gì

Backend vẫn phải enforce security. Frontend guard không đủ an toàn vì user có thể gọi API trực tiếp.

### AI làm gì

Không có.

### Flow data

```text
User opens route
-> React Router
-> RouteGuard reads AuthContext
-> if no token: navigate /auth
-> if wrong role: navigate /forbidden
-> if allowed: render lazy page
```

### Cách tiếp cận

SPA cần route guard để UX tốt. Lazy loading giúp performance. Nhưng phải nhớ route guard là client-side convenience, không thay thế backend authorization.

Step-by-step:

1. Tạo `AuthProvider`.
2. Decode token lấy role.
3. Tạo `RouteGuard`.
4. Bọc route theo role.
5. Backend bảo vệ API tương ứng.
6. Test refresh vẫn giữ login nếu token chưa hết hạn.

## Feature 21: AI service health và deployment configuration

### Business logic

Stakeholder cần:

- Biết AI service có chạy không.
- Biết model LayoutLMv3 có được mount không.
- Khi không có model, hệ thống vẫn fallback.

### Backend/AI làm gì

AI endpoint:

```text
GET /health
```

Trả:

- `status`
- `modelLoaded`
- `fallbackAvailable`
- `imageOcrAvailable`
- `recommenderModelLoaded`
- `word2vecLoaded`
- `ollamaModel`

Backend config:

```yaml
app:
  ai:
    enabled: ${AI_CV_ENABLED:true}
    base-url: ${AI_CV_BASE_URL:http://localhost:8001}
```

### Frontend làm gì

Hiện frontend không nhất thiết gọi health. Có thể thêm admin/dev status page nếu cần.

### Flow data

```text
Developer/health check
-> GET AI /health
-> parser/model availability checks
-> JSON readiness info
```

### Cách tiếp cận

Health endpoint giúp Docker/Kubernetes/dev biết service có sẵn. Với AI, cần phân biệt service sống và model loaded. Service sống nhưng model chưa loaded vẫn có fallback.

Step-by-step:

1. Tạo `/health`.
2. Check model file tồn tại.
3. Check OCR binary.
4. Check recommender model.
5. Docker compose expose service.
6. Backend dùng base-url từ env.

## Feature 22: Recruiter/applicant public detail và company/job relationship

### Business logic

Stakeholder cần:

- Applicant xem thông tin công ty trước khi apply.
- Recruiter profile liên kết với job.
- Job detail có company name hoặc recruiter info.

### Backend làm gì

Backend dùng relationship:

```text
Recruiter 1 -> many Jobs
Job many -> one Recruiter
```

`JobMapper` đưa thông tin job/recruiter cần thiết vào response.

### Frontend làm gì

Frontend:

1. Job detail render company name/location/type/salary.
2. Recruiter detail render profile công ty.
3. Recruiter jobs page render jobs thuộc company.

### AI làm gì

AI matching có thể dùng `aboutCompany`, `industry`, `jobDescription`, `requirements` từ job.

### Flow data

```text
Job detail
-> fetchJob(jobId)
-> JobRepository.findById
-> JobMapper includes recruiter-related fields
-> Frontend render company context
```

### Cách tiếp cận

Giữ recruiter là source of truth cho company profile, job giữ JD-specific fields. Điều này tránh copy quá nhiều company data vào từng job.

## Feature 23: Search/filter/ranking jobs by match score

### Business logic

Stakeholder cần:

- Applicant muốn tìm job phù hợp nhanh hơn.
- Applicant muốn xem job được sắp theo điểm match giảm dần.

### Hiện trạng

README đang ghi đây là nhu cầu cần fix/improve. Project đã có matching một applicant với một job. Để có ranking toàn bộ jobs, cần mở rộng từ single match sang batch/list match.

### Backend cần làm gì

Hướng triển khai:

1. Tạo endpoint mới:

```text
GET /api/v1/applicants/{applicantId}/recommended-jobs
```

2. Verify applicant access.
3. Lấy CV của applicant.
4. Lấy page jobs hoặc candidate jobs sau filter.
5. Với mỗi job, build JD.
6. Gọi AI match:
   - Cách đơn giản: loop từng job gọi `/match`.
   - Cách tốt hơn: tạo AI endpoint batch `/match-batch`.
7. Sort by `matchScore desc`.
8. Trả page response gồm job + match summary.

### Frontend cần làm gì

1. Thêm filter/search UI.
2. Gọi recommended jobs endpoint.
3. Hiển thị score trên từng card.
4. Cho sort `match desc`.
5. Fallback về browse jobs nếu applicant chưa có CV.

### AI cần làm gì

Nếu batch:

1. Nhận một CV canonical và list JD.
2. Mask CV một lần.
3. Chạy hard filter/matching từng JD.
4. Trả list result.

### Flow data đề xuất

```text
Applicant opens recommended jobs
-> GET /api/v1/applicants/{id}/recommended-jobs
-> Backend loads CV + jobs
-> Backend calls AI /match-batch
-> AI scores each JD
-> Backend sorts descending
-> Frontend render ranked list
```

### Cách tiếp cận

Không nên gọi 100 job match từ frontend vì:

- Lộ logic.
- Nhiều request.
- Khó cache.
- Khó phân quyền.

Nên để backend orchestrate và AI batch process.

Step-by-step:

1. Implement single-job matching ổn định trước.
2. Tạo DTO `RecommendedJobResponse`.
3. Tạo endpoint backend.
4. Thêm AI batch endpoint.
5. Cache score nếu cần.
6. Frontend thêm tab "Best matches".
7. Test ranking.

## Bảng tóm tắt feature

| Mã | Feature | Backend | Frontend | AI |
|---|---|---|---|---|
| F-01 | Applicant/Recruiter registration | Có | Có | Không |
| F-02 | Login/token/authorization | Có | Có | Không |
| F-03 | Home summary | Có | Có | Không |
| F-04 | Browse job/detail | Có | Có | Không |
| F-05 | Applicant profile | Có | Có | Không trực tiếp |
| F-06 | Consent visibility | Có | Có | Không |
| F-07 | Upload CV persist | Có | Có | Không bắt buộc |
| F-08 | AI CV analysis/autofill | Có | Có | Có |
| F-09 | Save/apply/withdraw jobs | Có | Có | Không |
| F-10 | Recruiter job management | Có | Có | Không |
| F-11 | Recruiter sees applicants | Có | Có | Không trực tiếp |
| F-12 | AI CV-JD matching | Có | Có | Có |
| F-13 | PII masking for matching | Backend gọi AI | Không | Có |
| F-14 | Differential private applicant count | Có | Có | Không |
| F-15 | Anonymous candidate previews | Có | Có | Không |
| F-16 | Recruiter profile | Có | Có | Không |
| F-17 | Admin management | Có | Có | Không |
| F-18 | API envelope/errors | Có | Có | Không |
| F-19 | Swagger/OpenAPI | Có | Không | Không |
| F-20 | Frontend route guard/lazy loading | Không trực tiếp | Có | Không |
| F-21 | AI health/config | Backend config | Không trực tiếp | Có |
| F-22 | Company/job relationship | Có | Có | Có thể dùng trong matching |
| F-23 | Recommended jobs ranking | Cần mở rộng | Cần mở rộng | Cần mở rộng |

## Checklist nâng cấp quan trọng

1. Chuẩn hóa token thành JWT 3 phần hoặc đổi cách gọi trong báo cáo thành custom HMAC token.
2. Siết `SecurityConfig.anyRequest().permitAll()` thành authenticated/role-based rules.
3. Chuyển authorization ownership checks từ controller rải rác sang method security hoặc service guard nhất quán.
4. Cân nhắc bỏ noise trên match score nếu cần ranking chính xác.
5. Giữ Differential Privacy cho applicant count vì đây là aggregate query phù hợp.
6. Thêm batch matching endpoint để support ranked jobs/recommended candidates.
7. Viết integration tests cho auth, upload CV, privacy visibility, DP count, matching.
8. Không log raw CV, raw PII, DP raw count/noise/secret.

