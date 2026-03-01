# Tools — Thư ký Tiểu My

## Mem0 Memory (Primary — Auto-recall + Auto-capture)

Plugin: `@mem0/openclaw-mem0` (Open Source, self-hosted)

> **Auto-recall** tự inject context trước khi respond. **Auto-capture** tự lưu sau mỗi exchange. Chỉ cần gọi tool thủ công khi muốn lưu/tìm cụ thể.

### Tools khi cần thao tác thủ công

| Tool | Mục đích sử dụng |
|------|-------------------|
| `memory_store` | Lưu thủ công: decisions, briefs, quality standards, watchlist updates |
| `memory_search` | Tìm kiếm memory cụ thể: quyết định cũ, tiêu chuẩn, context team |
| `memory_list` | Liệt kê memories gần đây |
| `memory_get` | Xem chi tiết 1 memory cụ thể |
| `memory_forget` | Xoá memory không còn đúng/cần thiết |

## Inter-Agent Communication (sessions_send) — QUAN TRỌNG

Thư ký PHẢI dùng `sessions_send` để giao việc cho team. **KHÔNG tự làm chuyên môn.**

### Session Keys

| Agent | sessionKey |
|-------|-----------|
| Mr. Insight | `agent:mr-insight:main` |
| Mr. Logic | `agent:mr-logic:main` |
| Mr. Strategy | `agent:mr-strategy:main` |

### Cú pháp sessions_send

```
sessions_send(sessionKey="agent:mr-insight:main", message="...", timeoutSeconds=120)
```

### Ví dụ giao việc

| Hành động | Cách dùng |
|-----------|-----------|
| Giao Insight research | `sessions_send(sessionKey="agent:mr-insight:main", message="Research tin thanh toán thế giới tuần này, cần link nguồn cho mỗi tin")` |
| Giao Logic validate | `sessions_send(sessionKey="agent:mr-logic:main", message="Validate 5 tin này: [paste kết quả insight]. Cần confidence level + risk")` |
| Giao Strategy kết luận | `sessions_send(sessionKey="agent:mr-strategy:main", message="Chốt kết luận từ research + validation: [paste]. Cần forecast + đề xuất")` |
| Trả lại sửa | `sessions_send(sessionKey="agent:mr-insight:main", message="Thiếu 3 links nguồn, bổ sung ngay")` |

## Web Search (CHỈ dùng khi fallback)

| Tool | Mục đích |
|------|----------|
| `web_search` | **CHỈ** dùng khi team member timeout > 4 phút |
| `web_fetch` | **CHỈ** dùng khi cần fallback tự xử lý |

- KHÔNG dùng để tự research trả lời sếp
- KHÔNG dùng khi team đang hoạt động bình thường
