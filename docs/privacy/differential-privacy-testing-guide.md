# Hướng Dẫn Kiểm Thử Privacy

Tài liệu này mô tả các nhóm test cần có cho differential privacy count và anonymous candidate preview.

## 1. Lệnh Chạy Test

Backend:

```bash
cd backend
./mvnw test
```

Chạy riêng privacy integration test:

```bash
cd backend
./mvnw -Dtest=DATN.backend.BackendEndpointsIntegrationTests#applicantFacingCountShouldBeDifferentiallyPrivateStickyAndDistinct test
```

Frontend build:

```bash
cd frontend
npm run build
```

Frontend test:

```bash
cd frontend
npm run test
```

## 2. Test Cho Raw Count Query

### Đếm distinct ứng viên đã ứng tuyển

Cần đảm bảo query đúng:

```sql
COUNT(DISTINCT applicant_id)
```

Lý do: differential privacy giả định rằng một ứng viên chỉ làm count thay đổi tối đa 1.

### Không đếm saved job

Lưu việc không phải ứng tuyển. Saved job không được làm tăng applicant count.

### Không đếm withdrawn application

Ứng viên đã rút hồ sơ không nên được tính là ứng viên đang ứng tuyển.

### Không đếm deleted record

Application, applicant hoặc job đã delete không được ảnh hưởng count đang hiển thị.

### Không đếm duplicate row nhiều lần

Nếu một ứng viên có nhiều row liên quan đến cùng job, count vẫn chỉ tăng 1.

## 3. Test Cho Noise Generator

### Epsilon phải lớn hơn 0

`epsilon = 0` hoặc epsilon âm là cấu hình không hợp lệ.

### Epsilon nhỏ tạo noise rộng hơn

Epsilon nhỏ nghĩa là bảo vệ privacy mạnh hơn, nên output phải có độ phân tán lớn hơn.

### Epsilon lớn tạo noise hẹp hơn

Epsilon lớn nghĩa là privacy yếu hơn, output gần raw count hơn.

### Không viết test random quá mong manh

Một lần sample không chứng minh distribution đúng. Nếu cần test hành vi thống kê, sample nhiều lần và chỉ kiểm tra xu hướng rộng.

Production path hiện dùng deterministic HMAC-derived bytes, nên sticky release test có thể deterministic.

## 4. Test Cho Sticky Release

### Cùng job và release window trả cùng một giá trị

Refresh nhiều lần không được tạo noise mới liên tục, vì người dùng có thể lấy trung bình để đoán raw count.

### Nhiều applicant thấy cùng một release

Release key của aggregate count không phụ thuộc vào viewer identity. Hai applicant khác nhau xem cùng job trong cùng window nên nhận cùng approximate count.

### Release được persist

Giá trị đã công bố phải tồn tại qua restart và dùng được với nhiều backend instance chung PostgreSQL.

## 5. Test Bảo Mật API

### Endpoint yêu cầu applicant role

Applicant-facing count chỉ dành cho applicant đã xác thực.

### Response không serialize raw data

Cấm trả về:

- `rawCount`;
- `noise`;
- `secret`;
- `seed`;
- `epsilonCalculation`;
- HMAC digest.

### Không có exact fallback

Khi privacy logic lỗi, API phải trả error/unavailable thay vì raw count.

## 6. Test DTO Shape

Expected fields:

- `jobId`;
- `approximateApplicantCount`;
- `displayText`;
- `approximate`.

Forbidden fields:

- `rawCount`;
- `noise`;
- `secret`;
- `seed`;
- `epsilonCalculation`.

## 7. Test Frontend

### Applicant thấy label approximate

UI phải hiển thị ý nghĩa gần đúng, ví dụ:

```text
Approximately N candidates have applied
```

hoặc bản tiếng Việt:

```text
Khoảng N ứng viên đã ứng tuyển
```

### Có loading, error và retry state

Nếu request lỗi, UI không nên im lặng ẩn thông tin. Cần có trạng thái lỗi và cách thử lại.

### Frontend không gọi exact count endpoint cho applicant

Applicant không được nhận raw count từ bất kỳ API nào.

## 8. Test Anonymous Candidate Preview

### Chỉ ứng viên đã opt-in mới được hiển thị

Trường `profileVisibleToOtherApplicants` phải là `true`.

### Recruiter visibility không thay thế applicant visibility

`profileVisibleToRecruiters = true` không có nghĩa là cho phép ứng viên khác xem preview.

### Saved-job user không được xem preview

Người chỉ lưu công việc nhưng chưa ứng tuyển không được truy cập preview.

### Nhóm quá nhỏ bị suppress

Nếu số ứng viên hợp lệ quá ít, API phải trả unavailable và không lộ exact eligible count.

### Không trả direct identifier

Cấm trả:

- applicant ID;
- user ID;
- name;
- email;
- phone;
- address;
- CV URL;
- exact company;
- exact university.

### Anonymous ID phải scoped và rotate

Anonymous ID phải phụ thuộc vào viewer, job, candidate và rotation window để giảm khả năng correlate qua thời gian và qua job.

## 9. Test Coverage Hiện Tại

`BackendEndpointsIntegrationTests` đang bao phủ các điểm chính:

- distinct count semantics;
- saved và withdrawn exclusion;
- sticky release;
- nhiều applicant thấy cùng release;
- response không lộ raw count/noise;
- opt-in anonymous preview;
- saved-only user bị từ chối;
- small-group suppression;
- broad skill categories;
- scoped anonymous IDs;
- rate limiting.
