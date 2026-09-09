# 调用本地 Qwen 模型生成文档
param(
  [string]$Requirement = "",
  [string]$OutputFile = "output.docx"
)

if ($Requirement -eq "") {
  Write-Host "请提供需求，例如: .\generate-doc.ps1 -Requirement '写一份关于环保的报告'" -ForegroundColor Yellow
  exit 1
}

Write-Host "正在调用本地 Qwen 模型..." -ForegroundColor Cyan

# 这里需要调用本地 Qwen 模型
# 假设你已经通过 Ollama 运行了 Qwen 模型
# 你可以使用 Ollama API 或其他方式调用

# 示例: 使用 Ollama API
$ollamaUrl = "http://localhost:11434/api/generate"
$body = @{
  model = "qwen"
  prompt = "请根据以下需求生成一份符合国标的公文文档内容: $Requirement"
  stream = $false
} | ConvertTo-Json

try {
  $response = Invoke-RestMethod -Uri $ollamaUrl -Method Post -Body $body -ContentType "application/json"
  $content = $response.response

  # 这里需要将内容转换为 docx 格式
  # 你可以使用 python-docx 或其他工具

  Write-Host "文档内容已生成，正在保存为 docx..." -ForegroundColor Cyan

  # 示例: 保存为文本文件 (需要进一步转换为 docx)
  $txtFile = [System.IO.Path]::ChangeExtension($OutputFile, ".txt")
  $content | Set-Content -Encoding UTF8 $txtFile

  Write-Host "文档已保存为: $txtFile" -ForegroundColor Green
  Write-Host "提示: 你可以使用 WPS 打开该文件" -ForegroundColor Yellow

  # 尝试用 WPS 打开
  if (Test-Path $txtFile) {
    Start-Process "wps.exe" -ArgumentList $txtFile
  }
} catch {
  Write-Host "调用 Qwen 模型失败: $_" -ForegroundColor Red
}
