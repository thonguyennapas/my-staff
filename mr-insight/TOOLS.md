# Tools — Mr. Insight

## Web Research (Primary — cho research)

### ⚡ QUY TẮC TỐC ĐỘ — ĐỌC TRƯỚC KHI LÀM

> **Pipeline có giới hạn thời gian. Mỗi giây đều quan trọng.**
> Ưu tiên TỐC ĐỘ — dùng `web_search` summaries làm nguồn chính.
> `web_fetch` chỉ dùng khi THẬT SỰ cần chi tiết mà summary không đủ.

### Quy trình research chuẩn

```
Bước 1: web_search("từ khóa") → lấy danh sách links + TÓM TẮT SẴN
Bước 2: Dùng tóm tắt từ web_search làm NỘI DUNG CHÍNH (đủ 80% trường hợp)
Bước 3: CHỈ web_fetch tối đa 2 URL quan trọng nhất (nếu cần thêm chi tiết)
        ├── Thành công → bổ sung nội dung
        └── Lỗi 404/403 → BỎ QUA NGAY, dùng tóm tắt từ Bước 1
```

### Tools

| Tool | Mục đích | Khi nào dùng |
|------|----------|-------------|
| `web_search` | Tìm nguồn + lấy tóm tắt sẵn (Tavily API) | **LUÔN dùng — đây là nguồn chính** |
| `web_fetch` | Đọc full nội dung 1 trang web | **CHỈ khi tóm tắt chưa đủ** — tối đa 2 URL |
| `browser_navigate` | Mở trang qua browser thật | **KHÔNG dùng** trừ khi Thư ký yêu cầu cụ thể |

### ⚠️ Quy tắc tốc độ (BẮT BUỘC)

1. **`web_search` là đủ cho 80% trường hợp** — Tavily trả sẵn tóm tắt + link nguồn
2. **Tối đa 2 lần `web_fetch`** cho toàn bộ 1 research task — không nhiều hơn
3. **`web_fetch` bị lỗi (404/403/Cloudflare) → BỎ QUA NGAY** — không retry, không `browser_navigate`
4. **Không bao giờ fetch quá 3 URLs** trong 1 session — pipeline sẽ bị trễ
5. **Tổng thời gian research: mục tiêu < 60 giây** — nếu quá 60s, gửi ngay những gì đã có

### Lưu ý quan trọng

- Ghi rõ **nguồn + ngày + tổ chức** cho mọi thông tin (lấy từ `web_search` results)
- Cross-check tối thiểu **2 nguồn** cho claim quan trọng (qua nhiều `web_search` queries)
- **Link nguồn**: lấy URL từ `web_search` results — KHÔNG cần fetch để verify link

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi output cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đây là research tuần này...")` |
| Trả lời yêu cầu sửa | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã bổ sung 3 signals...")` |
