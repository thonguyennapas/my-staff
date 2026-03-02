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

# Python 3.11+ (cho Mem0 OSS)
python3 --version
sudo apt-get install -y python3 python3-pip
```

### 1.2 Cài OpenClaw

```bash
npm install -g openclaw@latest
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
| `STAFF_HOME` | Đường dẫn tuyệt đối (VD: `/root/my-staff`) |
| `TELEGRAM_TIEU_MY_TOKEN` | BotFather → `@Tho_TieuMyBot` |
| `TELEGRAM_INSIGHT_TOKEN` | BotFather → `@Tho_MrInsightBot` |
| `TELEGRAM_LOGIC_TOKEN` | BotFather → `@Tho_MrLogicBot` |
| `TELEGRAM_STRATEGY_TOKEN` | BotFather → `@Tho_MrStrategyBot` |
| `TELEGRAM_OWNER_ID` | Gửi `/start` cho `@userinfobot` |

**Xác thực Google — chọn 1 trong 2 phương thức:**

| Phương thức | Variables | Nguồn |
|-------------|-----------|-------|
| **AI Studio API Key** (miễn phí) | `GOOGLE_API_KEY` | [Google AI Studio](https://aistudio.google.com/apikey) |
| | `GOOGLE_API_KEY_*` (tùy chọn) | Tạo key riêng cho từng agent để tránh rate limit |
| **Vertex AI JSON** (paid, quota cao) | `GOOGLE_APPLICATION_CREDENTIALS` | Đường dẫn tới file JSON service account |
| | `GOOGLE_CLOUD_PROJECT` | Project ID trên Google Cloud |
| | `GOOGLE_CLOUD_LOCATION` | Region (VD: `us-central1`, `asia-southeast1`) |

> 💡 **Có thể dùng cả 2 cùng lúc** — chọn phương thức theo model prefix:
> - `google/gemini-xxx` → dùng API Key
> - `google-vertex/gemini-xxx` → dùng Vertex AI
>
> ⚠️ Vertex AI: cần bật API, billing, và role `Vertex AI User` cho service account.
> File JSON đặt trong folder `vertex-ai/` (đã gitignore).

### 1.5 Setup auth — bắt buộc

```bash
# Chạy configure wizard — chọn:
# 1. Local (this machine)
# 2. Google/Gemini
# 3. Dán API key (GOOGLE_API_KEY trong .env)
openclaw configure
```

> ⚠️ **Bước này bắt buộc** — wizard tạo `auth-profiles.json` template.

### 1.6 (Nếu dùng Vertex AI) Copy file service account

```bash
# Đặt file JSON service account vào folder vertex-ai/
mkdir -p vertex-ai
cp /path/to/your-service-account.json vertex-ai/
# Folder vertex-ai/ đã nằm trong .gitignore — an toàn
```

### 1.7 Sync auth cho tất cả agents

```bash
# Script tự detect phương thức auth (API Key / Vertex AI / cả hai)
chmod +x scripts/sync-auth.sh
bash scripts/sync-auth.sh
```

> Script tự động phát hiện phương thức xác thực từ `.env` và cấu hình tương ứng.
> Khi đổi phương thức hoặc key: sửa `.env` → chạy lại `bash scripts/sync-auth.sh` → restart gateway.

### 1.8 Copy config vào OpenClaw

```bash
mkdir -p ~/.openclaw
cp .env ~/.openclaw/.env
cp openclaw.json ~/.openclaw/openclaw.json
```

> **Ghi chú**: OpenClaw hỗ trợ [hot reload](https://docs.openclaw.ai/gateway/configuration#config-hot-reload) — sửa `~/.openclaw/openclaw.json` thì Gateway tự reload.

### 1.9 Khởi động Gateway

```bash
# QUAN TRỌNG: source .env trước khi chạy gateway để load model variables
source ~/my-staff/.env

# Cách 1: screen (đơn giản, chạy nền)
screen -S openclaw
source ~/my-staff/.env && openclaw gateway
# Nhấn Ctrl+A rồi D để thoát screen (gateway vẫn chạy)
# Quay lại xem logs: screen -r openclaw

# Cách 2: pm2 (tự restart khi VPS reboot)
npm install -g pm2
pm2 start "source ~/my-staff/.env && openclaw gateway" --name openclaw
pm2 save
pm2 startup  # tạo script tự chạy khi VPS reboot
```

### 1.10 Pairing Telegram (4 bots)

```bash
# Mở Telegram → gửi /start cho từng bot:
# 1. @Tho_TieuMyBot → /start
# 2. @Tho_MrInsightBot → /start
# 3. @Tho_MrLogicBot → /start
# 4. @Tho_MrStrategyBot → /start

# Approve pairing (nếu dùng dmPolicy: pairing)
openclaw pairing list telegram
openclaw pairing approve telegram <CODE>
```

### 1.11 Tạo Cron Job

**Cron 1: Điểm tin hàng ngày (8AM mỗi ngày)**

```bash
source ~/my-staff/.env && openclaw cron add \
  --name "Điểm tin thanh toán hàng ngày" \
  --cron "0 8 * * *" \
  --tz "Asia/Ho_Chi_Minh" \
  --session isolated \
  --agent thu-ky-tieu-my \
  --message "Nghiên cứu và gửi anh bản tin thanh toán thế giới hôm nay nhé. Ưu tiên: công nghệ thanh toán, CBDC, blockchain, Visa/Mastercard, agentic commerce, VN fintech." \
  --announce \
  --channel telegram \
  --to "${TELEGRAM_OWNER_ID}"
```

**Cron 2: Tổng hợp hàng tuần (thứ 5, 8AM)**

```bash
source ~/my-staff/.env && openclaw cron add \
  --name "Tổng hợp bản tin thanh toán tuần" \
  --cron "0 8 * * 4" \
  --tz "Asia/Ho_Chi_Minh" \
  --session isolated \
  --agent thu-ky-tieu-my \
  --message "Tổng hợp bản tin thanh toán thế giới tuần qua. So sánh với tuần trước, nêu xu hướng nổi bật và đề xuất hành động cho anh nhé." \
  --announce \
  --channel telegram \
  --to "${TELEGRAM_OWNER_ID}"
```

### 1.12 Verify

```bash
openclaw doctor           # kiểm tra config
openclaw status           # kiểm tra gateway
openclaw cron list        # kiểm tra cron

# Test: gửi tin nhắn cho @Tho_TieuMyBot → Agent phản hồi
```

---

## PHẦN 2: Cập nhật

### 2.1 Update OpenClaw

```bash
npm update -g openclaw@latest
openclaw doctor
```

### 2.2 Update my-staff (khi chỉnh sửa agent)

```bash
# === Trên máy local (Windows) ===
cd my-staff
git add -A
git commit -m "update: chỉnh sửa agent XYZ"
git push origin main

# === Trên VPS ===
cd ~/my-staff
git pull origin main
cp openclaw.json ~/.openclaw/openclaw.json
# Gateway tự hot-reload config
```

### 2.3 Đổi credentials hoặc chuyển phương thức auth

```bash
# 1. Sửa .env — đổi key hoặc chuyển phương thức
nano ~/my-staff/.env

# Ví dụ: chuyển từ API Key → Vertex AI:
#   - Comment dòng GOOGLE_API_KEY=...
#   - Uncomment 3 dòng GOOGLE_APPLICATION_CREDENTIALS, GOOGLE_CLOUD_PROJECT, GOOGLE_CLOUD_LOCATION
#   - Đổi model prefix: TIEU_MY_MODEL=google-vertex/gemini-3.0-flash

# 2. Copy .env mới lên OpenClaw
cp ~/my-staff/.env ~/.openclaw/.env

# 3. Sync auth
bash ~/my-staff/scripts/sync-auth.sh

# 4. Restart gateway
pkill -f openclaw-gateway
screen -S openclaw
source ~/my-staff/.env && openclaw gateway
```

### 2.4 Quản lý cron job

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
| Cron (tự động) | Hàng ngày 8AM + Hàng tuần thứ 5, 8AM (giờ VN) |

### Chat commands (trong Telegram)

| Command | Mô tả |
|---------|-------|
| `/status` | Xem session status (model + tokens) |
| `/new` hoặc `/reset` | Reset session |
| `/compact` | Compact session context |
| `/model` | Xem/đổi model |

---

## Kiến trúc multi-agent

```
channels.telegram.accounts:
  default (Tiểu My)  ──binding──► agent: thu-ky-tieu-my
  insight             ──binding──► agent: mr-insight
  logic               ──binding──► agent: mr-logic
  strategy            ──binding──► agent: mr-strategy

Inter-agent communication (sessions_send):
  Thư ký ──sessions_send──► Mr. Insight / Mr. Logic / Mr. Strategy
```

Mỗi agent có workspace riêng (`IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `USER.md`, `TOOLS.md`) và session độc lập.
