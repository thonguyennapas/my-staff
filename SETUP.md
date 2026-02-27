# Setup trên VPS

---

## PHẦN 1: Cài mới hoàn toàn

> Chỉ cần làm **1 lần** khi setup VPS mới.

### 1.1 Prerequisites

```bash
# Kiểm tra Node.js (cần v22+)
node --version

# Nếu chưa có, cài Node.js
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Nếu cần NeuralMemory — cài Python 3.11+
python3 --version
sudo apt-get install -y python3 python3-pip
```

### 1.2 Cài OpenClaw

```bash
npm install -g openclaw@latest
```

> ⚠️ **KHÔNG CẦN** chạy `openclaw onboard` — vì repo này đã có `openclaw.json` sẵn.
> Wizard onboard chỉ dành cho ai chưa có config.

### 1.3 Clone repo

```bash
git clone https://github.com/thonguyennapas/my-staff.git
cd my-staff
```

### 1.4 Tạo file .env

```bash
cp .env.example .env
nano .env
```

Điền đầy đủ:

| Variable | Nguồn |
|----------|-------|
| `STAFF_HOME` | Đường dẫn tuyệt đối (VD: `/root/my-staff`) |
| `TELEGRAM_TIEU_MY_TOKEN` | BotFather → `@Tho_TieuMyBot` |
| `TELEGRAM_INSIGHT_TOKEN` | BotFather → `@Tho_MrInsightBot` |
| `TELEGRAM_LOGIC_TOKEN` | BotFather → `@Tho_MrLogicBot` |
| `TELEGRAM_STRATEGY_TOKEN` | BotFather → `@Tho_MrStrategyBot` |
| `TELEGRAM_OWNER_ID` | Gửi `/start` cho `@userinfobot` |
| `GOOGLE_API_KEY` | [Google AI Studio](https://aistudio.google.com/apikey) |

### 1.5 Copy config vào OpenClaw

```bash
# Tạo thư mục OpenClaw (nếu chưa có)
mkdir -p ~/.openclaw

# Backup config cũ (nếu có)
[ -f ~/.openclaw/openclaw.json ] && cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak

# Copy config + env
cp openclaw.json ~/.openclaw/openclaw.json
cp .env ~/.openclaw/.env
```

> **Ghi chú**: OpenClaw hỗ trợ [hot reload](https://docs.openclaw.ai/gateway/configuration#config-hot-reload) — khi bạn sửa `~/.openclaw/openclaw.json`, Gateway tự reload config mà không cần restart.

### 1.6 Khởi động Gateway

```bash
# Cách 1: Foreground (để xem logs debug)
openclaw gateway

# Cách 2: Daemon (khuyến nghị — tự chạy khi VPS reboot)
openclaw gateway install-daemon

# Cách 3: pm2 (alternative)
npm install -g pm2
pm2 start "openclaw gateway" --name openclaw
pm2 save && pm2 startup
```

### 1.7 Pairing Telegram (4 bots)

```bash
# Mở Telegram → gửi /start cho từng bot:
# 1. @Tho_TieuMyBot → /start
# 2. @Tho_MrInsightBot → /start
# 3. @Tho_MrLogicBot → /start
# 4. @Tho_MrStrategyBot → /start

# Approve pairing cho từng bot
openclaw pairing list telegram
openclaw pairing approve telegram <CODE_1>
openclaw pairing approve telegram <CODE_2>
openclaw pairing approve telegram <CODE_3>
openclaw pairing approve telegram <CODE_4>
```

### 1.8 Tạo Cron Job (điểm tin hàng tuần)

```bash
openclaw cron add \
  --name "Điểm tin thị trường hàng tuần" \
  --cron "0 8 * * 4" \
  --tz "Asia/Ho_Chi_Minh" \
  --session isolated \
  --agent thu-ky-tieu-my \
  --message "Bắt đầu quy trình 'Điểm tin thị trường hàng tuần':

1. Chốt scope tuần này (ưu tiên: công nghệ thanh toán, Visa/Mastercard, CBDC, blockchain, agentic commerce, VN fintech)
2. Phân công Mr. Insight gom tin + signals + link
3. Phân công Mr. Logic validate + confidence + risks + falsifiers
4. Phân công Mr. Strategy kết luận + forecast + đề xuất
5. Đóng gói thành 01 bản gửi sếp với đủ 4 phần:
   - (1) Điểm tin có link (10-20 tin)
   - (2) Kết luận tuần (3 kết luận chính)
   - (3) Dự đoán/xu hướng (nếu có)
   - (4) Đề xuất (nếu cần)

Nếu chưa đủ bằng chứng để dự đoán, ghi rõ: chưa đủ bằng chứng, tuần sau cần theo dõi gì." \
  --announce \
  --channel telegram \
  --to "${TELEGRAM_OWNER_ID}"
```

### 1.9 Verify

```bash
# Chạy doctor — kiểm tra toàn bộ config, channels, DM policies
openclaw doctor

# Kiểm tra status
openclaw status

# Kiểm tra cron jobs
openclaw cron list

# Test: gửi tin nhắn cho @Tho_TieuMyBot trên Telegram → Agent phản hồi
```

---

## PHẦN 2: Cập nhật

### 2.1 Update OpenClaw

```bash
npm update -g openclaw@latest
openclaw doctor  # kiểm tra migrations
```

### 2.2 Update my-staff (khi chỉnh sửa agent)

```bash
# === Trên máy local (Windows) ===
cd my-staff
git add -A
git commit -m "update: chỉnh sửa agent XYZ"
git push origin main

# === Trên VPS ===
cd my-staff
git pull origin main
cp openclaw.json ~/.openclaw/openclaw.json
# Gateway tự hot-reload config
```

### 2.3 Quản lý cron job

```bash
openclaw cron list                    # Xem danh sách
openclaw cron run <job-id>            # Chạy thủ công để test
openclaw cron runs --id <job-id>      # Xem lịch sử chạy
```

---

## Sử dụng

| Kênh | Cách dùng |
|------|-----------|
| `@Tho_TieuMyBot` | Giao việc cho Thư ký → tự điều phối team |
| `@Tho_MrInsightBot` | Hỏi trực tiếp Mr. Insight về research/signals |
| `@Tho_MrLogicBot` | Hỏi trực tiếp Mr. Logic về validation/risk |
| `@Tho_MrStrategyBot` | Hỏi trực tiếp Mr. Strategy về kết luận/forecast |
| Cron (tự động) | Mỗi thứ 5, 8AM (giờ VN) → Thư ký tự chạy |

### Chat commands (trong Telegram)

| Command | Mô tả |
|---------|-------|
| `/status` | Xem session status (model + tokens) |
| `/new` hoặc `/reset` | Reset session |
| `/compact` | Compact session context |

---

## Kiến trúc multi-agent

```
channels.telegram.accounts:
  default (Tiểu My)  ──binding──► agent: thu-ky-tieu-my
  insight             ──binding──► agent: mr-insight
  logic               ──binding──► agent: mr-logic
  strategy            ──binding──► agent: mr-strategy

Inter-agent communication:
  Thư ký ──sessions_send──► Mr. Insight / Mr. Logic / Mr. Strategy
```

Mỗi agent có workspace riêng (`IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `USER.md`, `TOOLS.md`) và session độc lập.
