# Tools — Mr. Logic

## Web Search (Secondary — cho verify)

### ⚡ QUY TẮC TỐC ĐỘ

> **Verify nhanh = pipeline nhanh.** Dùng `web_search` để cross-check.
> `web_fetch` chỉ khi THẬT SỰ cần — tối đa 1 URL. Lỗi → bỏ qua ngay.

### Tools

| Tool | Mục đích | Khi nào dùng |
|------|----------|-------------|
| `web_search` | Cross-check tin từ nhiều nguồn (Tavily API) | **LUÔN dùng — nguồn chính để verify** |
| `web_fetch` | Đọc chi tiết trang nguồn cụ thể | **Tối đa 1 URL** — chỉ khi search chưa đủ |
| `browser_navigate` | Mở trang qua browser thật | **KHÔNG dùng** — quá chậm cho verify |

### ⚠️ Quy tắc verify nhanh

1. `web_search` trả sẵn tóm tắt — **đủ để cross-check** trong hầu hết trường hợp
2. `web_fetch` bị 404/403 → **BỎ QUA NGAY** — không retry
3. Mục tiêu: **validate xong trong 30-45 giây**

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Validation results...")` |
| Trả lời yêu cầu bổ sung | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung confidence...")` |
