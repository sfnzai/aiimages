# إعداد المتغيرات
$localPath = "$env:USERPROFILE\Desktop\aiimages"
$repoURL = "https://github.com/sfnzai/aiimages.git"

# الانتقال إلى مجلد المشروع
Set-Location -Path $localPath

# تهيئة Git وربط الريموت
git init
git remote add origin $repoURL
git checkout -b main

# إضافة جميع الملفات والرفع
git add .
git commit -m "🚀 أول رفع للمشروع"
git push -u origin main

Write-Host "`n✅ تم ربط Git ورفع المشروع بنجاح إلى: https://sfnzai.github.io/aiimages/"
