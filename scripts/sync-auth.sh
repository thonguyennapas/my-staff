#!/bin/bash
# Sync auth-profiles.json từ main agent sang tất cả agents
# Chạy sau khi openclaw configure xong

MAIN_AUTH="/root/.openclaw/agents/main/agent/auth-profiles.json"
AGENTS=("thu-ky-tieu-my" "mr-insight" "mr-logic" "mr-strategy")

# Tìm auth-profiles.json của main agent
if [ ! -f "$MAIN_AUTH" ]; then
  echo "❌ Không tìm thấy $MAIN_AUTH"
  echo "Hãy chạy 'openclaw configure' trước để setup API key."
  exit 1
fi

echo "📋 Auth source: $MAIN_AUTH"
echo ""

for agent in "${AGENTS[@]}"; do
  DEST="/root/.openclaw/agents/$agent/agent"
  mkdir -p "$DEST"
  cp "$MAIN_AUTH" "$DEST/auth-profiles.json"
  echo "✅ $agent → auth synced"
done

echo ""
echo "🎉 Done! Restart gateway: pkill -f openclaw-gateway && openclaw gateway"
