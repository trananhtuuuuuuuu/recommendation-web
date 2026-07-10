# Bảng Thuật Ngữ Privacy

Tài liệu này giải thích ngắn gọn các thuật ngữ được dùng trong nhóm tài liệu privacy.

## Aggregate

Kết quả tổng hợp từ nhiều người.

Ví dụ:

```text
Tổng số ứng viên đã ứng tuyển job 123.
```

## Anonymization

Việc xóa hoặc thay đổi định danh trực tiếp như tên, email, số điện thoại.

Lưu ý: anonymization không bảo đảm tuyệt đối rằng không ai có thể tái định danh người dùng.

## Approximate Count

Số đếm gần đúng, không phải số thật trong database.

Ví dụ:

```text
Khoảng 18 ứng viên đã ứng tuyển.
```

## Composition

Privacy loss có thể cộng dồn qua nhiều lần công bố.

Ví dụ:

```text
4 releases * epsilon 0.5 = tổng epsilon 2.0
```

## Data Minimization

Chỉ chia sẻ lượng dữ liệu nhỏ nhất cần thiết.

Ví dụ: chia sẻ `Backend` thay vì danh sách skill quá chi tiết và hiếm.

## Deterministic Randomness

Giá trị trông như ngẫu nhiên nhưng lặp lại với cùng input.

Ví dụ: job 123 trong cùng release window luôn có cùng noisy count.

## Differential Privacy

Phương pháp công bố kết quả tổng hợp sao cho kết quả vẫn hữu ích, nhưng sự có mặt của một người cụ thể không làm output thay đổi quá mạnh.

## Epsilon

Tham số privacy do hệ thống chọn.

- Epsilon nhỏ: privacy mạnh hơn, noise lớn hơn.
- Epsilon lớn: privacy yếu hơn, noise nhỏ hơn.

Epsilon không phải phần trăm sai số và không phải số ứng viên bị ẩn.

## Geometric Random Variable

Biến ngẫu nhiên nhận giá trị số nguyên, trong đó giá trị nhỏ thường có xác suất cao hơn giá trị lớn.

Có thể dùng để tạo integer noise.

## HMAC

Hàm hash có khóa bí mật.

Dạng đơn giản:

```text
input + secret key -> output trông như ngẫu nhiên
```

Secret key phải nằm trong backend.

## Laplace Distribution

Phân phối xác suất trong đó các giá trị gần 0 xuất hiện nhiều hơn, giá trị xa 0 xuất hiện ít hơn.

Thường được dùng để thêm noise trong differential privacy.

## Neighboring Datasets

Hai tập dữ liệu chỉ khác nhau ở dữ liệu của một người.

Ví dụ:

```text
D : 20 ứng viên
D': 19 ứng viên
```

## Noise

Số ngẫu nhiên được cộng vào kết quả thật.

Ví dụ:

```text
raw count 20 + noise -2 = displayed count 18
```

## Post-Processing

Xử lý kết quả đã thêm noise mà không dùng lại raw data.

Ví dụ:

```text
max(0, noisyCount)
```

## Probability Distribution

Quy tắc mô tả giá trị ngẫu nhiên nào dễ xuất hiện hơn.

Ví dụ: noise `0` thường dễ xuất hiện hơn noise `10`.

## Privacy Budget

Giới hạn tổng privacy loss qua thời gian.

Dùng để kiểm soát việc công bố lặp lại qua nhiều window hoặc nhiều metric.

## Probability Density

Với phân phối liên tục, density mô tả nơi nào giá trị tập trung nhiều hơn.

Laplace density:

```text
f(z) = 1 / (2b) * exp(-abs(z) / b)
```

`b` là scale. `b` càng lớn thì noise càng rộng.

## Re-Identification

Tái định danh một người ẩn danh bằng cách ghép thông tin gián tiếp với kiến thức bên ngoài.

## Release Window

Khoảng thời gian mà một giá trị privacy-protected được tái sử dụng.

Ví dụ:

```text
P7D = 7 ngày
```

## Sensitivity

Mức thay đổi lớn nhất của câu trả lời thật khi thêm hoặc bớt một người.

Với applicant count:

```text
Delta f = 1
```

## Sticky Noise

Noise được giữ cố định cho cùng job, metric, audience và release window.

Dùng để ngăn người dùng refresh nhiều lần rồi lấy trung bình.

## Threat Model

Mô tả kẻ tấn công có thể biết gì và muốn suy ra điều gì.

Ví dụ: một applicant biết bạn mình có thể ứng tuyển và liên tục theo dõi applicant count.
