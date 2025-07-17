# إعداد
$basePath = "$env:USERPROFILE\Desktop\aiimages"
$dailyPath = "$basePath\daily"
$today = Get-Date -Format "yyyy-MM-dd"
$todayPath = "$dailyPath\$today"
New-Item -ItemType Directory -Force -Path $todayPath | Out-Null

# إعداد صور اليوم - يمكنك تغيير البرومبتات حسب النيش
$prompts = @(
    "A futuristic AI-inspired abstract wallpaper",
    "Minimalist mountain landscape with neon sky",
    "Cyberpunk city street with vibrant colors"
)

# فتح Bing Image Creator تلقائيًا (يمكنك استخدام Playground AI أيضًا)
foreach ($prompt in $prompts) {
    $url = "https://www.bing.com/images/create?q=" + [uri]::EscapeDataString($prompt)
    Start-Process $url
    Start-Sleep -Seconds 15
}
Write-Host "`n📸 افتح كل تبويبة، احفظ الصورة داخل هذا المجلد: $todayPath`n"

# انتظار المستخدم لحفظ الصور يدويًا ثم المتابعة
pause

# تحديث صفحة HTML
$indexPath = "$basePath\index.html"
$htmlHead = @"
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <title>AI Images Archive</title>
  <style>
    body { font-family:sans-serif; padding:20px; background:#fafafa }
    img { max-width:300px; height:auto; margin:10px; border:1px solid #ccc }
  </style>
</head>
<body>
<h1>📅 أرشيف صور ذكاء اصطناعي يومي</h1>
<p>🔗 <a href='https://payhip.com/yourstore'>اشترِ جميع الصور بدقة كاملة</a> أو <a href='https://ko-fi.com/yourpage'>ادعمني هنا</a></p>
<ul>
"@

$htmlBody = ""

# توليد روابط الصور حسب التاريخ
$folders = Get-ChildItem -Path $dailyPath -Directory | Sort-Object Name -Descending
foreach ($folder in $folders) {
    $date = $folder.Name
    $htmlBody += "<li><h3>$date</h3>"
    $imgs = Get-ChildItem -Path $folder.FullName -Include *.jpg, *.png -Recurse
    foreach ($img in $imgs) {
        $relPath = $img.FullName.Replace($basePath + "\", "").Replace("\", "/")
        $htmlBody += "<img src='$relPath' alt='$date'>"
    }
    $htmlBody += "</li>`n"
}

$htmlFooter = "</ul></body></html>"

# حفظ الصفحة
$htmlFull = $htmlHead + $htmlBody + $htmlFooter
Set-Content -Path $indexPath -Value $htmlFull -Encoding UTF8

# GitHub: إضافة الصور والرفع التلقائي
Set-Location $basePath
git add .
git commit -m "تحديث يوم $today"
git push

Write-Host "`n✅ تم التحديث والنشر على GitHub Pages: تحقق من موقعك!"
