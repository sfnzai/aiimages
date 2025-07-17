# إعداد المجلدات
$basePath = "$PSScriptRoot"
$today = Get-Date -Format "yyyy-MM-dd"
$imgFolder = "$basePath\daily\$today"
New-Item -ItemType Directory -Path $imgFolder -Force | Out-Null

# برومبتات الصور
$prompts = @(
    "Cyberpunk city at night, vibrant neon lights",
    "Futuristic Arabic calligraphy digital art",
    "Minimalist desert landscape with stars"
)

# تحميل الصور من pollinations.ai
for ($i = 0; $i -lt $prompts.Count; $i++) {
    $prompt = [uri]::EscapeDataString($prompts[$i])
    $url = "https://image.pollinations.ai/prompt/$prompt"
    $fileName = "img_$($i+1).jpg"
    $savePath = Join-Path $imgFolder $fileName
    Invoke-WebRequest -Uri $url -OutFile $savePath
    Start-Sleep -Seconds 5
}

# توليد صفحة index.html
$indexPath = "$basePath\index.html"
$html = @"
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <title>AI Image Archive</title>
  <style>
    body { font-family: Arial; padding: 20px; background: #f0f0f0; }
    h1 { color: #333; }
    img { max-width: 300px; margin: 10px; border: 1px solid #ccc; }
  </style>
</head>
<body>
  <h1>📅 AI Image Archive</h1>
  <p><a href='https://payhip.com/yourstore'>🔗 Buy full-resolution packs</a> | <a href='https://ko-fi.com/yourpage'>☕ Support me</a></p>
  <ul>
"@

$folders = Get-ChildItem "$basePath\daily" -Directory | Sort-Object Name -Descending
foreach ($folder in $folders) {
    $html += "<li><h2>$($folder.Name)</h2>"
    $imgs = Get-ChildItem $folder.FullName -Include *.jpg, *.png -Recurse
    foreach ($img in $imgs) {
        $relPath = $img.FullName.Replace($basePath + "\", "").Replace("\", "/")
        $html += "<img src='$relPath' alt='$($img.Name)'>"
    }
    $html += "</li>`n"
}

$html += "</ul></body></html>"
Set-Content -Path $indexPath -Value $html -Encoding UTF8

# رفع إلى GitHub
Set-Location $basePath
git add .
git commit -m "✅ تحديث تلقائي $today"
git push

Write-Host "`n✅ تم توليد الصور ونشرها بنجاح: https://sfnzai.github.io/aiimages/"
