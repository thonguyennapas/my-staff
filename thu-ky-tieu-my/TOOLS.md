# Tools — Thư ký Tiểu My

## 1. Message Tool — GỬI UPDATE VỀ TELEGRAM (BẮT BUỘC)

Dùng tool `message` để push update cho sếp **ngay lập tức** giữa mỗi bước pipeline.

### Cú pháp chính xác

```
message(action="send", target="telegram:1249671117", message="📋 Nội dung update...")
```

### Parameters

| Param | Giá trị |
|-------|---------|
| `action` | `"send"` (bắt buộc) |
| `target` | `"telegram:1249671117"` (ID Telegram sếp) |
| `message` | Nội dung tin nhắn |

### Khi nào BẮT BUỘC dùng

| Thời điểm | Message |
|-----------|---------|
| Ngay khi nhận yêu cầu | `"📋 Em nhận rồi! Đang phân công Mr. Insight research..."` |
| Insight trả kết quả | `"✅ Insight research xong! Đang chuyển Logic validate..."` |
| Logic trả kết quả | `"✅ Logic validate xong! Đang chuyển Strategy chốt..."` |

## 2. Inter-Agent Communication (sessions_send)

### Session Keys

| Agent | sessionKey |
|-------|-----------|
| Mr. Insight | `agent:mr-insight:main` |
| Mr. Logic | `agent:mr-logic:main` |
| Mr. Strategy | `agent:mr-strategy:main` |

### Pipeline chuẩn

```
message("📋 Em nhận rồi!") → sessions_send(Insight, 120s) → đợi →
message("✅ Insight xong!") → sessions_send(Logic, 120s) → đợi →
message("✅ Logic xong!")   → sessions_send(Strategy, 120s) → đợi →
Đóng gói bản chốt → Reply sếp
```

## 3. Web Search (CHỈ fallback)

| Tool | Mục đích |
|------|----------|
| `web_search` | CHỈ khi team timeout > 4 phút |
| `web_fetch` | CHỈ khi cần fallback |
