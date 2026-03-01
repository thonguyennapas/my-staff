#!/bin/bash
# Sync auth-profiles.json cho từng agent với API key riêng
# Mỗi agent dùng 1 Google API key riêng → tránh rate limit
#
# Cách dùng:
#   bash scripts/sync-auth.sh
#
# Yêu cầu:
#   - Đã chạy 'openclaw configure' ít nhất 1 lần (để có template)
#   - File .env có đủ 4 biến GOOGLE_API_KEY_*

set -e

# Load .env
ENV_FILE="${STAFF_HOME:-.}/.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | grep -v '^\s*$' | xargs)
elif [ -f ~/.openclaw/.env ]; then
    export $(grep -v '^#' ~/.openclaw/.env | grep -v '^\s*$' | xargs)
else
    echo "❌ Không tìm thấy .env"
    exit 1
fi

# Tìm auth-profiles.json template từ main agent
MAIN_AUTH="/root/.openclaw/agents/main/agent/auth-profiles.json"
if [ ! -f "$MAIN_AUTH" ]; then
    echo "❌ Không tìm thấy $MAIN_AUTH"
    echo "Hãy chạy 'openclaw configure' trước để setup API key."
    exit 1
fi

echo "📋 Auth template: $MAIN_AUTH"
echo "🔑 Mỗi agent sẽ nhận API key riêng"
echo ""

# Đọc template
TEMPLATE=$(cat "$MAIN_AUTH")

# Tìm API key hiện tại trong template để replace
# Lấy key đầu tiên tìm thấy trong template (dạng AIza...)
TEMPLATE_KEY=$(grep -oP 'AIza[A-Za-z0-9_-]+' "$MAIN_AUTH" | head -1)

if [ -z "$TEMPLATE_KEY" ]; then
    echo "❌ Không tìm thấy API key trong template auth-profiles.json"
    exit 1
fi

echo "🔍 Template key detected: ${TEMPLATE_KEY:0:10}..."
echo ""

# Map agent → API key
declare -A AGENT_KEYS
AGENT_KEYS[thu-ky-tieu-my]="$GOOGLE_API_KEY_TIEU_MY"
AGENT_KEYS[mr-insight]="$GOOGLE_API_KEY_INSIGHT"
AGENT_KEYS[mr-logic]="$GOOGLE_API_KEY_LOGIC"
AGENT_KEYS[mr-strategy]="$GOOGLE_API_KEY_STRATEGY"

# Sync cho từng agent
for agent in thu-ky-tieu-my mr-insight mr-logic mr-strategy; do
    DEST="/root/.openclaw/agents/$agent/agent"
    API_KEY="${AGENT_KEYS[$agent]}"

    if [ -z "$API_KEY" ]; then
        echo "⚠️  $agent → SKIP (không tìm thấy API key trong .env)"
        continue
    fi

    mkdir -p "$DEST"

    # Replace API key trong template và ghi ra file
    echo "$TEMPLATE" | sed "s|$TEMPLATE_KEY|$API_KEY|g" > "$DEST/auth-profiles.json"

    # Hiển thị key (chỉ 10 ký tự đầu)
    echo "✅ $agent → ${API_KEY:0:10}..."
done

echo ""
echo "🎉 Done! Mỗi agent giờ có API key riêng."
echo ""
echo "👉 Tiếp theo:"
echo "   1. Copy .env mới lên OpenClaw:  cp .env ~/.openclaw/.env"
echo "   2. Restart gateway:             pkill -f openclaw-gateway && openclaw gateway"
