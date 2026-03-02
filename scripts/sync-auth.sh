#!/bin/bash
# Sync auth cho từng agent — hỗ trợ cả 2 phương thức:
#   1. Google AI Studio API Key (GOOGLE_API_KEY / GOOGLE_API_KEY_*)
#   2. Vertex AI Service Account JSON (GOOGLE_APPLICATION_CREDENTIALS)
#
# Cách dùng:
#   bash scripts/sync-auth.sh
#
# Yêu cầu:
#   - Đã chạy 'openclaw configure' ít nhất 1 lần (để có template)
#   - File .env có config phù hợp

set -e

# ─── Load .env ───────────────────────────────────────────────────
ENV_FILE="${STAFF_HOME:-.}/.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | grep -v '^\s*$' | xargs)
elif [ -f ~/.openclaw/.env ]; then
    export $(grep -v '^#' ~/.openclaw/.env | grep -v '^\s*$' | xargs)
else
    echo "❌ Không tìm thấy .env"
    exit 1
fi

# ─── Detect auth method ─────────────────────────────────────────
AUTH_METHOD="none"

# Check Vertex AI first (higher priority if both configured)
if [ -n "$GOOGLE_APPLICATION_CREDENTIALS" ] && [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    AUTH_METHOD="vertex"
    echo "🔍 Phát hiện: Vertex AI Service Account"
    echo "   📄 File: $GOOGLE_APPLICATION_CREDENTIALS"
    echo "   🌐 Project: ${GOOGLE_CLOUD_PROJECT:-'(chưa set)'}"
    echo "   📍 Location: ${GOOGLE_CLOUD_LOCATION:-'us-central1'}"
fi

# Check API Key
if [ -n "$GOOGLE_API_KEY" ] || [ -n "$GOOGLE_API_KEY_TIEU_MY" ]; then
    if [ "$AUTH_METHOD" = "vertex" ]; then
        echo ""
        echo "ℹ️  Cũng tìm thấy API Key — sẽ sync cả hai phương thức"
        AUTH_METHOD="both"
    else
        AUTH_METHOD="apikey"
        echo "🔍 Phát hiện: Google AI Studio API Key"
    fi
fi

if [ "$AUTH_METHOD" = "none" ]; then
    echo "❌ Không tìm thấy credentials nào!"
    echo "   Cần ít nhất 1 trong:"
    echo "   - GOOGLE_API_KEY (AI Studio)"
    echo "   - GOOGLE_APPLICATION_CREDENTIALS (Vertex AI)"
    exit 1
fi

echo ""

# ─── Sync API Key auth (nếu cần) ────────────────────────────────
sync_apikey() {
    echo "═══ Sync API Key cho từng agent ═══"

    # Tìm auth-profiles.json template
    MAIN_AUTH="/root/.openclaw/agents/main/agent/auth-profiles.json"
    if [ ! -f "$MAIN_AUTH" ]; then
        echo "❌ Không tìm thấy $MAIN_AUTH"
        echo "Hãy chạy 'openclaw configure' trước để setup API key."
        return 1
    fi

    TEMPLATE=$(cat "$MAIN_AUTH")
    TEMPLATE_KEY=$(grep -oP 'AIza[A-Za-z0-9_-]+' "$MAIN_AUTH" | head -1)

    if [ -z "$TEMPLATE_KEY" ]; then
        echo "❌ Không tìm thấy API key trong template"
        return 1
    fi

    echo "📋 Template: $MAIN_AUTH"
    echo "🔍 Template key: ${TEMPLATE_KEY:0:10}..."
    echo ""

    # Map agent → API key (dùng key riêng nếu có, không thì dùng key chung)
    declare -A AGENT_KEYS
    AGENT_KEYS[thu-ky-tieu-my]="${GOOGLE_API_KEY_TIEU_MY:-$GOOGLE_API_KEY}"
    AGENT_KEYS[mr-insight]="${GOOGLE_API_KEY_INSIGHT:-$GOOGLE_API_KEY}"
    AGENT_KEYS[mr-logic]="${GOOGLE_API_KEY_LOGIC:-$GOOGLE_API_KEY}"
    AGENT_KEYS[mr-strategy]="${GOOGLE_API_KEY_STRATEGY:-$GOOGLE_API_KEY}"

    for agent in thu-ky-tieu-my mr-insight mr-logic mr-strategy; do
        DEST="/root/.openclaw/agents/$agent/agent"
        API_KEY="${AGENT_KEYS[$agent]}"

        if [ -z "$API_KEY" ]; then
            echo "⚠️  $agent → SKIP (không tìm thấy API key)"
            continue
        fi

        mkdir -p "$DEST"
        echo "$TEMPLATE" | sed "s|$TEMPLATE_KEY|$API_KEY|g" > "$DEST/auth-profiles.json"
        echo "✅ $agent → ${API_KEY:0:10}..."
    done
    echo ""
}

# ─── Sync Vertex AI env (nếu cần) ───────────────────────────────
sync_vertex() {
    echo "═══ Sync Vertex AI Service Account ═══"

    # Verify file exists
    if [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
        echo "❌ File không tồn tại: $GOOGLE_APPLICATION_CREDENTIALS"
        return 1
    fi

    # Extract info from JSON
    PROJECT_ID=$(python3 -c "import json; print(json.load(open('$GOOGLE_APPLICATION_CREDENTIALS'))['project_id'])" 2>/dev/null || echo "unknown")
    CLIENT_EMAIL=$(python3 -c "import json; print(json.load(open('$GOOGLE_APPLICATION_CREDENTIALS'))['client_email'])" 2>/dev/null || echo "unknown")

    echo "📄 File: $GOOGLE_APPLICATION_CREDENTIALS"
    echo "🏗️  Project ID: $PROJECT_ID"
    echo "📧 Service Account: $CLIENT_EMAIL"
    echo "📍 Location: ${GOOGLE_CLOUD_LOCATION:-us-central1}"
    echo ""

    # Verify key trong .env vs file
    if [ -n "$GOOGLE_CLOUD_PROJECT" ] && [ "$GOOGLE_CLOUD_PROJECT" != "$PROJECT_ID" ]; then
        echo "⚠️  GOOGLE_CLOUD_PROJECT trong .env ($GOOGLE_CLOUD_PROJECT) khác project_id trong JSON ($PROJECT_ID)"
        echo "   Sẽ dùng giá trị từ .env"
    fi

    echo "✅ Vertex AI đã cấu hình — env vars sẽ load khi gateway khởi động"
    echo ""
    echo "ℹ️  Để dùng Vertex AI, đổi model trong .env:"
    echo "   TIEU_MY_MODEL=google-vertex/gemini-3.0-flash"
    echo ""
}

# ─── Execute based on detected method ───────────────────────────
case "$AUTH_METHOD" in
    "apikey")
        sync_apikey
        ;;
    "vertex")
        sync_vertex
        ;;
    "both")
        sync_apikey
        sync_vertex
        echo "═══ Tổng kết ═══"
        echo "  ✅ API Key:   Sẵn sàng (provider: google/)"
        echo "  ✅ Vertex AI: Sẵn sàng (provider: google-vertex/)"
        echo "  Đổi model prefix trong .env để chuyển giữa 2 phương thức"
        echo ""
        ;;
esac

echo "🎉 Done!"
echo ""
echo "👉 Tiếp theo:"
echo "   1. Copy .env mới lên OpenClaw:  cp .env ~/.openclaw/.env"
echo "   2. Restart gateway:             pkill -f openclaw-gateway && openclaw gateway"
