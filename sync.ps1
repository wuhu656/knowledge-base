param(
  [string]$Message = ""
)
$kb = "E:\knowledge-base"
if ($Message -eq "") { $Message = "knowledge-base sync " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
Set-Location $kb

git pull --ff-only 2>&1 | Out-Null

git add -A | Out-Null
$changed = git diff --cached --name-only
if (-not $changed) {
  Write-Host "没有改动，跳过提交。" -ForegroundColor Green
  git push 2>&1 | Out-Null
  exit 0
}

git commit -m $Message 2>&1 | Out-Null
git push 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
  Write-Host "推送被拒绝，先拉取再重试……" -ForegroundColor Yellow
  git pull --rebase 2>&1 | Out-Null
  git push 2>&1 | Out-Null
}
Write-Host "同步完成。" -ForegroundColor Green