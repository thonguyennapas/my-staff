# Tools — Mr. Logic

## NeuralMemory (Primary)

Plugin: `@neuralmemory/openclaw-plugin`

| Tool | Mục đích sử dụng |
|------|-------------------|
| `nmem_remember` | Lưu confidence assessments, risk findings, falsifiers, assumption banks |
| `nmem_recall` | Nhớ lại dữ kiện cũ, risk assessment trước đó, confidence history |
| `nmem_context` | Inject context gần đây trước mỗi session |
| `nmem_stats` | Kiểm tra tình trạng knowledge base |

### Cách sử dụng chính

- **Lưu confidence**: `nmem_remember("Confidence: CBDC China rollout 2026 = HIGH — 3 nguồn confirm, pilot 15 tỉnh", type="fact", tag="confidence,cbdc")`
- **Lưu risk**: `nmem_remember("Risk: Digital yuan privacy concern — MEDIUM — chưa có independent audit", type="insight", tag="risk,cbdc,china")`
- **Lưu falsifier**: `nmem_remember("Falsifier: CBDC adoption sẽ chậm NẾU Alipay/WeChat không integrate", type="insight", tag="falsifier,cbdc")`
- **Recall**: `nmem_recall("risk assessment CBDC tuần trước")` → so sánh với tuần này

## WebSearch / Tavily (Secondary)

- Đối chiếu nguồn: cross-check tin từ nhiều nguồn độc lập
- Verify facts: kiểm tra claim cụ thể có bằng chứng không
- Không dùng để research sâu (để Mr. Insight)
