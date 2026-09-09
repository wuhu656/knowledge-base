# 从 GitHub/Gitee 拉取内容
param(
  [string]$RepoUrl = "",
  [string]$Branch = "main"
)

if ($RepoUrl -eq "") {
  Write-Host "请提供仓库地址，例如: .\pull-from-github.ps1 -RepoUrl 'https://github.com/username/repo.git'" -ForegroundColor Yellow
  exit 1
}

$kb = "E:\knowledge-base"
$repoDir = Join-Path $kb "repo"

Write-Host "正在从 GitHub/Gitee 拉取内容..." -ForegroundColor Cyan

# 1. 克隆或拉取仓库
if (Test-Path $repoDir) {
  Write-Host "1. 拉取最新内容..." -ForegroundColor Yellow
  Set-Location $repoDir
  git pull --ff-only 2>&1 | Out-Null
} else {
  Write-Host "1. 克隆仓库..." -ForegroundColor Yellow
  git clone $RepoUrl $repoDir 2>&1 | Out-Null
  Set-Location $repoDir
  git checkout $Branch 2>&1 | Out-Null
}

# 2. 复制内容到知识库
Write-Host "2. 复制内容到知识库..." -ForegroundColor Yellow
$notesDir = Join-Path $kb "notes"
New-Item -ItemType Directory -Path $notesDir -Force | Out-Null

# 复制所有 .md 文件
Get-ChildItem -Path $repoDir -Filter "*.md" -Recurse | ForEach-Object {
  $dest = Join-Path $notesDir $_.Name
  Copy-Item -Path $_.FullName -Destination $dest -Force
  Write-Host "  复制: $($_.Name)" -ForegroundColor Green
}

Write-Host "内容已拉取到: $notesDir" -ForegroundColor Green
Write-Host "提示: 运行 sync.ps1 可以将内容推送到 GitHub" -ForegroundColor Yellow
