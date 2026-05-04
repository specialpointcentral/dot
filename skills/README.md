# Skills

本目录记录当前常用 agent skills 的来源、安装方式和迁移注意事项。

统一约定：

- 本仓库使用 `~/.agents/skills` 作为统一落点
- 这里写的是当前实际路径，注意是 `agents` 复数，不是 `agent`
- 如果 Claude Code / Codex 的某个版本不读取 `~/.agents/skills`，就把它当作源目录，再用符号链接同步到对应客户端的默认目录

## Agent 执行要求

当用户要求安装、恢复或迁移 skills 时，Agent 不要直接一次性安装全部内容。必须先向用户确认以下选择。

### 1. 询问是否需要 Claude Code / Codex 兼容

先说明默认安装位置是：

```text
~/.agents/skills
```

然后询问用户是否还需要兼容其它客户端：

- 仅安装到 `~/.agents/skills`：适合当前客户端已经能读取该目录的情况
- 同时支持 Claude Code：安装到 `~/.agents/skills`，再链接到 `~/.claude/skills`
- 同时支持 Codex：安装到 `~/.agents/skills`，再链接到 `~/.codex/skills`
- 同时支持 Claude Code 和 Codex：安装到 `~/.agents/skills`，再同时链接到 `~/.claude/skills` 和 `~/.codex/skills`

如果用户不确定，建议选择“同时支持 Claude Code 和 Codex”，因为它只是创建符号链接，不会复制多份文件。

### 2. 逐个询问要安装哪些 skills

Agent 需要逐个列出 skill，并给出功能说明，让用户决定是否安装。不要只问“是否安装全部”。

建议按下面的顺序询问：

| Skill | 是否建议默认安装 | 给用户展示的功能说明 |
|---|---|---|
| `agent-browser` | 是 | 浏览器自动化工具。用于打开网页、点击按钮、填写表单、截图、抓取页面内容、测试本地 Web app，也可用于部分 Electron 应用自动化。需要额外安装全局 `agent-browser` CLI。 |
| `simplify` | 是 | 代码整理工具。用于在写完代码后简化最近修改的代码、减少重复和嵌套、统一风格，同时保持功能不变。 |
| `obsidian-cli` | 按需 | Obsidian 操作工具。用于读取、创建、搜索笔记，管理 daily note、任务、属性、标签和 backlinks。需要本机安装并启用 Obsidian CLI。 |
| `document-SKILLs` | 按需 | 文档处理工具集。包含 `docx`、`pdf`、`pptx`、`xlsx`，用于处理 Word、PDF、PowerPoint、Excel，包括提取文本/表格、编辑文档、填 PDF 表单、处理公式和格式等。依赖较多，占用空间较大。 |

询问时可以使用这种格式：

```text
是否安装 agent-browser？
功能：浏览器自动化、网页测试、截图、表单填写、页面抓取、Electron 自动化。
代价：需要安装全局 agent-browser CLI。
```

用户确认后，只安装用户选择的 skills，并只为已安装的 skills 创建 Claude / Codex 兼容链接。

## 当前技能清单

| Skill | 来源仓库 | 主要用途 | 安装说明 |
|---|---|---|---|
| `agent-browser` | `https://github.com/vercel-labs/agent-browser.git` | 浏览器自动化、网页测试、Electron 自动化 | 安装全局 CLI 后，将 skill 放到 `~/.agents/skills/agent-browser/` |
| `simplify` | `https://github.com/brianlovin/claude-config.git` | 代码简化、整理最近修改的代码 | 将 `skills/simplify/SKILL.md` 复制到 `~/.agents/skills/simplify/` |
| `obsidian-cli` | `https://github.com/kepano/obsidian-skills.git` | 操作 Obsidian vault、搜索、任务、属性 | 将 `skills/obsidian-cli/SKILL.md` 复制到 `~/.agents/skills/obsidian-cli/` |
| `document-SKILLs` | `https://github.com/appautomaton/document-SKILLs.git` | Word / PDF / PPTX / XLSX 处理 | 直接克隆整个仓库到 `~/.agents/skills/document-SKILLs/` |

