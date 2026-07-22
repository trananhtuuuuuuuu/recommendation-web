# Project Features Deep Dive

Tài liệu này mô tả các feature chính của project recommendation website theo góc nhìn business, backend, frontend, AI, data flow và cách triển khai. Mục tiêu không chỉ là biết "feature làm được gì", mà còn hiểu tại sao thiết kế như vậy, ưu/nhược điểm là gì, và nếu cần maintain hoặc nâng cấp thì nên đi từ đâu.

> Lưu ý quan trọng về hiện trạng code:
>
> - Project hiện gọi cơ chế đăng nhập là JWT, nhưng `JwtService` đang tạo token HMAC tự xây dựng dạng `base64url(payload).signature`, không phải JWT chuẩn RFC 7519 dạng `header.payload.signature`. Frontend đã hỗ trợ decode biến thể này.
> - `SecurityConfig` hiện để `anyRequest().permitAll()`. Vì vậy filter vẫn đọc token và đưa thông tin vào `SecurityContext`, nhưng Spring Security chưa chặn mặc định toàn bộ protected endpoint. Một số endpoint tự kiểm tra quyền trong controller/service. Khi đưa lên production nên siết lại bằng `authenticated()` và rule theo role.
> - `ImplCvMatchService` trả score gốc đã clamp trong khoảng `[0, 1]`, không còn thêm Laplace noise. PII masking là lớp privacy của matching; Differential Privacy chỉ tiếp tục dùng cho applicant count tổng hợp.

## Tổng quan kiến trúc





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
POST /api/v1/recruiters/jobs/{recruiterId}/{jobId}/ai-match
```

Backend:

1. Service tìm job.
2. Nếu có `recruiterId`, kiểm tra job thuộc recruiter đó.
3. Query `ApplicantJob` theo `jobId`, `actionType = APPLIED` và `id ASC` để có thứ tự nộp ổn định.
4. Mỗi relation được map thành `JobApplicantResponse`, có `applicationOrder`, cover letter, portfolio và application answers thật.
5. Applicant trong response dùng recruiter-visible mapper, tức là field bị ẩn sẽ null.
6. Endpoint `ai-match` xác minh JWT đúng recruiter sở hữu JD, gọi CV-JD matcher cho từng application, rồi sort `matchPercent DESC` và dùng `applicationOrder ASC` để tie-break.
7. Candidate chưa upload CV nhận score `0%` với lý do rõ ràng, không làm hỏng toàn bộ batch.

### Frontend làm gì

Code liên quan:

- `JobApplicants.tsx`
- `jobsApi.fetchJobApplicants`

Frontend:

1. Recruiter mở `/jobs/:jobId/applicants`.
2. Gọi API với recruiter id.
3. Trước khi chạy AI, render theo thứ tự nộp: `Candidate 1st`, `Candidate 2nd`, `Candidate 3rd` thay vì lộ database ID.
4. Click `AI Match` để gọi batch endpoint; kết quả được render lại theo score giảm dần, có rank, final percentage, reason, per-field score và suggestions.
5. Nếu field bị privacy ẩn thì UI hiển thị trạng thái ẩn/thông báo.

### AI làm gì

AI dùng cùng canonical CV, JD builder, PII masking, hard filter và scoring pipeline của feature CV-JD matching. Frontend không còn sinh score demo/hardcode. Batch orchestration đặt ở backend để đảm bảo ownership, cùng một scoring rule và thứ tự ranking ổn định.

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

Recruiter clicks AI Match
-> POST /api/v1/recruiters/jobs/{recruiterId}/{jobId}/ai-match
-> verifyRecruiterAccess(authentication)
-> ImplJobService.matchJobApplicants
-> ImplCvMatchService.matchApplicantToJob for each submitted application
-> sort matchPercent DESC, applicationOrder ASC
-> Frontend render ranked candidate cards
```

### Cách tiếp cận

Ownership check phải ở backend, không chỉ ở frontend. Frontend route guard chỉ giúp UX, không phải security boundary.

Step-by-step:

