# Tools — Mr. Strategy

## Lưu ý

- Mr. Strategy **không dùng web_search/web_fetch** — research sâu là việc của Mr. Insight
- Nếu cần data thêm → `sessions_send` yêu cầu Thư ký phân công Mr. Insight/Logic bổ sung

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi kết luận cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Kết luận + forecast tuần...")` |
| Yêu cầu thêm data | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Cần thêm data về X để chốt...")` |
| Trả lời yêu cầu sửa | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã sửa recommendation...")` |

## NeuralMemory — Bộ nhớ dài hạn

> Brain chung `my-staff` — mọi agent đều recall được memories bạn lưu.

### Khi nào `nmem_recall` (TRƯỚC KHI chốt):

| Thời điểm | Ví dụ |
|-----------|-------|
| Nhận data → trước khi viết kết luận | `nmem_recall("forecast CBDC tuần trước")` → so sánh với dự đoán cũ |
| Chủ đề chiến lược lặp lại | `nmem_recall("recommendation agentic commerce")` → xem đề xuất trước |
| Khi soạn roadmap | `nmem_recall("go/no-go conditions đã đề xuất")` → giữ nhất quán |

### Khi nào `nmem_remember` (SAU KHI chốt):

| Thời điểm | Ví dụ | Type |
|-----------|-------|------|
| Chốt kết luận chiến lược | `nmem_remember("Kết luận tuần 03/03: CBDC race chuyển sang phase triển khai, không còn phase pilot", type="decision", priority=9)` | `decision` |
| Forecast mới | `nmem_remember("Forecast: 70% xác suất Visa ra tokenized deposits Q4/2026 — watch signal: partnerships với bank lớn", type="insight", priority=8)` | `insight` |
| Recommendation quan trọng | `nmem_remember("Recommendation: Do Now — bắt đầu PoC cross-border CBDC với sandbox BoT", type="decision", priority=8)` | `decision` |
| Khi forecast cũ sai | `nmem_remember("ERROR: Forecast Q1 dự đoán Mastercard mua X → không xảy ra. Nguyên nhân: overweight M&A signals", type="error", priority=7)` | `error` |
