#!/bin/bash

# 🚀 سكريبت النشر السريع للبورتفوليو
echo "🌟 بدء عملية النشر..."

# 1. بناء المشروع للويب
echo "📦 بناء Flutter Web..."
flutter clean
flutter pub get
flutter build web --release

# 2. إعداد Git إذا لم يكن معداً
if [ ! -d ".git" ]; then
    echo "🔧 إعداد Git..."
    git init
    git branch -M main
    echo "⚠️  يرجى إضافة remote origin manually:"
    echo "git remote add origin https://github.com/yourusername/memo_portfolio.git"
fi

# 3. رفع التحديثات
echo "📤 رفع التحديثات إلى GitHub..."
git add .
git status

# اطلب رسالة commit
echo "✍️  أدخل رسالة التحديث:"
read commit_message

if [ -z "$commit_message" ]; then
    commit_message="Update portfolio"
fi

git commit -m "$commit_message"

# محاولة الرفع
echo "🚀 رفع إلى GitHub..."
if git remote get-url origin > /dev/null 2>&1; then
    git push origin main
    echo "✅ تم رفع التحديثات بنجاح!"
    echo "🌐 سيكون البورتفوليو متاحاً على:"
    echo "   https://yourusername.github.io/memo_portfolio/"
    echo "⏱️  انتظر 2-5 دقائق للنشر التلقائي"
else
    echo "⚠️  يرجى إضافة remote origin أولاً:"
    echo "git remote add origin https://github.com/yourusername/memo_portfolio.git"
    echo "ثم تشغيل: git push -u origin main"
fi

echo "🎉 انتهى!"
