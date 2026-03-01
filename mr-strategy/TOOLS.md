# Tools — Mr. Strategy

## Lưu ý

- Mr. Strategy **không dùng web_search/web_fetch** — research sâu là việc của Mr. Insight
- Nếu cần data thêm → `sessions_send` yêu cầu Thư ký phân công Mr. Insight/Logic bổ sung

## Inter-Agent Communication (sessions_send)

| Hành động | Cách dùng |
|-----------|-----------|
| Gửi kết luận cho Thư ký | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Kết luận + forecast tuần...")` |
| Yêu cầu thêm data | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Cần thêm data về X để chốt...")` |
| Trả lời yêu cầu sửa | `sessions_send(sessionKey="agent:thu-ky-tieu-my:main", message="Đã sửa recommendation...")` |
