# Tools — Mr. Insight

## Mem0 Memory (Primary — Auto-recall + Auto-capture)

Plugin: `@mem0/openclaw-mem0` (Open Source, self-hosted)

> **Auto-recall** tự inject context trước khi respond. **Auto-capture** tự lưu sau mỗi exchange. Chỉ cần gọi tool thủ công khi muốn lưu/tìm cụ thể.

| Tool | Mục đích sử dụng |
|------|-------------------|
| `memory_store` | Lưu research findings, signals, nguồn tham chiếu, case studies |
| `memory_search` | Nhớ lại research cũ, nguồn đã tìm, signals từ tuần trước |
| `memory_list` | Liệt kê memories gần đây |
| `memory_get` | Xem chi tiết 1 memory |
| `memory_forget` | Xoá memory sai/cũ |

### Cách sử dụng chính

- **Lưu signal**: `memory_store("Signal: PBOC mở rộng pilot digital yuan sang 15 tỉnh — link: ...")`
- **Lưu case study**: `memory_store("Case: Bank of Israel pilot digital shekel với 2 ngân hàng — link: ...")`
- **Search**: `memory_search("CBDC pilots châu Á 2025-2026")` → nhớ lại research cũ

## Web Search (Primary — cho research)

| Tool | Mục đích |
|------|----------|
| `web_search` | Tìm nguồn chính thống, tin tức ngành, báo cáo mới (dùng Tavily, fallback Gemini) |
| `web_fetch` | Đọc nội dung trang web cụ thể (chuyển HTML → Markdown) |

### Lưu ý khi dùng web tools

- `web_search` → tìm links + tóm tắt → chọn link tốt → `web_fetch` → đọc chi tiết
- Ghi rõ **nguồn + ngày + tổ chức** cho mọi thông tin tìm được
- `web_fetch` không chạy JavaScript — nếu trang JS-heavy, thử tìm nguồn khác
- Luôn cross-check tối thiểu 2 nguồn cho claim quan trọng

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(agentId="thu-ky-tieu-my", message="Đây là research tuần này...")` |
| Trả lời yêu cầu sửa | `sessions_send(agentId="thu-ky-tieu-my", message="Đã bổ sung 3 signals...")` |
