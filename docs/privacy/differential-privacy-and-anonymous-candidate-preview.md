# Differential Privacy Và Anonymous Candidate Preview

Tài liệu này phân biệt hai tính năng privacy trong project:

- applicant count được bảo vệ bằng differential privacy;
- anonymous candidate preview được bảo vệ bằng consent, access control và data minimization.

Hai tính năng này đều liên quan đến quyền riêng tư, nhưng không dùng cùng một mô hình bảo vệ.

## Phần A: Applicant Count Có Differential Privacy

Applicant-facing count là một aggregate query. Nó chỉ đếm số ứng viên khác nhau đã thật sự ứng tuyển vào một job:

```sql
COUNT(DISTINCT applicant_id)
```

Điều kiện:

- `action_type = 'APPLIED'`;
- không đếm saved job;
- không đếm bookmark;
- không đếm withdrawn application;
- không đếm cancelled application;
- không đếm deleted record;
- không đếm duplicate application row nhiều lần.

Differential privacy chỉ áp dụng cho aggregate count này. Nó không biến hồ sơ riêng lẻ của một ứng viên thành differential privacy output.

### Sensitivity

Với count query trên:

```text
Delta f = 1
```

Một ứng viên được thêm vào hoặc bị xóa ra chỉ có thể làm count thay đổi tối đa 1.

### Epsilon

`epsilon` là tham số privacy do system owner chọn.

`epsilon` không phải:

- giá trị tính từ raw count;
- phần trăm sai số;
- số ứng viên được thêm hoặc bớt;
- secret.

Epsilon nhỏ bảo vệ privacy mạnh hơn nhưng noise lớn hơn. Epsilon lớn cho kết quả gần raw count hơn nhưng privacy yếu hơn.

### Noise Mechanism

Laplace mechanism:

```text
b = Delta f / epsilon
```

Với applicant count:

```text
b = 1 / epsilon
```

Laplace density:

```text
f(z) = 1 / (2b) * exp(-abs(z) / b)
```

Project dùng biến thể integer-only discrete Laplace / two-sided geometric:

```text
q = exp(-epsilon)
P(Z = k) = ((1 - q) / (1 + q)) * q^abs(k)
```

Giá trị công bố:

```text
max(0, rawCount + Z)
```

### Sticky Release

Release được giữ cố định cho cùng job, metric, audience và release window.

Dạng release key:

```text
JOB_APPLICANT_COUNT|jobId=123|audience=APPLICANT|window=epoch-window-N
```

Backend dùng HMAC-SHA-256 với `DP_RELEASE_SECRET` để tạo deterministic randomness. Giá trị released được lưu trong PostgreSQL tại bảng `privacy_releases`, nên nó tồn tại qua restart và dùng được với nhiều backend instance.

Applicant-facing response không bao giờ được serialize:

- raw count;
- epsilon internals;
- HMAC digest;
- random seed;
- generated noise;
- secret.

### Cấu Hình

```yaml
privacy:
  differential:
    enabled: true
    applicant-count:
      epsilon: 0.5
      release-window: P7D
      release-secret: ${DP_RELEASE_SECRET}
```

## Phần B: Anonymous Candidate Preview

Anonymous candidate preview không phải differential privacy.

Nó là cơ chế chia sẻ một phần thông tin hồ sơ ứng viên theo các nguyên tắc:

- ứng viên phải đồng ý;
- chỉ applicant cùng ứng tuyển vào job mới được xem;
- chỉ trả về trường tổng quát;
- không trả định danh trực tiếp;
- không hiển thị khi nhóm ứng viên quá nhỏ.

Thêm noise vào một profile riêng lẻ không làm profile đó trở thành differential privacy.

### Consent

Ứng viên chỉ xuất hiện trong preview khi:

```text
profile_visible_to_other_applicants = true
```

Giá trị mặc định phải là `false`.

Recruiter visibility là quyền riêng:

```text
profile_visible_to_recruiters = true
```

Quyền này không đồng nghĩa với việc cho applicant khác xem preview.

### Trường Được Phép Trả Về

Chỉ nên trả các trường rộng và khó định danh:

- experience bucket;
- approved broad skill categories;
- education level;
- broad geographic region;
- broad current-role category.

### Trường Cấm Trả Về

Không được trả:

- database applicant ID;
- user ID;
- full name;
- username;
- email;
- phone number;
- exact address;
- date of birth;
- gender, trừ khi có lý do rõ ràng và consent riêng;
- CV URL;
- profile image;
- exact company name;
- exact university name;
- exact employment dates;
- exact application timestamp;
- certificate serial number;
- social media URL;
- portfolio URL;
- unique biography;
- internal identifiers.

### Skill Minimization

Raw skill text có thể làm lộ danh tính nếu quá hiếm. Vì vậy service map skill về các nhóm rộng:

- Backend;
- Frontend;
- Database;
- Cloud;
- DevOps;
- Data;
- Machine Learning;
- Mobile;
- Quality Assurance;
- Product Design;
- General Software.

### Anonymous ID

Anonymous identifier phải là opaque token tạo bằng HMAC, không phải `applicant_id`.

Token nên scope theo:

- viewer;
- job;
- candidate;
- rotation window.

Như vậy một candidate khó bị correlate qua các job khác nhau hoặc qua thời gian dài.

### Điều Kiện Truy Cập

Người gọi API phải thỏa:

- đã xác thực;
- có role applicant;
- đã ứng tuyển vào cùng job;
- job tồn tại;
- feature đang enabled;
- target candidate đã opt-in;
- target candidate có relation `APPLIED` còn hiệu lực;
- số ứng viên eligible đạt ngưỡng tối thiểu.

Người chỉ saved job không được xem preview. Client cũng không được chọn candidate ID; backend tự chọn sample nhỏ trong rotation window.

### Small-Group Suppression

Nếu nhóm opted-in eligible quá nhỏ, API phải trả unavailable và không lộ exact eligible count.

Ví dụ:

```json
{
  "available": false,
  "message": "Anonymous candidate previews are unavailable for this job.",
  "profiles": []
}
```

### Cấu Hình

```yaml
privacy:
  anonymous-candidate-preview:
    enabled: true
    minimum-eligible-candidates: 10
    maximum-previews: 3
    rotation-window: P7D
    rate-limit-per-window: 20
    token-secret: ${ANON_PREVIEW_TOKEN_SECRET}
```

## Giới Hạn Cần Chấp Nhận

Anonymous preview giảm rủi ro định danh trực tiếp, nhưng không bảo đảm ẩn danh tuyệt đối. Nếu người xem có kiến thức bên ngoài, họ vẫn có thể suy đoán trong một số trường hợp.

Cần giữ các biện pháp sau:

- threshold đủ lớn;
- category đủ rộng;
- identifier có rotate;
- rate limiting;
- logging và monitoring hợp lý;
- không trả exact field.

## Checklist Test

Cần test:

- distinct aggregate semantics;
- saved/withdrawn exclusion;
- epsilon validation;
- clamping về 0;
- sticky release;
- response minimization;
- consent separation;
- same-job access control;
- saved-job denial;
- small-group suppression;
- prohibited fields;
- broad skill mapping;
- scoped/rotating anonymous IDs;
- không có unrestricted pagination;
- rate limiting;
- withdrawn applicant exclusion.
