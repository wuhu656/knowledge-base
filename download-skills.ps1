# 从 GitHub 下载 opencode skill
param(
  [string]$RepoUrl = "https://github.com/farmage/opencode-skills.git",
  [string]$SkillName = ""
)

$skillDir = "C:\Users\Administrator\.config\opencode\skills"

Write-Host "正在从 GitHub 下载 skill..." -ForegroundColor Cyan

# 1. 克隆仓库
$tempDir = Join-Path $env:TEMP "opencode-skills-temp"
if (Test-Path $tempDir) {
  Remove-Item -Recurse -Force $tempDir
}

Write-Host "1. 克隆仓库..." -ForegroundColor Yellow
git clone $RepoUrl $tempDir 2>&1 | Out-Null

if (-not (Test-Path $tempDir)) {
  Write-Host "克隆仓库失败！" -ForegroundColor Red
  exit 1
}

# 2. 复制 skill
Write-Host "2. 复制 skill..." -ForegroundColor Yellow
if ($SkillName -ne "") {
  # 复制指定的 skill
  $src = Join-Path $tempDir "skills\$SkillName"
  $dest = Join-Path $skillDir $SkillName
  if (Test-Path $src) {
    Copy-Item -Path $src -Destination $dest -Recurse -Force
    Write-Host "  已复制: $SkillName" -ForegroundColor Green
  } else {
    Write-Host "  找不到 skill: $SkillName" -ForegroundColor Red
  }
} else {
  # 复制所有 skill
  $srcDir = Join-Path $tempDir "skills"
  if (Test-Path $srcDir) {
    Get-ChildItem -Path $srcDir -Directory | ForEach-Object {
      $dest = Join-Path $skillDir $_.Name
      Copy-Item -Path $_.FullName -Destination $dest -Recurse -Force
      Write-Host "  已复制: $($_.Name)" -ForegroundColor Green
    }
  }
}

# 3. 清理
Write-Host "3. 清理临时文件..." -ForegroundColor Yellow
Remove-Item -Recurse -Force $tempDir

Write-Host "下载完成！重启 opencode 以加载新 skill。" -ForegroundColor Green
