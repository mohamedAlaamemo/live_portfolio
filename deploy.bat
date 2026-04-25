@echo off
REM 🚀 سكريپت النشر السريع للبورتفوليو (Windows)
echo 🌟 بدء عملية النشر...

REM 1. بناء المشروع للويب
echo 📦 بناء Flutter Web...
call flutter clean
call flutter pub get
call flutter build web --release

REM 2. إعداد Git إذا لم يكن معداً
if not exist ".git" (
    echo 🔧 إعداد Git...
    git init
    git branch -M main
    echo ⚠️  يرجى إضافة remote origin يدوياً:
    echo git remote add origin https://github.com/yourusername/memo_portfolio.git
)

REM 3. رفع التحديثات
echo 📤 رفع التحديثات إلى GitHub...
git add .
git status

REM اطلب رسالة commit
set /p commit_message="✍️  أدخل رسالة التحديث: "

if "%commit_message%"=="" set commit_message=Update portfolio

git commit -m "%commit_message%"

REM محاولة الرفع
echo 🚀 رفع إلى GitHub...
git remote get-url origin >nul 2>&1
if %errorlevel% == 0 (
    git push origin main
    echo ✅ تم رفع التحديثات بنجاح!
    echo 🌐 سيكون البورتفوليو متاحاً على:
    echo    https://yourusename.github.io/memo_portfolio/
    echo ⏱️  انتظر 2-5 دقائق للنشر التلقائي
) else (
    echo ⚠️  يرجى إضافة remote origin أولاً:
    echo git remote add origin https://github.com/yourusername/memo_portfolio.git
    echo ثم تشغيل: git push -u origin main
)

echo 🎉 انتهى!
pause
