# Tools — Mr. Logic

## Web Search (Secondary — cho verify)

### Tools

| Tool | Mục đích | Khi nào dùng |
|------|----------|-------------|
| `web_search` | Cross-check tin từ nhiều nguồn (Tavily API) | **LUÔN dùng đầu tiên** |
| `web_fetch` | Đọc chi tiết trang nguồn cụ thể | Khi cần verify sâu 1 link |
| `browser_navigate` | Mở trang qua browser thật | **Fallback** khi `web_fetch` bị chặn (403/Cloudflare) |

### ⚠️ Xử lý khi web_fetch bị chặn

1. Thử `browser_navigate` 1 lần
2. Fail → `web_search` tìm nguồn khác ngay, không retry quá 2 lần

### Lưu ý

- Chỉ dùng để **verify** — research sâu là việc của Mr. Insight
- Khi cross-check: tìm tối thiểu 2 nguồn độc lập
- Ghi rõ: nguồn nào confirm, nguồn nào mâu thuẫn

## Inter-Agent Communication (sessions_send)

### Session Keys

| Agent | sessionKey |
|-------|-----------|
| Thư ký Tiểu My | `agent:thu-ky-tieu-my:main` |
| Mr. Insight | `agent:mr-insight:main` |

### Các hành động

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Validation results...")` |
| Trả lời yêu cầu bổ sung | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung confidence...")` |
| 🔥 Challenge Mr. Insight | `sessions_send(sessionKey="agent:mr-insight:main", message="⚖️ [CHALLENGE] ...")` |
| 🔥 Kết thúc debate | `sessions_send(sessionKey="agent:mr-insight:main", message="✅ VALIDATED ...")` |