## 安装建议

### 1. 创建统一落点

```bash
mkdir -p ~/.agents/skills
```

### 2. 安装 `agent-browser`

```bash
npm install -g agent-browser
agent-browser install
```

安装 skill 定义：

```bash
git clone https://github.com/vercel-labs/agent-browser.git /tmp/agent-browser-skills
mkdir -p ~/.agents/skills/agent-browser
cp /tmp/agent-browser-skills/skills/agent-browser/SKILL.md ~/.agents/skills/agent-browser/SKILL.md
```

但要真正使用它，还必须安装全局 CLI。

### 3. 安装 `simplify`

```bash
git clone https://github.com/brianlovin/claude-config.git /tmp/claude-config-skills
mkdir -p ~/.agents/skills/simplify
cp /tmp/claude-config-skills/skills/simplify/SKILL.md ~/.agents/skills/simplify/SKILL.md
```

上游来源：

```text
https://github.com/brianlovin/claude-config.git
```

### 4. 安装 `obsidian-cli`

```bash
git clone https://github.com/kepano/obsidian-skills.git /tmp/obsidian-skills
mkdir -p ~/.agents/skills/obsidian-cli
cp /tmp/obsidian-skills/skills/obsidian-cli/SKILL.md ~/.agents/skills/obsidian-cli/SKILL.md
```

然后在 Obsidian 应用里启用 CLI。当前本机实际命令是 `obsidian-cli`；如果你的环境只提供 `obsidian`，就按客户端实际命令调整 skill 文本或加一个符号链接。

### 5. 安装 `document-SKILLs`

```bash
git clone https://github.com/appautomaton/document-SKILLs.git ~/.agents/skills/document-SKILLs
cd ~/.agents/skills/document-SKILLs/docx && npm install
cd ~/.agents/skills/document-SKILLs/pptx && npm install
```

还需要这些系统依赖：

```bash
brew install pandoc poppler tesseract qpdf
brew install --cask libreoffice
```

Python 工具统一通过 `uv run` 执行。

如果目标客户端只扫描 `~/.agents/skills` 的一级子目录，可以把四个文档 skill 也链接到顶层：

```bash
for s in docx pdf pptx xlsx; do
  ln -snf ~/.agents/skills/document-SKILLs/$s ~/.agents/skills/$s
done
```

## Claude Code / Codex 兼容处理

如果你的 Claude Code 或 Codex 版本**直接读取** `~/.agents/skills`，那么只需要把 skills 安装到这个目录即可，不需要额外处理。

如果某个客户端**不读取** `~/.agents/skills`，就把同一套 skills 用符号链接镜像到它自己的默认目录：

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
for s in agent-browser simplify obsidian-cli; do
  ln -snf ~/.agents/skills/$s ~/.claude/skills/$s
  ln -snf ~/.agents/skills/$s ~/.codex/skills/$s
done

for s in docx pdf pptx xlsx; do
  ln -snf ~/.agents/skills/document-SKILLs/$s ~/.claude/skills/$s
  ln -snf ~/.agents/skills/document-SKILLs/$s ~/.codex/skills/$s
done
```

`document-SKILLs` 需要按 `docx`、`pdf`、`pptx`、`xlsx` 分别链接；不要只链接整个 `document-SKILLs` 目录，避免客户端只扫描一层时读不到里面的 `SKILL.md`。

## 迁移顺序

推荐顺序如下：

1. 先建 `~/.agents/skills`
2. 先装 `document-SKILLs`
3. 再装 `agent-browser`
4. 再装 `simplify`
5. 再装 `obsidian-cli`
6. 最后按需把技能镜像到 Claude / Codex 的默认目录
