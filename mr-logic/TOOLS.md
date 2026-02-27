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
| Gửi output cho Thư ký | `sessions_send(agentId="thu-ky-tieu-my", message="Validation results...")` |
| Trả lời yêu cầu bổ sung | `sessions_send(agentId="thu-ky-tieu-my", message="Đã bổ sung confidence...")` |
