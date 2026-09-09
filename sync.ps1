param(
  [string]$Message = ""
)
$kb = "C:\Users\Administrator\knowledge-base"
if ($Message -eq "") { $Message = "knowledge-base sync " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
Set-Location $kb
git add -A | Out-Null
$changed = git diff --cached --name-only
if (-not $changed) {
  Write-Host "没有改动，跳过提交。" -ForegroundColor Green
  git pull --ff-only 2>&1
  if ($?) { git push 2>&1 }
  exit 0
}
Write-Host "提交: $Message"
git commit -m $Message
git push 2>&1