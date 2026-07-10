# Hướng Dẫn Cơ Bản Về Differential Privacy

Tài liệu này giải thích từ đầu về cách project bảo vệ quyền riêng tư khi hiển thị số lượng ứng viên đã ứng tuyển một công việc.

Ví dụ trong website:

- nhà tuyển dụng đăng tin tuyển dụng;
- ứng viên ứng tuyển vào công việc;
- ứng viên khác mở trang chi tiết công việc;
- giao diện hiển thị: `Khoảng 18 ứng viên đã ứng tuyển`.

Từ `khoảng` rất quan trọng. Nó nói rõ rằng con số hiển thị không phải số chính xác trong database.

## 1. Vấn Đề Cần Bảo Vệ

Nếu website hiển thị số lượng ứng viên chính xác, người xem có thể suy luận hành vi riêng tư của người khác.

Ví dụ:

| Thời điểm | Số chính xác hiển thị | Điều có thể bị suy luận |
|---|---:|---|
| Buổi sáng | 10 | Đã có 10 người ứng tuyển |
| Buổi chiều | 11 | Vừa có thêm 1 người ứng tuyển |

Nếu người xem biết bạn của mình đang định ứng tuyển, việc số lượng tăng từ 10 lên 11 có thể làm họ đoán được người bạn đó đã ứng tuyển.

Chỉ ẩn tên ứng viên là chưa đủ. Chính con số đếm cũng có thể làm lộ thông tin.

## 2. Vì Sao Cần Hiển Thị Số Gần Đúng

Giả sử database có:

```text
Backend Engineer
Số ứng viên thật: 10
```

Nếu frontend hiển thị:

```text
10 ứng viên đã ứng tuyển
```

sau đó hiển thị:

```text
11 ứng viên đã ứng tuyển
```

thì người xem có thể biết chính xác vừa có thêm một ứng viên.

Giải pháp là thêm nhiễu có kiểm soát vào số thật:

```text
số thật = 10
nhiễu = -1
số hiển thị = 9
```

hoặc:

```text
số thật = 10
nhiễu = +2
số hiển thị = 12
```

Con số hiển thị vẫn hữu ích để người dùng hiểu mức độ quan tâm của công việc, nhưng không dễ làm lộ từng thay đổi nhỏ trong database.

## 3. Differential Privacy Là Gì

Differential privacy là một phương pháp công bố kết quả tổng hợp sao cho kết quả vẫn hữu ích, nhưng hạn chế việc suy ra thông tin của một cá nhân cụ thể.

Nói ngắn gọn:

> Kết quả công bố nên trông gần giống nhau dù một người cụ thể có nằm trong dữ liệu hay không.

Trong project này, differential privacy chỉ áp dụng cho dữ liệu tổng hợp, ví dụ:

- tổng số ứng viên đã ứng tuyển một công việc;
- số lượng theo nhóm công việc;
- điểm trung bình của một nhóm lớn.

Nó không tự động biến một hồ sơ ứng viên riêng lẻ thành ẩn danh.

## 4. Công Thức Chính

Định nghĩa phổ biến:

```text
Pr[M(D) in S] <= exp(epsilon) * Pr[M(D') in S]
```

Ý nghĩa các ký hiệu:

- `D`: tập dữ liệu gốc, ví dụ có 20 ứng viên.
- `D'`: tập dữ liệu láng giềng, giống `D` nhưng thêm hoặc bớt đúng 1 người.
- `M`: cơ chế tạo kết quả công bố, trong project này là code thêm nhiễu vào số ứng viên.
- `S`: một nhóm kết quả có thể xảy ra, ví dụ các kết quả từ 17 đến 20.
- `Pr`: xác suất.
- `epsilon`: tham số quyền riêng tư do hệ thống chọn.
- `exp(epsilon)`: `e` mũ `epsilon`, với `e` xấp xỉ `2.71828`.

Nếu `epsilon = 0.5`:

```text
exp(0.5) xấp xỉ 1.65
```

Công thức không nói rằng kết quả sai lệch 1.65 ứng viên. Nó nói rằng xác suất tạo ra một kết quả không được thay đổi quá mạnh khi thêm hoặc bớt một người.

## 5. Neighboring Dataset

Hai tập dữ liệu được gọi là láng giềng nếu chúng chỉ khác nhau ở dữ liệu của một người.

```text
D : 20 ứng viên đã ứng tuyển
D': 19 ứng viên đã ứng tuyển
```

Differential privacy so sánh khả năng output của `D` và `D'`. Nếu output quá khác nhau, người xem có thể suy ra sự có mặt của một cá nhân.

## 6. Sensitivity

Sensitivity là mức thay đổi lớn nhất của câu trả lời thật khi thêm hoặc bớt một người.

Query cần bảo vệ trong project:

```sql
COUNT(DISTINCT applicant_id)
```

với điều kiện chỉ đếm các ứng tuyển hợp lệ cho một công việc.

Nếu bớt một ứng viên:

```text
20 -> 19
```

kết quả chỉ thay đổi tối đa 1. Vì vậy:

```text
Delta f = 1
```

Nếu query bị sai, sensitivity cũng sai.

| Lỗi query | Vì sao nguy hiểm |
|---|---|
| Đếm duplicate row | Một người có thể làm count tăng nhiều hơn 1 |
| Đếm saved job | Lưu việc không phải ứng tuyển |
| Đếm hành động thay vì ứng viên | Một ứng viên có thể có nhiều hành động |
| Đếm cả ứng tuyển đã rút | Không phải ứng tuyển đang hoạt động |

## 7. Epsilon

`epsilon` là tham số điều chỉnh mức bảo vệ quyền riêng tư.

- epsilon nhỏ: bảo vệ mạnh hơn, nhiễu lớn hơn, kết quả kém chính xác hơn.
- epsilon lớn: bảo vệ yếu hơn, nhiễu nhỏ hơn, kết quả gần số thật hơn.

`epsilon` không phải:

- phần trăm sai số;
- số ứng viên bị ẩn;
- giá trị tính từ raw count;
- một secret.

Ví dụ cấu hình:

```yaml
privacy:
  differential:
    applicant-count:
      epsilon: 0.5
```

## 8. Vì Sao Noise Phải Ở Backend

Frontend chạy trên máy người dùng. Nếu backend gửi raw count về React rồi mới thêm noise, raw count đã bị lộ.

Đúng:

```text
Backend tính raw count -> thêm noise -> chỉ trả approximate count
```

Sai:

```text
Backend trả raw count -> React thêm noise
```

## 9. Sticky Noise

Nếu mỗi lần refresh lại tạo noise mới, người dùng có thể refresh nhiều lần rồi lấy trung bình để đoán raw count.

Vì vậy project dùng sticky release:

- cùng job;
- cùng metric;
- cùng audience;
- cùng release window;

thì trả về cùng một giá trị đã công bố.

Ví dụ release key:

```text
JOB_APPLICANT_COUNT|jobId=123|audience=APPLICANT|window=epoch-window-N
```

Giá trị đã công bố được lưu trong bảng `privacy_releases`.

## 10. Điều Cần Nhớ

- Differential privacy trong project này dùng cho số đếm tổng hợp, không dùng cho profile riêng lẻ.
- API không được trả `rawCount`, `noise`, seed, HMAC digest, secret, hoặc chi tiết epsilon nội bộ.
- Khi privacy service lỗi, không được fallback về số thật.
- UI phải hiển thị đây là con số gần đúng, không được làm người dùng hiểu đây là số chính xác.
