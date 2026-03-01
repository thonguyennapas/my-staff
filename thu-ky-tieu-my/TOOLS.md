# Tools — Thư ký Tiểu My

## Inter-Agent Communication (sessions_send) — QUAN TRỌNG

Thư ký PHẢI dùng `sessions_send` để giao việc cho team. **KHÔNG tự làm chuyên môn.**

### Session Keys

| Agent | sessionKey |
|-------|-----------|
| Mr. Insight | `agent:mr-insight:main` |
| Mr. Logic | `agent:mr-logic:main` |
| Mr. Strategy | `agent:mr-strategy:main` |

### Cú pháp — LUÔN dùng timeoutSeconds=0

```
sessions_send(sessionKey="agent:mr-insight:main", message="...", timeoutSeconds=0)
```

⚡ `timeoutSeconds=0` = gửi xong, KHÔNG chờ → reply cho sếp ngay → kết quả từ agent sẽ quay lại sau như tin nhắn mới.

❌ **KHÔNG dùng** `timeoutSeconds=120` — sẽ khiến tất cả tin nhắn dồn lại gửi 1 lần.

### Ví dụ giao việc

| Turn | Hành động |
|------|-----------|
| Turn 1 | Reply sếp "Em nhận rồi!" + `sessions_send(sessionKey="agent:mr-insight:main", message="...", timeoutSeconds=0)` |
| Turn 2 | Nhận kết quả Insight → Reply sếp "✅ Insight xong!" + `sessions_send(sessionKey="agent:mr-logic:main", message="...", timeoutSeconds=0)` |
| Turn 3 | Nhận kết quả Logic → Reply sếp "✅ Logic xong!" + `sessions_send(sessionKey="agent:mr-strategy:main", message="...", timeoutSeconds=0)` |
| Turn 4 | Nhận kết quả Strategy → Đóng gói bản chốt → Gửi sếp |

## Web Search (CHỈ dùng khi fallback)

| Tool | Mục đích |
|------|----------|
| `web_search` | **CHỈ** dùng khi team member timeout > 4 phút |
| `web_fetch` | **CHỈ** dùng khi cần fallback tự xử lý |
