# Tools — Mr. Insight

## Web Research (Primary — cho research)

### ⚠️ Giới hạn tài nguyên (BẮT BUỘC)

| Giới hạn | Số lượng tối đa |
|----------|----------------|
| `web_search` | **5 lần** mỗi pipeline run |
| `web_fetch` | **3 lần** — chỉ cho bài quan trọng nhất |
| `browser_navigate` | **1 lần** — CHỈ dùng fallback khi `web_fetch` bị Cloudflare chặn |

> **Lưu ý**: `web_search` (Tavily) đã trả sẵn tóm tắt 5-10 kết quả mỗi lần → 5 lần = 25-50 nguồn tin. Chỉ `web_fetch` khi thật sự cần đọc full bài.

### Quy trình research chuẩn

```
Bước 1: web_search("từ khóa") → lấy danh sách links + tóm tắt
Bước 2: Đọc tóm tắt từ web_search — phần lớn trường hợp ĐỦ DÙNG
Bước 3: Chỉ web_fetch bài nào CẦN đọc sâu (tối đa 3 bài)
```

### Tools

| Tool | Mục đích | Khi nào dùng |
|------|----------|-------------|
| `web_search` | Tìm nguồn, tin tức, báo cáo (Tavily API) | **LUÔN dùng đầu tiên** — trả tóm tắt sẵn |
| `web_fetch` | Đọc full nội dung 1 trang web | **Chỉ khi** tóm tắt từ web_search chưa đủ (tối đa 3 lần) |

### ⚠️ Xử lý khi web_fetch bị chặn

Khi `web_fetch` trả lỗi 403, "Just a moment", hoặc nội dung trống:

1. **Nếu bài đó RẤT quan trọng** → thử `browser_navigate` 1 lần (chỉ được dùng 1 lần duy nhất!)
2. **Nếu không quá quan trọng** → bỏ qua, dùng tóm tắt từ `web_search` thay thế
3. **Không retry** cùng 1 link — tránh trễ pipeline

### Lưu ý quan trọng

- **LUÔN** bắt đầu bằng `web_search` → đọc tóm tắt trước → chỉ `web_fetch` bài quan trọng nhất
- **Ưu tiên dùng tóm tắt** từ `web_search` — tiết kiệm thời gian, tránh timeout
- Ghi rõ **nguồn + ngày + tổ chức** cho mọi thông tin
- Cross-check tối thiểu **2 nguồn** cho claim quan trọng

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đây là research tuần này...")` |
| Trả lời yêu cầu sửa | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung 3 signals...")` |
