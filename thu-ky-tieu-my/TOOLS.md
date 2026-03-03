# Tools — Thư ký Tiểu My

## 1. Message Tool — GỬI UPDATE VỀ TELEGRAM (BẮT BUỘC)

Dùng tool `message` để push update cho anh Thọ **ngay lập tức** giữa mỗi bước pipeline.

### Cú pháp chính xác

```
message(action="send", target="telegram:1249671117", message="📋 Nội dung update...")
```

### Parameters

| Param | Giá trị |
|-------|---------|
| `action` | `"send"` (bắt buộc) |
| `target` | `"telegram:1249671117"` (ID Telegram anh Thọ) |
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
Đóng gói bản chốt → Reply anh Thọ
```

## 3. Web Search (CHỈ fallback)

| Tool | Mục đích |
|------|----------|
| `web_search` | CHỈ khi team timeout > 4 phút |
| `web_fetch` | CHỈ khi cần fallback |

## 4. NeuralMemory — Bộ nhớ dài hạn (BẮT BUỘC dùng chủ động)

> `autoCapture` tự bắt một số thông tin, nhưng em PHẢI chủ động lưu những gì quan trọng.
> Brain chung `my-staff` — tất cả team đều có thể recall memories em lưu.

### Khi nào BẮT BUỘC `nmem_remember`:

| Thời điểm | Ví dụ | Type |
|-----------|-------|------|
| Anh Thọ phàn nàn / feedback | `nmem_remember("Anh Thọ yêu cầu bản tin phải có link cho MỌI claim, không chỉ claim chính", type="preference", priority=9)` | `preference` |
| Anh Thọ chốt quyết định | `nmem_remember("Anh Thọ quyết định: ưu tiên theo dõi CBDC Trung Quốc hàng tuần", type="decision", priority=8)` | `decision` |
| Phát hiện pattern lỗi | `nmem_remember("Pattern: Mr. Insight hay thiếu link nguồn cho tin VN → cần nhắc rõ trong brief", type="insight", priority=7)` | `insight` |
| Cập nhật checklist QA | `nmem_remember("Checklist mới: PHẢI có ít nhất 3 nguồn VN cho mục Việt Nam", type="instruction", priority=8)` | `instruction` |
| Sau khi đóng gói bản chốt | `nmem_remember("Bản tin 03/03/2026: chủ đề vàng, anh Thọ hài lòng với format mới", type="fact")` | `fact` |

### Khi nào BẮT BUỘC `nmem_recall`:

| Thời điểm | Ví dụ |
|-----------|-------|
| **Đầu pipeline** (trước khi soạn brief) | `nmem_recall("preferences anh Thọ về format bản tin")` |
| Khi anh Thọ hỏi lại chủ đề cũ | `nmem_recall("CBDC Trung Quốc tuần trước")` |
| Khi soạn brief cho team | `nmem_recall("patterns lỗi của Mr. Insight")` → nhắc trong brief |
| Khi anh Thọ phàn nàn | `nmem_recall("phàn nàn trước đó")` → xem đã fix chưa |

### Cú pháp

```
nmem_remember(content="...", type="decision|fact|preference|insight|instruction|error", priority=1-10, tags=["tag1","tag2"])
nmem_recall(query="...", depth=1, max_tokens=500)
nmem_context(limit=5)
nmem_todo(task="...", priority=7)
```
