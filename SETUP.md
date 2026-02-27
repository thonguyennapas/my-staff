# Setup trên VPS

---

## PHẦN 1: Cài mới hoàn toàn

> Chỉ cần làm **1 lần** khi setup VPS mới.

### 1.1 Prerequisites

```bash
# Kiểm tra Node.js (cần v22+)
node --version

# Kiểm tra Python (cần 3.11+)
python3 --version

# Nếu chưa có, cài Node.js
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Nếu chưa có Python 3.11+
sudo apt-get install -y python3 python3-pip
```

### 1.2 Cài OpenClaw + NeuralMemory

```bash
# Cài OpenClaw
npm install -g @anthropic-ai/openclaw

# Cài NeuralMemory
pip install neural-memory
npm install -g @neuralmemory/openclaw-plugin
```

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
| `TELEGRAM_TIEU_MY_TOKEN` | BotFather → `@Tho_TieuMyBot` |
| `TELEGRAM_INSIGHT_TOKEN` | BotFather → `@Tho_MrInsightBot` |
| `TELEGRAM_LOGIC_TOKEN` | BotFather → `@Tho_MrLogicBot` |
| `TELEGRAM_STRATEGY_TOKEN` | BotFather → `@Tho_MrStrategyBot` |
| `TELEGRAM_OWNER_ID` | Gửi `/start` cho `@userinfobot` |
| `TAVILY_API_KEY` | [tavily.com](https://tavily.com) |
| `GOOGLE_API_KEY` | [Google AI Studio](https://aistudio.google.com/apikey) |
| `STAFF_HOME` | Đường dẫn tuyệt đối tới thư mục my-staff (VD: `/root/my-staff`) |

### 1.5 Load environment + Setup OpenClaw

```bash
# Load .env
export $(cat .env | xargs)

# Khởi tạo OpenClaw (tạo ~/.openclaw/ nếu chưa có)
openclaw setup

# ⚠️ Backup config cũ trước khi copy (nếu đã có từ project khác)
[ -f ~/.openclaw/openclaw.json ] && cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak

# Copy config vào OpenClaw home
cp openclaw.json ~/.openclaw/openclaw.json

# Đăng ký 4 agents
openclaw agents add thu-ky-tieu-my --workspace ./thu-ky-tieu-my
openclaw agents add mr-insight --workspace ./mr-insight
openclaw agents add mr-logic --workspace ./mr-logic
openclaw agents add mr-strategy --workspace ./mr-strategy
```

### 1.6 Khởi động Gateway

```bash
# Chạy OpenClaw Gateway (chọn 1 trong 2 cách)

# Cách 1: Chạy foreground (để debug)
openclaw gateway

# Cách 2: Chạy background với pm2 (khuyến nghị cho production)
npm install -g pm2
pm2 start "openclaw gateway" --name openclaw
pm2 save
pm2 startup  # tự chạy lại khi VPS restart
```

### 1.7 Pairing Telegram

```bash
# Mở Telegram → tìm từng bot → gửi /start
# OpenClaw Gateway sẽ log pairing code → approve trong terminal

# Thứ tự pair:
# 1. @Tho_TieuMyBot → /start → approve
# 2. @Tho_MrInsightBot → /start → approve
# 3. @Tho_MrLogicBot → /start → approve
# 4. @Tho_MrStrategyBot → /start → approve
```

### 1.8 Verify

```bash
# Kiểm tra agents
openclaw agents list

# Kiểm tra cron jobs
openclaw cron list

# Kiểm tra Telegram channels
openclaw channels status

# Test: gửi tin nhắn cho @Tho_TieuMyBot trên Telegram
# → Agent nên phản hồi
```

---

## PHẦN 2: Cập nhật

> Dùng mỗi khi cần update OpenClaw hoặc chỉnh sửa nhân viên.

### 2.1 Update OpenClaw (khi có phiên bản mới)

```bash
# Dừng Gateway trước
pm2 stop openclaw

# Update OpenClaw
npm update -g @anthropic-ai/openclaw

# Update NeuralMemory (nếu cần)
pip install --upgrade neural-memory
npm update -g @neuralmemory/openclaw-plugin

# Khởi động lại
pm2 start openclaw
```

### 2.2 Update code my-staff (khi chỉnh sửa nhân viên)

Sau khi bạn chỉnh sửa agent files trên local → push lên GitHub:

```bash
# === Trên máy local (Windows) ===
cd my-staff
git add -A
git commit -m "update: chỉnh sửa agent XYZ"
git push origin main
```

```bash
# === Trên VPS ===
cd my-staff

# Pull code mới
git pull origin main

# Copy config mới (nếu openclaw.json thay đổi)
cp openclaw.json ~/.openclaw/openclaw.json

# Restart Gateway để load config mới
pm2 restart openclaw
```

### 2.3 Thêm/sửa cron job

```bash
# Xem danh sách cron hiện tại
openclaw cron list

# Sửa cron (VD: đổi giờ chạy)
openclaw cron edit weekly-market-digest --cron "0 9 * * 4"

# Thêm cron mới
openclaw cron add \
  --cron "0 8 * * 1" \
  --agent thu-ky-tieu-my \
  --isolated \
  --prompt "Bản tổng hợp đầu tuần..."
```

### 2.4 Thêm agent mới

```bash
# 1. Tạo folder workspace mới trên local
mkdir new-agent
# Tạo 5 files: IDENTITY.md, SOUL.md, AGENTS.md, USER.md, TOOLS.md

# 2. Push lên GitHub
git add -A && git commit -m "feat: add new agent" && git push

# 3. Trên VPS
git pull origin main
openclaw agents add new-agent --workspace ./new-agent

# 4. Nếu cần Telegram bot → tạo bot mới trên BotFather → thêm token vào .env + openclaw.json
```

---

## Sử dụng

| Kênh | Cách dùng |
|------|-----------|
| Chat `@Tho_TieuMyBot` | Giao việc cho Thư ký → Thư ký tự điều phối team |
| Chat `@Tho_MrInsightBot` | Hỏi trực tiếp Mr. Insight về research/signals |
| Chat `@Tho_MrLogicBot` | Hỏi trực tiếp Mr. Logic về validation/risk |
| Chat `@Tho_MrStrategyBot` | Hỏi trực tiếp Mr. Strategy về kết luận/forecast |
| Cron (tự động) | Mỗi thứ 5, 8AM → Thư ký tự chạy → gửi kết quả qua Telegram |
