# knowledge-base

个人知识库 / 息流读写仓库。

## 新功能

### 1. 息流CLI自动化

- `fetch-weather.ps1` — 获取天气并写入 FlowUs
- 使用方法: `.\fetch-weather.ps1 -City "北京" -PageId "你的页面ID"`

### 2. 本地公文流水线

- `generate-doc.ps1` — 调用本地 Qwen 模型生成文档
- 使用方法: `.\generate-doc.ps1 -Requirement "写一份关于环保的报告"`
- 前提: 需要先安装 Ollama 并运行 Qwen 模型

### 3. GitHub/Gitee当笔记本

- `sync.ps1` — 提交并推送全部改动到 GitHub
- `pull-from-github.ps1` — 从 GitHub/Gitee 拉取内容
- 使用方法: `.\pull-from-github.ps1 -RepoUrl "https://github.com/username/repo.git"`

### 4. SkillHub白嫖

- `download-skills.ps1` — 从 GitHub 下载 opencode skill
- 使用方法: `.\download-skills.ps1 -RepoUrl "https://github.com/farmage/opencode-skills.git"`

## 目录结构

- `notes/` — 笔记 markdown，glow 直接渲染
- `flowus-sync.ps1` — 从 FlowUs 拉取页面为 markdown 到 `notes/`
- `sync.ps1` — 提交并推送全部改动到 GitHub
- `fetch-weather.ps1` — 获取天气并写入 FlowUs
- `generate-doc.ps1` — 调用本地 Qwen 模型生成文档
- `pull-from-github.ps1` — 从 GitHub/Gitee 拉取内容
- `download-skills.ps1` — 从 GitHub 下载 opencode skill

## 快速开始

1. **安装 FlowUs CLI**
   ```bash
   npm install -g flowus-cli
   flowus login
   ```

2. **安装 Ollama 并运行 Qwen 模型**
   ```bash
   # 下载并安装 Ollama: https://ollama.com
   ollama pull qwen
   ollama serve
   ```

3. **下载 skill**
   ```powershell
   .\download-skills.ps1
   ```

4. **获取天气**
   ```powershell
   .\fetch-weather.ps1 -City "北京"
   ```

5. **生成文档**
   ```powershell
   .\generate-doc.ps1 -Requirement "写一份关于环保的报告"
   ```

6. **同步知识库**
   ```powershell
   .\sync.ps1
   ```
