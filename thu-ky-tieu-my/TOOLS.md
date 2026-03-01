# Tools — Thư ký Tiểu My

## Mem0 Memory (Primary — Auto-recall + Auto-capture)

Plugin: `@mem0/openclaw-mem0` (Open Source, self-hosted)

> **Lưu ý quan trọng**: Mem0 có **Auto-recall** (tự nhớ lại context trước khi respond) và **Auto-capture** (tự lưu memories sau mỗi cuộc trò chuyện). Không cần gọi tool thủ công cho đa số trường hợp — hệ thống tự lo.

### Tools khi cần thao tác thủ công

| Tool | Mục đích sử dụng |
|------|-------------------|
| `memory_store` | Lưu thủ công: decisions, briefs, quality standards, watchlist updates |
| `memory_search` | Tìm kiếm memory cụ thể: quyết định cũ, tiêu chuẩn, context team |
| `memory_list` | Liệt kê memories gần đây |
| `memory_get` | Xem chi tiết 1 memory cụ thể |
| `memory_forget` | Xoá memory không còn đúng/cần thiết |

### Cách sử dụng chính

- **Decision log**: `memory_store("Sếp chốt: triển khai PoC CBDC Q2")`
- **Watchlist**: `memory_store("Theo dõi: PBOC digital yuan pilot mở rộng")`
- **Quality update**: `memory_store("Bổ sung checklist: yêu cầu confidence level cho mọi claim")`
- **Search**: `memory_search("quyết định về CBDC tuần trước")` → nhớ lại context
- **Quên**: `memory_forget(id)` → xoá memory sai/cũ

### Auto-recall & Auto-capture (tự động)

- ✅ **Trước khi respond** → Mem0 tự tìm memories liên quan → inject vào context
- ✅ **Sau khi respond** → Mem0 tự trích xuất facts, decisions, preferences → lưu lại
- → Agent không cần gọi tool nhớ thủ công cho đa số trường hợp

## Web Search (Secondary)

| Tool | Mục đích |
|------|----------|
| `web_search` | Kiểm tra nhanh thông tin khi cần verify trước khi đóng gói |
| `web_fetch` | Đọc nội dung trang web cụ thể nếu cần check nguồn |

- Không dùng để research sâu (để Mr. Insight)

## Inter-Agent Communication (sessions_send)

Thư ký có thể **gửi tin nhắn trực tiếp** cho các thành viên team:

| Hành động | Cách dùng |
|-----------|-----------|
| Giao việc cho Mr. Insight | `sessions_send(agentId="mr-insight", message="Gom tin CBDC tuần này...")` |
| Yêu cầu Mr. Logic validate | `sessions_send(agentId="mr-logic", message="Validate 5 tin này...")` |
| Yêu cầu Mr. Strategy kết luận | `sessions_send(agentId="mr-strategy", message="Chốt kết luận tuần...")` |
| Trả lại sửa | `sessions_send(agentId="mr-insight", message="Thiếu signals, bổ sung 3 tín hiệu...")` |

### Quy trình review & trả lại sửa

1. Nhận output từ team member
2. Kiểm tra qua quality gate (checklist)
3. Nếu **chưa đạt** → `sessions_send` trả lại với feedback cụ thể:
   - Thiếu gì? (nguồn/link, signals, confidence, kết luận...)
   - Tiêu chuẩn sửa: Must fix / Should improve / Nice to have
   - Deadline sửa
4. Nhận bản sửa → kiểm tra lại → đóng gói nếu đạt
