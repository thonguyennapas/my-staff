# Tools — Mr. Insight

## Web Research (Primary — cho research)

### Quy trình research chuẩn

```
Bước 1: web_search("từ khóa") → lấy danh sách links + tóm tắt
Bước 2: Chọn links quan trọng nhất
Bước 3: web_fetch(url) → đọc chi tiết
        ├── Thành công → lấy nội dung
        └── Lỗi 403/Cloudflare → Fallback (xem bên dưới)
```

### Tools

| Tool | Mục đích | Khi nào dùng |
|------|----------|-------------|
| `web_search` | Tìm nguồn, tin tức, báo cáo (Tavily API) | **LUÔN dùng đầu tiên** — không bị Cloudflare chặn |
| `web_fetch` | Đọc full nội dung 1 trang web | Sau khi có link từ `web_search` |
| `browser_navigate` | Mở trang web qua browser thật | **Fallback** khi `web_fetch` bị chặn (403/Cloudflare) |

### ⚠️ Xử lý khi web_fetch bị chặn

Khi `web_fetch` trả lỗi 403, "Just a moment", hoặc nội dung trống:

1. **Thử `browser_navigate`** 1 lần — nếu được thì lấy nội dung
2. **Nếu cũng fail → bỏ qua link đó ngay**, dùng `web_search` tìm nguồn thay thế
3. **Không retry quá 2 lần** trên cùng 1 link — tránh trễ pipeline
4. Nội dung tóm tắt từ `web_search` nhiều khi đủ dùng mà không cần đọc full page

### Lưu ý quan trọng

- **LUÔN** bắt đầu bằng `web_search` → lấy nhiều links → rồi mới `web_fetch` từng link
- **web_search (Tavily)** trả nội dung tóm tắt sẵn → nhiều khi đủ dùng mà không cần `web_fetch`
- Ghi rõ **nguồn + ngày + tổ chức** cho mọi thông tin
- Cross-check tối thiểu **2 nguồn** cho claim quan trọng
- Nếu 1 nguồn bị chặn → **bắt buộc tìm nguồn thay thế**, KHÔNG bỏ qua

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đây là research tuần này...")` |
| Trả lời yêu cầu sửa | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung 3 signals...")` |

## NeuralMemory — Bộ nhớ dài hạn

> Brain chung `my-staff` — mọi agent đều recall được memories bạn lưu.

### Khi nào `nmem_recall` (TRƯỚC KHI research):

| Thời điểm | Ví dụ |
|-----------|-------|
| Nhận brief → trước khi search | `nmem_recall("CBDC Trung Quốc")` → xem tuần trước đã research gì |
| Chủ đề quen thuộc | `nmem_recall("Visa payment trends")` → tránh research trùng |

### Khi nào `nmem_remember` (SAU KHI research):

| Thời điểm | Ví dụ | Type |
|-----------|-------|------|
| Phát hiện signal quan trọng | `nmem_remember("Signal: BOI thí điểm digital shekel phase 2 từ Q2/2026", type="fact", priority=8)` | `fact` |
| Nguồn tốt cho future reference | `nmem_remember("Nguồn uy tín CBDC: https://cbdctracker.org — cập nhật monthly", type="reference", priority=6)` | `reference` |
| Insight từ research | `nmem_remember("Xu hướng: các nước ASEAN đang pilot cross-border CBDC bridge", type="insight", priority=7)` | `insight` |