1. Relation application lưu applicant/job/action type.
2. Recruiter endpoint nhận recruiterId/jobId.
3. Service xác minh job thuộc recruiter.
4. Query applications.
5. Map applicant bằng privacy-filtered mapper.
6. Trả list kèm thứ tự application, không dùng applicant id làm nhãn hiển thị.
7. Với AI Match, score toàn bộ candidate và sort ở backend.
8. Test recruiter A không chạy AI ranking cho job của recruiter B.

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
9. Clamp score gốc vào `[0, 1]` để chống dữ liệu ngoài biên nhưng không cộng noise.
10. Trả `CvJobMatchResponse` với `differentialPrivacyApplied=false` và các metadata epsilon/sensitivity/mechanism bằng `null`.

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

- Code hiện trả `differentialPrivacyApplied=false`.
- Không thêm noise vì matching/ranking cần score chính xác và thứ tự ổn định.
- PII masking là privacy chính trong AI matching; Differential Privacy vẫn phù hợp với aggregate applicant count ở Feature 14.

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


## Feature 24: Hiển thị đồng thời nhiều AI Suggestion trên danh sách JD

### Business logic

Stakeholder cần:

- Applicant có thể mở AI Suggestion của nhiều JD cùng lúc để so sánh.
- Mở hoặc đóng một card không được làm thay đổi trạng thái của card khác.
- Kết quả đã tải không cần gọi AI lại chỉ để mở lại panel.

### Backend làm gì

Không cần endpoint mới. Mỗi JD vẫn gọi endpoint single CV-JD match hiện có. Backend trả score gốc không noise nên các card có thể so sánh trực tiếp.

### Frontend làm gì

Code liên quan:

- `Jobs.tsx`
- `jobsApi.matchCvToJob`

Frontend thay state scalar `expandedSuggestion: string | null` bằng `expandedSuggestions: Set<string>`. Kết quả vẫn cache theo `singleResults[jobId]`; thao tác toggle chỉ thêm/xóa đúng `jobId` trong Set.

### AI làm gì

AI xử lý độc lập từng JD. Khi result đã có trong state, mở lại panel không gửi request mới.

### Flow data

```text
Click AI Suggestion on Job A
-> matchCvToJob(A)
-> singleResults[A] = result
-> expandedSuggestions.add(A)

Click AI Suggestion on Job B
-> matchCvToJob(B)
-> singleResults[B] = result
-> expandedSuggestions.add(B)
-> A and B remain visible
```

### Cách tiếp cận

Panel visibility là state theo identity của JD, vì vậy dùng `Set<jobId>` phù hợp hơn một id dùng chung. Functional state update tạo Set mới để React nhận biết thay đổi và tránh đóng panel không liên quan.

Step-by-step:

1. Cache result theo job id.
2. Cache trạng thái expanded theo một Set job id.
3. Toggle đúng phần tử được click.
4. `Clear AI` xóa cả result cache và expanded Set.
5. Test mở Job A rồi Job B và xác nhận cả hai reason vẫn tồn tại.

## Feature 25: Recruiter profile có published content, logo, cover và completeness chính xác

### Business logic

Stakeholder cần:

- Tab `Posts` và `Jobs` hiển thị các JD recruiter đã publish, không hardcode empty state.
- Company logo và cover image là hai ảnh độc lập.
- Cover chiếm toàn bộ banner; logo nằm chồng lên mép banner và dùng `object-contain` để không crop logo.
- Profile completeness cập nhật theo dữ liệu đã lưu và giải thích rõ field còn thiếu.

### Backend làm gì

Code liên quan:

- `Recruiter`
- `RecruiterMapper`
- `ImplRecruiterService`
- `schema-postgres.sql`

Backend lưu riêng `logoUrl`, `coverImageUrl`, `website`, `contactEmail`, `contactPhone`, `taxCode`, `businessLicense`, `companyType`. Trước đây nhiều field chỉ có ở request/response nhưng không có cột entity nên save xong bị mất; logo và cover còn bị map chung từ `avatarUrl`.

Endpoint dùng lại:

```text
GET /api/v1/recruiters/{recruiterId}
PUT /api/v1/recruiters/{recruiterId}
GET /api/v1/recruiters/jobs/{recruiterId}
```

### Frontend làm gì

