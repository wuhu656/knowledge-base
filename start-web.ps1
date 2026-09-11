# 启动 opencode 网页服务（手机/其他电脑浏览器访问用）
# 密码：mogu2026
Set-Location "E:\knowledge-base"
$env:OPENCODE_SERVER_USERNAME = "opencode"
$env:OPENCODE_SERVER_PASSWORD = "mogu2026"
$log = "E:\knowledge-base\web-server.log"
Start-Process -FilePath "C:\Users\Administrator\AppData\Roaming\npm\node_modules\opencode-ai\bin\opencode.exe" -ArgumentList "web","--hostname","0.0.0.0","--port","8080" -WindowStyle Hidden -RedirectStandardOutput $log -RedirectStandardError $log
Write-Host "网页服务已启动：http://电脑IP:8080 （用户名 opencode，密码 mogu2026）"