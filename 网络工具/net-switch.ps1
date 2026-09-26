param([string]$Mode = 'Toggle')

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
$state = (Get-ItemProperty -Path $key -Name ProxyEnable -ErrorAction SilentlyContinue).ProxyEnable
$isOn = ($state -eq 1)

if ($Mode -eq 'On') { $turnOn = $true }
elseif ($Mode -eq 'Off') { $turnOn = $false }
else { $turnOn = -not $isOn }

if ($turnOn -eq $isOn) {
    $label = if ($isOn) { '开着的' } else { '已关闭' }
    Write-Host ''
    Write-Host '  ----------------------------' -ForegroundColor DarkGray
    Write-Host "   网络加速现在就是【$label】，不用动。" -ForegroundColor Yellow
    Write-Host '  ----------------------------' -ForegroundColor DarkGray
    Write-Host ''
    Read-Host '  按回车键关闭这个窗口'
    exit 0
}

if ($turnOn) {
    Write-Host ''
    Write-Host '  ================================' -ForegroundColor Cyan
    Write-Host '     正在打开网络加速...' -ForegroundColor Yellow
    Write-Host '  ================================' -ForegroundColor Cyan
    Set-ItemProperty -Path $key -Name ProxyEnable -Value 1 -Type DWord
    Set-ItemProperty -Path $key -Name ProxyServer -Value '127.0.0.1:7897' -Type String
    Clear-DnsClientCache -ErrorAction SilentlyContinue
    Write-Host ''
    Write-Host '  [ 成功 ] 已打开！' -ForegroundColor Green
    Write-Host '  国外网站可以用了，但速度会慢一些。'
}
else {
    Write-Host ''
    Write-Host '  ================================' -ForegroundColor Cyan
    Write-Host '     正在关闭网络加速...' -ForegroundColor Yellow
    Write-Host '  ================================' -ForegroundColor Cyan
    Set-ItemProperty -Path $key -Name ProxyEnable -Value 0 -Type DWord
    Clear-DnsClientCache -ErrorAction SilentlyContinue
    Write-Host ''
    Write-Host '  [ 成功 ] 已关闭！' -ForegroundColor Green
    Write-Host '  国内网站会明显变快。'
    Write-Host '  国外网站暂时打不开了。'
}

Write-Host ''
Write-Host '  ----------------------------' -ForegroundColor DarkGray
Write-Host '   记得：把浏览器全部关掉再打开，' -ForegroundColor DarkGray
Write-Host '   才会马上生效。' -ForegroundColor DarkGray
Write-Host '  ----------------------------' -ForegroundColor DarkGray
Write-Host ''
Read-Host '  按回车键关闭这个窗口'
