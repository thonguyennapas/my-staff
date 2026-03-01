# Tools — Mr. Logic

## Mem0 Memory (Primary — Auto-recall + Auto-capture)

Plugin: `@mem0/openclaw-mem0` (Open Source, self-hosted)

> **Auto-recall** tự inject context trước khi respond. **Auto-capture** tự lưu sau mỗi exchange. Chỉ cần gọi tool thủ công khi muốn lưu/tìm cụ thể.

| Tool | Mục đích sử dụng |
|------|-------------------|
| `memory_store` | Lưu confidence assessments, risk findings, falsifiers, assumption banks |
| `memory_search` | Nhớ lại dữ kiện cũ, risk assessment trước đó, confidence history |
| `memory_list` | Liệt kê memories gần đây |
| `memory_get` | Xem chi tiết 1 memory |
| `memory_forget` | Xoá memory sai/cũ |

### Cách sử dụng chính

- **Lưu confidence**: `memory_store("Confidence: CBDC China rollout 2026 = HIGH — 3 nguồn confirm, pilot 15 tỉnh")`
- **Lưu risk**: `memory_store("Risk: Digital yuan privacy concern — MEDIUM — chưa có independent audit")`
- **Lưu falsifier**: `memory_store("Falsifier: CBDC adoption sẽ chậm NẾU Alipay/WeChat không integrate")`
- **Search**: `memory_search("risk assessment CBDC tuần trước")` → so sánh với tuần này

## Web Search (Secondary — cho verify)

| Tool | Mục đích |
|------|----------|
| `web_search` | Cross-check tin từ nhiều nguồn độc lập (dùng Tavily, fallback Gemini) |
| `web_fetch` | Đọc chi tiết trang nguồn cụ thể để verify claim |

### Lưu ý

- Chỉ dùng để **verify** — không research sâu (để Mr. Insight)
- Khi cross-check: tìm tối thiểu 2 nguồn độc lập
- Ghi rõ: nguồn nào confirm, nguồn nào mâu thuẫn

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Validation results...")` |
| Trả lời yêu cầu bổ sung | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung confidence...")` |
