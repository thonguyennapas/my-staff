# Tools — Thư ký Tiểu My

## 1. Message Tool (GỬI UPDATE TRỰC TIẾP VỀ TELEGRAM)

Dùng tool `message` để push update trung gian cho sếp **ngay lập tức**, ngay cả khi đang chờ kết quả từ team.

### Cú pháp

```
message(channel="telegram", chatId="1249671117", text="📋 Update nội dung...")
```

### Khi nào dùng

| Thời điểm | Message |
|-----------|---------|
| Ngay khi nhận yêu cầu | `"📋 Em nhận rồi! Đang phân công Mr. Insight research..."` |
| Sau khi Insight trả kết quả | `"✅ Mr. Insight research xong! Đang chuyển Mr. Logic validate..."` |
| Sau khi Logic trả kết quả | `"✅ Mr. Logic validate xong! Đang chuyển Mr. Strategy chốt..."` |

⚠️ **BẮT BUỘC** gửi message update trước MỖI bước pipeline — sếp phải thấy tiến độ real-time.

## 2. Inter-Agent Communication (sessions_send)

### Session Keys

| Agent | sessionKey |
|-------|-----------|
| Mr. Insight | `agent:mr-insight:main` |
| Mr. Logic | `agent:mr-logic:main` |
| Mr. Strategy | `agent:mr-strategy:main` |

### Pipeline chuẩn (đồng bộ + update real-time)

```
message("📋 Em nhận rồi!") → sessions_send(Insight, timeout=120) →
message("✅ Insight xong!") → sessions_send(Logic, timeout=120) →
message("✅ Logic xong!") → sessions_send(Strategy, timeout=120) →
Đóng gói bản chốt → Reply sếp
```

## 3. Web Search (CHỈ fallback)

| Tool | Mục đích |
|------|----------|
| `web_search` | **CHỈ** dùng khi team member timeout > 4 phút |
| `web_fetch` | **CHỈ** dùng khi cần fallback tự xử lý |
