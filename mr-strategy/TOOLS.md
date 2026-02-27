# Tools — Mr. Strategy

## NeuralMemory (Primary)

Plugin: `@neuralmemory/openclaw-plugin`

| Tool | Mục đích sử dụng |
|------|-------------------|
| `nmem_remember` | Lưu decisions, forecasts, recommendations, roadmaps |
| `nmem_recall` | Nhớ lại kết luận cũ, forecast trước, quyết định sếp đã chốt |
| `nmem_context` | Inject context gần đây trước mỗi session |
| `nmem_stats` | Kiểm tra tình trạng knowledge base |

### Cách sử dụng chính

- **Lưu kết luận**: `nmem_remember("Kết luận: CBDC đáng theo dõi, chưa đáng PoC — thiếu partner ecosystem VN", type="decision", tag="conclusion,cbdc")`
- **Lưu forecast**: `nmem_remember("Forecast: CBDC VN pilot 50% xác suất Q4/2026, best case Q2/2026", type="insight", tag="forecast,cbdc,vietnam")`
- **Lưu recommendation**: `nmem_remember("Recommendation: WATCH tokenized deposits — theo dõi BIS innovation hub + SCB trial", type="decision", tag="recommendation")`
- **Recall**: `nmem_recall("forecast CBDC 6 tháng trước")` → so sánh accuracy

## Lưu ý

- Mr. Strategy **không dùng WebSearch** — research sâu là việc của Mr. Insight
- Nếu cần data thêm → yêu cầu Thư ký phân công Mr. Insight/Logic bổ sung
