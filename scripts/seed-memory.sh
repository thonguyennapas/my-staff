#!/bin/bash
# ============================================
# Seed NeuralMemory brain "my-staff"
# Nạp sở thích, lịch sử, quy tắc của anh Thọ
# Chạy 1 lần sau khi cài NeuralMemory
# ============================================

set -e

BRAIN="my-staff"
echo "🧠 Seeding brain: $BRAIN"

# Đảm bảo dùng đúng brain
nmem brain use "$BRAIN" 2>/dev/null || nmem brain create "$BRAIN"

# ──────────────────────────────────────────
# THÔNG TIN ANH THỌ
# ──────────────────────────────────────────

nmem remember "Anh Thọ làm việc trong lĩnh vực thanh toán & fintech. Gọi là 'anh Thọ'." \
  --type fact --priority 10 --tags "user,identity"

nmem remember "Anh Thọ quan tâm: công nghệ thanh toán (Visa, Mastercard, payment networks), blockchain (crypto payments, CBDC, DLT), agentic commerce." \
  --type preference --priority 9 --tags "user,interest"

nmem remember "Quốc gia trọng điểm anh Thọ theo dõi: China, Israel, các nước triển khai blockchain vào hệ thống quản lý." \
  --type preference --priority 9 --tags "user,interest,country"

nmem remember "Anh Thọ quan tâm Việt Nam: hội nghị & điểm tin thanh toán/ngân hàng/fintech về công nghệ thanh toán." \
  --type preference --priority 9 --tags "user,interest,vietnam"

# ──────────────────────────────────────────
# SỞ THÍCH OUTPUT
# ──────────────────────────────────────────

nmem remember "Anh Thọ muốn nhận 01 bản chốt cuối cùng, KHÔNG muốn nhận nhiều bản rời." \
  --type preference --priority 10 --tags "user,output,format"

nmem remember "Anh Thọ muốn output ngắn gọn, đi thẳng trọng tâm. Không viết dài dòng." \
  --type preference --priority 9 --tags "user,output,style"

nmem remember "Output PHẢI luôn có: kết luận + xu hướng/dự đoán (nếu có) + đề xuất (nếu cần)." \
  --type instruction --priority 10 --tags "user,output,required"

nmem remember "MỌI claim quan trọng PHẢI có link nguồn có thể click vào. Không chấp nhận thông tin không có dẫn chứng." \
  --type instruction --priority 10 --tags "user,output,source"

nmem remember "KHÔNG chấp nhận đoán bừa — nếu chưa đủ bằng chứng thì nói rõ 'chưa đủ dữ kiện'." \
  --type instruction --priority 9 --tags "user,output,honesty"

nmem remember "Anh Thọ phản hồi kiểu 'ổn / chưa ổn' → Thư ký tự xử lý chi tiết cải thiện." \
  --type preference --priority 8 --tags "user,communication"

nmem remember "Khi anh Thọ phàn nàn = muốn cải thiện hệ thống, không phải trách cá nhân." \
  --type insight --priority 8 --tags "user,mindset"

# ──────────────────────────────────────────
# QUY TẮC TEAM
# ──────────────────────────────────────────

nmem remember "Pipeline: Tiểu My nhận → Insight research → Logic validate → Strategy chốt → Tiểu My đóng gói gửi anh Thọ." \
  --type workflow --priority 8 --tags "team,pipeline"

nmem remember "Tiểu My là chủ sản phẩm đầu ra — KHÔNG BAO GIỜ tự research, phải giao team." \
  --type instruction --priority 9 --tags "team,rule"

nmem remember "Mr. Strategy KHÔNG research, KHÔNG dùng web_search. Chỉ nhận data và chốt kết luận." \
  --type instruction --priority 8 --tags "team,rule,strategy"

nmem remember "Bản tin hàng tuần cần 4 phần: (1) Điểm tin có link, (2) Kết luận tuần, (3) Dự đoán/xu hướng, (4) Đề xuất hành động." \
  --type instruction --priority 9 --tags "output,weekly,format"

# ──────────────────────────────────────────
# DONE
# ──────────────────────────────────────────

echo ""
echo "✅ Brain '$BRAIN' seeded successfully!"
nmem stats
echo ""
echo "💡 Verify: nmem recall 'sở thích anh Thọ'"
