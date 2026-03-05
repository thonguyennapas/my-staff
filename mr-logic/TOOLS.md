# Tools — Mr. Logic

## Web Tools (CHỈ cho verify — KHÔNG research)

### ⚠️ Giới hạn tài nguyên (BẮT BUỘC)

| Giới hạn | Số lượng tối đa |
|----------|----------------|
| `web_search` | **2 lần** — chỉ để cross-check claim quan trọng nhất |
| `web_fetch` | **1 lần** — chỉ để verify link đáng ngờ nhất |
| `browser_navigate` | **1 lần** — fallback khi `web_fetch` bị Cloudflare chặn |

### Khi nào dùng

| Hành động | Tool |
|-----------|------|
| Cross-check claim quan trọng từ Mr. Insight | `web_search` (tối đa 2 lần) |
| Verify 1 link đáng ngờ (có thể bịa/sai) | `web_fetch` (tối đa 1 lần) |

### Lưu ý

- **KHÔNG research sâu** — đó là việc của Mr. Insight
- Chỉ verify **claim quan trọng nhất** hoặc **link đáng ngờ nhất**
- Ưu tiên dùng tóm tắt từ `web_search` — nhanh hơn `web_fetch`
- Nếu `web_fetch` bị chặn → thử `browser_navigate` 1 lần → vẫn fail thì ghi chú "chưa verify được link này"

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|---------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Validation results...")` |
| Trả lời yêu cầu bổ sung | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung confidence...")` |
