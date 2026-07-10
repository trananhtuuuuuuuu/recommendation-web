# Lý Thuyết Và Kế Hoạch Triển Khai Differential Privacy

Tài liệu này nói ngắn gọn về lý thuyết cần biết và cách áp dụng vào backend của project.

## 1. Mục Tiêu

Tính năng applicant-facing count chỉ nên cho người dùng biết mức độ quan tâm của một công việc, không cho họ biết chính xác từng thay đổi trong database.

Ví dụ UI nên hiển thị:

```text
Khoảng 18 ứng viên đã ứng tuyển
```

không nên hiển thị:

```text
Chính xác 18 ứng viên đã ứng tuyển
```

## 2. Công Thức Differential Privacy

```text
Pr[M(D) in S] <= exp(epsilon) * Pr[M(D') in S]
```

Ý nghĩa:

- `D`: tập dữ liệu gốc.
- `D'`: tập dữ liệu láng giềng, khác `D` đúng một người.
- `M`: mechanism tạo output, ví dụ hàm thêm noise vào count.
- `S`: một tập output có thể xảy ra.
- `Pr`: xác suất.
- `epsilon`: tham số quyền riêng tư.

Bảo đảm cần hiểu:

> Sự có mặt của một người cụ thể không được làm output trở nên quá khác biệt.

## 3. Sensitivity Của Applicant Count

Raw query:

```sql
COUNT(DISTINCT applicant_id)
```

với điều kiện:

```text
actionType = "APPLIED"
```

và bỏ qua saved job, bookmark, withdrawn, cancelled, deleted record, duplicate row.

Với query này, một ứng viên chỉ có thể làm count thay đổi tối đa 1:

```text
Delta f = 1
```

## 4. Laplace Mechanism

Cơ chế Laplace liên tục dùng:

```text
b = Delta f / epsilon
```

Với applicant count:

```text
Delta f = 1
b = 1 / epsilon
```

Nếu `epsilon = 0.5`:

```text
b = 2
```

Noise:

```text
Z ~ Laplace(0, b)
```

Giá trị công bố:

```text
max(0, round(rawCount + Z))
```

## 5. Cơ Chế Đang Dùng Trong Project

Vì output là số nguyên, project dùng biến thể integer-valued discrete Laplace / two-sided geometric:

```text
q = exp(-epsilon)
P(Z = k) = ((1 - q) / (1 + q)) * q^abs(k)
```

Giá trị trả về:

```text
releasedCount = max(0, rawCount + Z)
```

`max(0, ...)` là post-processing hợp lệ vì không dùng lại raw data.

## 6. Kế Hoạch Triển Khai

1. Giữ raw count trong backend.
2. Query bằng `COUNT(DISTINCT applicant_id)`.
3. Chỉ đếm relation có `actionType = "APPLIED"`.
4. Validate `epsilon > 0`.
5. Tạo release key từ job, metric, audience và release window.
6. Kiểm tra bảng `privacy_releases`.
7. Nếu đã có release, trả lại giá trị đã lưu.
8. Nếu chưa có release, tính raw count trong backend.
9. Dùng HMAC-SHA-256 với secret để tạo deterministic randomness.
10. Sample integer noise.
11. Clamp kết quả về tối thiểu 0.
12. Lưu released value, không lưu raw count hay noise.
13. Trả DTO an toàn về frontend.
14. Frontend hiển thị label `Khoảng ...`.

## 7. Vì Sao Không Thêm Noise Ở Frontend

React chạy trên thiết bị người dùng. Nếu raw count đã được gửi tới frontend, thông tin đã bị lộ dù cho UI có cộng thêm noise sau đó.

Backend phải là nơi duy nhất thấy:

- raw count;
- generated noise;
- epsilon internals;
- HMAC secret;
- HMAC digest.

## 8. Vì Sao Không Được Exact Fallback

Nếu privacy service lỗi mà API trả raw count, người dùng có thể lợi dụng lỗi này để lấy số thật.

Đúng:

```text
Trả lỗi hoặc trạng thái unavailable
```

Sai:

```text
Trả raw count khi privacy service lỗi
```

## 9. Điều Kiện API Response

Response được phép có:

- `jobId`;
- `approximateApplicantCount`;
- `displayText`;
- `approximate`.

Response không được có:

- `rawCount`;
- `noise`;
- `seed`;
- `secret`;
- `epsilonCalculation`;
- HMAC digest.
