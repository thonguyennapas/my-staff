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

# Python 3.11+ (cho NeuralMemory)
python3 --version
sudo apt-get install -y python3 python3-pip
```

### 1.2 Cài OpenClaw

```bash
npm install -g openclaw@latest
```

### 1.3 Cài NeuralMemory plugin

```bash
# Python package
pip install --break-system-packages --ignore-installed neural-memory

# OpenClaw plugin (phải cài bằng openclaw CLI)
openclaw plugins install @neuralmemory/openclaw-plugin

# Cài dependencies cho plugin
cd ~/.openclaw/extensions/neuralmemory && npm install && cd -
```

> ⚠️ Nếu `openclaw plugins install` báo lỗi config → tạm bỏ `plugins` khỏi `~/.openclaw/openclaw.json`, cài xong rồi thêm lại.

### 1.4 Clone repo

```bash
git clone https://github.com/thonguyennapas/my-staff.git
cd my-staff
```

### 1.5 Tạo file .env

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
| `GOOGLE_API_KEY_TIEU_MY` | [Google AI Studio](https://aistudio.google.com/apikey) — key riêng cho Tiểu My |
| `GOOGLE_API_KEY_INSIGHT` | Google AI Studio — key riêng cho Mr. Insight |
| `GOOGLE_API_KEY_LOGIC` | Google AI Studio — key riêng cho Mr. Logic |
| `GOOGLE_API_KEY_STRATEGY` | Google AI Studio — key riêng cho Mr. Strategy |

> ⚠️ **Quan trọng**: Tạo **4 API key riêng biệt** (không dùng chung 1 key) để tránh rate limit khi nhiều agent hoạt động cùng lúc.

### 1.6 Setup auth (API key) — bắt buộc

```bash
# Chạy configure wizard — chọn:
# 1. Local (this machine)
# 2. Google/Gemini
# 3. Dán API key của Tiểu My (GOOGLE_API_KEY_TIEU_MY)
openclaw configure
```

> ⚠️ **Bước này bắt buộc** — wizard tạo `auth-profiles.json` template. Sau đó script sync sẽ gán key riêng cho từng agent.

### 1.7 Sync auth cho tất cả agents (mỗi agent 1 key riêng)

```bash
# Gán API key riêng cho từng agent (đọc từ .env)
chmod +x scripts/sync-auth.sh
bash scripts/sync-auth.sh
```

> Script sẽ đọc 4 biến `GOOGLE_API_KEY_*` từ `.env` và tạo `auth-profiles.json` riêng cho từng agent.
> Sau này đổi API key: sửa `.env` → chạy lại `bash scripts/sync-auth.sh` → restart gateway.

### 1.8 Copy config vào OpenClaw

```bash
mkdir -p ~/.openclaw
cp .env ~/.openclaw/.env
cp openclaw.json ~/.openclaw/openclaw.json
```

> **Ghi chú**: OpenClaw hỗ trợ [hot reload](https://docs.openclaw.ai/gateway/configuration#config-hot-reload) — sửa `~/.openclaw/openclaw.json` thì Gateway tự reload.

### 1.9 Khởi động Gateway

```bash
# Cách 1: screen (đơn giản, chạy nền)
screen -S openclaw
openclaw gateway
# Nhấn Ctrl+A rồi D để thoát screen (gateway vẫn chạy)
# Quay lại xem logs: screen -r openclaw

# Cách 2: pm2 (tự restart khi VPS reboot)
npm install -g pm2
pm2 start "openclaw gateway" --name openclaw
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

**Bước 1: Test daily trước (8AM mỗi ngày)**

```bash
openclaw cron add \
  --name "Test điểm tin hàng ngày" \
  --cron "0 8 * * *" \
  --tz "Asia/Ho_Chi_Minh" \
  --session isolated \
  --agent thu-ky-tieu-my \
  --message "Bắt đầu quy trình 'Điểm tin thị trường hàng ngày' (chế độ test):

1. Chốt scope hôm nay (ưu tiên: công nghệ thanh toán, Visa/Mastercard, CBDC, blockchain, agentic commerce, VN fintech)
2. Phân công Mr. Insight gom tin + signals + link
3. Phân công Mr. Logic validate + confidence + risks
4. Phân công Mr. Strategy kết luận + forecast + đề xuất
5. Đóng gói thành 01 bản gửi sếp với đủ 4 phần:
   - (1) Điểm tin có link (5-10 tin)
   - (2) Kết luận ngày (2-3 kết luận chính)
   - (3) Xu hướng (nếu có)
   - (4) Đề xuất (nếu cần)

Lưu ý: đây là bản test daily, ngắn gọn hơn bản weekly." \
  --announce \
  --channel telegram \
  --to "${TELEGRAM_OWNER_ID}"
```

**Bước 2: Khi ổn định → chuyển sang weekly thứ 5**

```bash
# Xóa cron test daily
openclaw cron list
openclaw cron remove <daily-job-id>

# Tạo cron weekly chính thức (thứ 5, 8AM)
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

### 2.3 Đổi API key

```bash
# 1. Sửa .env — cập nhật key mới cho agent cần đổi
nano ~/my-staff/.env

# 2. Copy .env mới lên OpenClaw
cp ~/my-staff/.env ~/.openclaw/.env

# 3. Sync auth (gán key riêng cho từng agent)
bash ~/my-staff/scripts/sync-auth.sh

# 4. Restart gateway
pkill -f openclaw-gateway
screen -S openclaw
openclaw gateway
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
| Cron (tự động) | Mỗi thứ 5, 8AM (giờ VN) → Thư ký tự chạy |

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
