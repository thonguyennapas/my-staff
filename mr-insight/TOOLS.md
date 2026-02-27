# Tools — Mr. Insight

## NeuralMemory (Primary)

Plugin: `@neuralmemory/openclaw-plugin`

| Tool | Mục đích sử dụng |
|------|-------------------|
| `nmem_remember` | Lưu research findings, signals, nguồn tham chiếu, case studies |
| `nmem_recall` | Nhớ lại research cũ, nguồn đã tìm, signals từ tuần trước |
| `nmem_context` | Inject context gần đây trước mỗi session |
| `nmem_stats` | Kiểm tra tình trạng knowledge base |

### Cách sử dụng chính

- **Lưu signal**: `nmem_remember("Signal: PBOC mở rộng pilot digital yuan sang 15 tỉnh — link: ...", type="fact", tag="signal,cbdc,china")`
- **Lưu case study**: `nmem_remember("Case: Bank of Israel pilot digital shekel với 2 ngân hàng — link: ...", type="fact", tag="case-study,israel,cbdc")`
- **Recall**: `nmem_recall("CBDC pilots châu Á 2025-2026")` → nhớ lại research cũ

## WebSearch / Tavily (Primary)

- Research chuyên sâu: tìm nguồn chính thống, báo cáo mới, tin tức ngành
- So sánh quốc tế: tìm case study từ nhiều nước
- Verify thông tin: cross-check tin từ nhiều nguồn
