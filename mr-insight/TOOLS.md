# Tools — Mr. Insight

## NeuralMemory (Primary)

Plugin: `@neuralmemory/openclaw-plugin`

| Tool | Mục đích sử dụng |
|------|-------------------|
| `nmem_remember` | Lưu research findings, signals, nguồn tham chiếu, case studies |
| `nmem_recall` | Nhớ lại research cũ, nguồn đã tìm, signals từ tuần trước |
| `nmem_context` | Inject context gần đây trước mỗi session |
| `nmem_stats` | Kiểm tra tình trạng knowledge base |

### Cách sử dụng chính

- **Lưu signal**: `nmem_remember("Signal: PBOC mở rộng pilot digital yuan sang 15 tỉnh — link: ...", type="fact", tag="signal,cbdc,china")`
- **Lưu case study**: `nmem_remember("Case: Bank of Israel pilot digital shekel với 2 ngân hàng — link: ...", type="fact", tag="case-study,israel,cbdc")`
- **Recall**: `nmem_recall("CBDC pilots châu Á 2025-2026")` → nhớ lại research cũ

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
