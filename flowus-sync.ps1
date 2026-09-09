param(
  [string]$Token = "",
  [string[]]$PageIds = @(),
  [string]$OutDir = "E:\knowledge-base\notes"
)
if ($Token -ne "") { $env:FLOWUS_TOKEN = $Token }
if ($PageIds.Count -eq 0) {
  Write-Host "用法: powershell -File flowus-sync.ps1 -PageIds 页面ID1,页面ID2" -ForegroundColor Yellow
  Write-Host "先运行 flowus login 登录，或设置 FLOWUS_TOKEN。" -ForegroundColor Yellow
  exit 1
}
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
foreach ($id in $PageIds) {
  $out = Join-Path $OutDir "$id.md"
  Write-Host "拉取 $id -> $out"
  flowus --json markdown get $id 2>$null | Set-Content -Encoding UTF8 $out
  if (-not $?) { Write-Host "  $id 拉取失败" -ForegroundColor Red }
}
Write-Host "完成。运行 sync.ps1 推送到 GitHub。" -ForegroundColor Green