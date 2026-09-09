# 优化 GitHub/Gitee 同步
param(
  [string]$Message = ""
)

$kb = "E:\knowledge-base"
if ($Message -eq "") { $Message = "knowledge-base sync " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
Set-Location $kb

Write-Host "正在同步知识库..." -ForegroundColor Cyan

# 1. 拉取最新内容
Write-Host "1. 拉取最新内容..." -ForegroundColor Yellow
git pull --ff-only 2>&1 | Out-Null

# 2. 添加所有改动
Write-Host "2. 添加所有改动..." -ForegroundColor Yellow
git add -A | Out-Null

# 3. 检查是否有改动
$changed = git diff --cached --name-only
if (-not $changed) {
  Write-Host "没有改动，跳过提交。" -ForegroundColor Green
  git push 2>&1 | Out-Null
  exit 0
}

# 4. 提交改动
Write-Host "3. 提交改动..." -ForegroundColor Yellow
git commit -m $Message 2>&1 | Out-Null

# 5. 推送改动
Write-Host "4. 推送改动..." -ForegroundColor Yellow
git push 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
  Write-Host "推送被拒绝，先拉取再重试……" -ForegroundColor Yellow
  git pull --rebase 2>&1 | Out-Null
  git push 2>&1 | Out-Null
}

Write-Host "同步完成！" -ForegroundColor Green
