# Tools — Thư ký Tiểu My

## NeuralMemory (Primary)

Plugin đã cấu hình: `@neuralmemory/openclaw-plugin`

| Tool | Mục đích sử dụng |
|------|-------------------|
| `nmem_remember` | Lưu decisions, briefs, quality standards, watchlist updates |
| `nmem_recall` | Nhớ lại quyết định cũ, tiêu chuẩn, context team |
| `nmem_context` | Inject context gần đây trước mỗi session |
| `nmem_todo` | Quản lý deadline, theo dõi tasks team |
| `nmem_stats` | Kiểm tra tình trạng brain/knowledge base |

### Cách sử dụng chính

- **Decision log**: `nmem_remember("Sếp chốt: triển khai PoC CBDC Q2", type="decision")`
- **Watchlist**: `nmem_remember("Theo dõi: PBOC digital yuan pilot mở rộng", type="fact", tag="watchlist")`
- **Quality update**: `nmem_remember("Bổ sung checklist: yêu cầu confidence level cho mọi claim", type="instruction")`
- **Recall**: `nmem_recall("quyết định về CBDC tuần trước")` → nhớ lại context

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
