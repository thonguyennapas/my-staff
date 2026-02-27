# Setup trên VPS

## Prerequisites

- **Node.js** v22+ (hoặc v24+)
- **Python** 3.11+ (cho NeuralMemory)
- **npm** (đi kèm Node.js)

## Bước 1: Cài OpenClaw + NeuralMemory

```bash
# Cài OpenClaw
npm install -g @anthropic-ai/openclaw

# Cài NeuralMemory
pip install neural-memory
npm install -g @neuralmemory/openclaw-plugin
```

## Bước 2: Clone repo

```bash
git clone https://github.com/thonguyennapas/my-staff.git
cd my-staff
```

## Bước 3: Cấu hình environment

```bash
# Copy template
cp .env.example .env

# Sửa .env — điền tokens thật
nano .env
```

Cần điền:
- `TELEGRAM_TIEU_MY_TOKEN` — token từ @BotFather cho `@Tho_TieuMyBot`
- `TELEGRAM_INSIGHT_TOKEN` — token cho `@Tho_MrInsightBot`
- `TELEGRAM_LOGIC_TOKEN` — token cho `@Tho_MrLogicBot`
- `TELEGRAM_STRATEGY_TOKEN` — token cho `@Tho_MrStrategyBot`
- `TELEGRAM_OWNER_ID` — Telegram User ID của bạn (gửi `/start` cho `@userinfobot` để lấy)
- `ANTHROPIC_API_KEY` — API key Claude

## Bước 4: Load environment

```bash
# Load .env vào shell
export $(cat .env | xargs)
```

## Bước 5: Setup OpenClaw workspace

```bash
# Copy config vào OpenClaw home
cp openclaw.json ~/.openclaw/openclaw.json

# Đăng ký 4 agents
openclaw agents add thu-ky-tieu-my --workspace ./thu-ky-tieu-my
openclaw agents add mr-insight --workspace ./mr-insight
openclaw agents add mr-logic --workspace ./mr-logic
openclaw agents add mr-strategy --workspace ./mr-strategy
```

## Bước 6: Khởi động Gateway

```bash
# Chạy OpenClaw Gateway (background)
openclaw gateway &

# Hoặc dùng systemd/pm2 để chạy daemon
pm2 start "openclaw gateway" --name openclaw
```

## Bước 7: Pairing Telegram

Sau khi Gateway chạy:
1. Mở Telegram → tìm `@Tho_TieuMyBot` → gửi `/start`
2. OpenClaw trả về **pairing code** → approve trong terminal
3. Lặp lại cho 3 bot còn lại
4. Done! Bạn có thể chat với từng agent qua Telegram

## Bước 8: Thiết lập Cron (nếu chưa tự load từ openclaw.json)

```bash
# Thêm cron job: điểm tin hàng tuần, thứ 5, 8AM
openclaw cron add \
  --cron "0 8 * * 4" \
  --agent thu-ky-tieu-my \
  --isolated \
  --prompt "Bắt đầu quy trình Điểm tin thị trường hàng tuần..."
```

## Verify

```bash
# Kiểm tra agents đã đăng ký
openclaw agents list

# Kiểm tra cron jobs
openclaw cron list

# Kiểm tra Telegram đã kết nối
openclaw channels status
```

## Sử dụng

| Kênh | Cách dùng |
|------|-----------|
| Chat `@Tho_TieuMyBot` | Giao việc cho Thư ký → Thư ký tự điều phối team |
| Chat `@Tho_MrInsightBot` | Hỏi trực tiếp Mr. Insight về research/signals |
| Chat `@Tho_MrLogicBot` | Hỏi trực tiếp Mr. Logic về validation/risk |
| Chat `@Tho_MrStrategyBot` | Hỏi trực tiếp Mr. Strategy về kết luận/forecast |
| Cron (tự động) | Mỗi thứ 5, 8AM → Thư ký tự chạy quy trình → gửi kết quả qua Telegram |
