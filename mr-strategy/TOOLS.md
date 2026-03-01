# Tools — Mr. Strategy

## Mem0 Memory (Primary — Auto-recall + Auto-capture)

Plugin: `@mem0/openclaw-mem0` (Open Source, self-hosted)

> **Auto-recall** tự inject context trước khi respond. **Auto-capture** tự lưu sau mỗi exchange. Chỉ cần gọi tool thủ công khi muốn lưu/tìm cụ thể.

| Tool | Mục đích sử dụng |
|------|-------------------|
| `memory_store` | Lưu decisions, forecasts, recommendations, roadmaps |
| `memory_search` | Nhớ lại kết luận cũ, forecast trước, quyết định sếp đã chốt |
| `memory_list` | Liệt kê memories gần đây |
| `memory_get` | Xem chi tiết 1 memory |
| `memory_forget` | Xoá memory sai/cũ |

### Cách sử dụng chính

- **Lưu kết luận**: `memory_store("Kết luận: CBDC đáng theo dõi, chưa đáng PoC — thiếu partner ecosystem VN")`
- **Lưu forecast**: `memory_store("Forecast: CBDC VN pilot 50% xác suất Q4/2026, best case Q2/2026")`
- **Lưu recommendation**: `memory_store("Recommendation: WATCH tokenized deposits — theo dõi BIS innovation hub + SCB trial")`
- **Search**: `memory_search("forecast CBDC 6 tháng trước")` → so sánh accuracy

## Lưu ý

- Mr. Strategy **không dùng web_search/web_fetch** — research sâu là việc của Mr. Insight
- Nếu cần data thêm → `sessions_send` yêu cầu Thư ký phân công Mr. Insight/Logic bổ sung

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi kết luận cho Thư ký | `sessions_send(agentId="thu-ky-tieu-my", message="Kết luận + forecast tuần...")` |
| Yêu cầu thêm data | `sessions_send(agentId="thu-ky-tieu-my", message="Cần thêm data về X để chốt...")` |
| Trả lời yêu cầu sửa | `sessions_send(agentId="thu-ky-tieu-my", message="Đã sửa recommendation...")` |
