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

## WebSearch (Secondary)

- Kiểm tra nhanh thông tin khi cần verify trước khi đóng gói
- Không dùng để research sâu (để Mr. Insight)