`Profile.tsx` tải recruiter profile và published jobs song song bằng `Promise.all`. Tab `Posts` dùng các JD làm company job announcements; tab `Jobs` dùng cùng source of truth nhưng trình bày metadata công việc. `RecruiterDetail.tsx` và `ProfileOverview.tsx` cũng render cover + logo riêng.

Completeness recruiter dựa trên 13 mục đã persist:

```text
company name, account email, company description, company location,
company size, industry, website, hiring email, hiring phone,
logo, cover image, tax code, established date
```

UI hiển thị cả `%`, số mục hoàn thành/tổng số và tối đa ba mục còn thiếu. Khi rời trang profile, overview được mount lại và refetch data mới nên percentage không dùng response cũ.

### AI làm gì

Không có AI trong profile completeness hoặc render ảnh. Published JD sau đó có thể được dùng làm input cho AI candidate ranking.

### Flow data

```text
Recruiter opens Profile
-> Promise.all(fetchRecruiter, fetchRecruiterJobs)
-> RecruiterView renders cover + logo
-> Posts/Jobs tabs map published jobs
-> profileCompletion checks persisted criteria
-> percent + missing fields rendered
```

### Cách tiếp cận

Database phải là source of truth cho logo, cover và business fields. Local browser avatar chỉ là override tạm thời, không được dùng thay cho hai trường company image. Completeness không tính fallback label như một field thật và kiểm tra nội dung bên trong array/object thay vì chỉ kiểm tra object có tồn tại.

## Feature 26: Applicant profile visibility và CV file cho recruiter

### Business logic

Stakeholder cần:

- Bật `Recruiters can discover profile` nghĩa là recruiter xem được toàn bộ profile, không cần bật lại từng visibility.
- Khi discover bị tắt, field visibility nào bật thì recruiter vẫn xem được field tương ứng.
- View Profile không hiển thị database ID.
- CV upload phải là file có thể mở/tải, không render đường dẫn hoặc nội dung file như text.

### Backend làm gì

`ApplicantMapper.toRecruiterVisibleApplicantResponse` dùng rule:

```text
effectiveVisibility(section) = profileVisibleToRecruiters OR sectionVisibility
```

Field không được phép xem được trả `null` ngay từ API. Recruiter-visible response không trả `cvId`, tên ẩn danh chỉ là `Candidate` và không ghép applicant database id.

### Frontend làm gì

`ApplicantDetail.tsx` không tự chặn contact chỉ dựa trên role nữa; UI render đúng những field backend trả về. Badge ID đã được thay bằng `Shared profile`. Nếu `cvFileUrl` tồn tại, UI tạo URL asset từ `API_BASE_URL` và hiển thị nút `Download CV file` mở file ở tab mới/thực hiện download.

### AI làm gì

AI Match vẫn dùng CV trong backend theo quyền của recruiter sở hữu JD, nhưng PII masking loại name/email/phone/link khỏi scoring. Privacy response quyết định recruiter thấy gì trên UI, không thay đổi score bằng noise.

### Flow data

```text
Applicant updates privacy
-> PUT /api/v1/applicants/{id}/privacy
-> Applicant fields persisted

Recruiter clicks View Profile
-> GET /api/v1/applicants/{id}
-> ApplicantMapper applies master OR section consent
-> hidden fields become null
-> ApplicantDetail renders only returned fields
-> shared cvFileUrl becomes Download CV file action
```

### Cách tiếp cận

Privacy enforcement nằm ở response mapper để dữ liệu bị ẩn không đến browser. Frontend không suy diễn lại quyền theo role vì cách đó từng làm mất cả field backend đã cho phép. Internal applicant id vẫn dùng trong route/API lookup nhưng không được render thành nội dung profile.

## Checklist nâng cấp quan trọng



4. Match score đã bỏ noise; tiếp tục regression test để bảo đảm raw AI score không bị thay đổi.
5. Giữ Differential Privacy cho applicant count vì đây là aggregate query phù hợp.
6. Candidate batch matching đã có; nếu cần recommended jobs thì bổ sung batch theo chiều applicant -> nhiều jobs.
7. Viết integration tests cho auth, upload CV, privacy visibility, DP count, matching.
8. Không log raw CV, raw PII, DP raw count/noise/secret.

