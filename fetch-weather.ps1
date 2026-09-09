# 获取天气并写入 FlowUs
param(
  [string]$City = "北京",
  [string]$PageId = ""
)

# 获取天气信息（wttr.in 偶尔返回空，重试最多 3 次；用 curl 抓取更稳定）
$encCity = [System.Uri]::EscapeDataString($City)
$weatherUrl = "https://wttr.in/${encCity}?format=j1"
$data = $null
for ($attempt = 1; $attempt -le 3; $attempt++) {
  try {
    $raw = curl.exe -s --max-time 20 $weatherUrl
    $data = ($raw -join "`n") | ConvertFrom-Json
    if ($data.current_condition -and $data.current_condition.Count -gt 0) { break }
  } catch {}
  if ($attempt -lt 3) { Start-Sleep -Seconds 3 }
}

if (-not $data -or $data.current_condition.Count -eq 0) {
  Write-Host "获取天气失败：wttr.in 没有返回数据。" -ForegroundColor Red
  exit 1
}

$current = $data.current_condition[0]
$temp = $current.temp_C
$desc = $current.weatherDesc[0].value
$humidity = $current.humidity
$wind = $current.windspeedKmph

$content = @"
# $City 天气 $(Get-Date -Format "yyyy-MM-dd HH:mm")

- 温度: ${temp}°C
- 天气: ${desc}
- 湿度: ${humidity}%
- 风速: ${wind} km/h
"@

# 写入 FlowUs
if ($PageId -ne "") {
  $body = @{
    parent = @{ type = "page_id"; page_id = $PageId }
    properties = @{
      title = @(@{ text = @(@{ content = "$City 天气 $(Get-Date -Format 'yyyy-MM-dd')" }) })
    }
    children = @(@{
      object = "block"
      type = "paragraph"
      paragraph = @(@{ rich_text = @(@{ type = "text"; text = @(@{ content = $content }) }) })
    })
  } | ConvertTo-Json -Depth 10

  $bodyFile = Join-Path $env:TEMP "flowus-body.json"
  [System.IO.File]::WriteAllText($bodyFile, $body, (New-Object System.Text.UTF8Encoding $false))

  Write-Host "正在写入 FlowUs..."
  flowus --json page create --body $bodyFile | Out-Null
  if ($?) {
    Write-Host "天气已写入 FlowUs！" -ForegroundColor Green
  } else {
    Write-Host "写入 FlowUs 失败。" -ForegroundColor Red
  }
} else {
  Write-Host $content
  Write-Host "`n提示: 指定 -PageId 参数可自动写入 FlowUs" -ForegroundColor Yellow
}