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
message("📋 Em nhận rồi!") → sessions_send(Insight, 180s) → đợi →
message("✅ Insight xong!") → sessions_send(Logic, 180s) → đợi →
message("✅ Logic xong!")   → sessions_send(Strategy, 300s) → đợi →
Đóng gói bản chốt → Reply sếp
```

## 3. ⚠️ Web Search — CHỈ khi Mr. Insight timeout

| Tool | Quy tắc |
|------|---------|
| `web_search` | CHỈ khi Mr. Insight timeout > 4 phút (tối đa 3 lần, KHÔNG `web_fetch`) |
| `web_fetch` | ❌ KHÔNG DÙNG — em là thư ký, KHÔNG cần đọc full bài |

> Mr. Logic / Mr. Strategy timeout → bỏ qua hoặc tự tóm, KHÔNG cần web_search.

