# Tools — Mr. Logic

## Web Search (Secondary — cho verify)

### Tools

| Tool | Mục đích | Khi nào dùng |
|------|----------|-------------|
| `web_search` | Cross-check tin từ nhiều nguồn (Tavily API) | **LUÔN dùng đầu tiên** |
| `web_fetch` | Đọc chi tiết trang nguồn cụ thể | Khi cần verify sâu 1 link |
| `browser_navigate` | Mở trang qua browser thật | **Fallback** khi `web_fetch` bị chặn (403/Cloudflare) |

### ⚠️ Xử lý khi web_fetch bị chặn

1. Thử `browser_navigate` 1 lần
2. Fail → `web_search` tìm nguồn khác ngay, không retry quá 2 lần

### Lưu ý

- Chỉ dùng để **verify** — research sâu là việc của Mr. Insight
- Khi cross-check: tìm tối thiểu 2 nguồn độc lập
- Ghi rõ: nguồn nào confirm, nguồn nào mâu thuẫn

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Validation results...")` |
| Trả lời yêu cầu bổ sung | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung confidence...")` |

## NeuralMemory — Bộ nhớ dài hạn

> Brain chung `my-staff` — mọi agent đều recall được memories bạn lưu.

### Khi nào `nmem_recall` (TRƯỚC validation):

| Thời điểm | Ví dụ |
|-----------|-------|
| Nhận data từ Insight → trước khi validate | `nmem_recall("risk assessment CBDC")` → xem risk cũ còn đúng không |
| Claim quen thuộc | `nmem_recall("Visa tokenization confidence")` → dùng data cũ bổ trợ |

### Khi nào `nmem_remember` (SAU validation):

| Thời điểm | Ví dụ | Type |
|-----------|-------|------|
| Risk quan trọng phát hiện | `nmem_remember("Risk: digital yuan cross-border pilot chưa có interop standard → rủi ro fragmentation", type="fact", priority=8)` | `fact` |
| Falsifier quan trọng | `nmem_remember("Falsifier: nếu Fed ra CBDC whitepaper Q3/2026 → thay đổi hoàn toàn dự đoán", type="insight", priority=7)` | `insight` |
| Confidence thay đổi lớn | `nmem_remember("Confidence CBDC adoption: từ Medium→High sau BIS report March 2026", type="fact", priority=7)` | `fact` |
