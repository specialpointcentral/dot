# document-SKILLs 安装说明

来源仓库：

```text
https://github.com/appautomaton/document-SKILLs.git
```

适用场景：

- Word / DOCX 处理。
- PDF 文本、表格、表单和页面处理。
- PowerPoint / PPTX 创建和编辑。
- Excel / XLSX / CSV / TSV 分析、公式、格式和可视化。

这个仓库包含多个文档 skills：`docx`、`pdf`、`pptx`、`xlsx`。它依赖较多，占用空间较大，默认按需安装。

## 安装前先确认

Agent 在安装前必须先向用户确认：

1. 是否安装整套 `document-SKILLs`。
2. 是否需要兼容 Claude Code / Codex。
3. 是否安装系统依赖和 Node/Python 依赖。

默认建议按需安装；如果用户只需要某一种文档格式，也可以只链接对应子 skill。

## 安装步骤

克隆整个仓库：

```bash
mkdir -p ~/.agents/skills
git clone https://github.com/appautomaton/document-SKILLs.git ~/.agents/skills/document-SKILLs
```

安装 Node 依赖：

```bash
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

`document-SKILLs` 需要按 `docx`、`pdf`、`pptx`、`xlsx` 分别链接；不要只链接整个 `document-SKILLs` 目录，避免客户端只扫描一层时读不到里面的 `SKILL.md`。

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
for s in docx pdf pptx xlsx; do
  ln -snf ~/.agents/skills/document-SKILLs/$s ~/.claude/skills/$s
  ln -snf ~/.agents/skills/document-SKILLs/$s ~/.codex/skills/$s
done
```

只为用户要求兼容的客户端创建链接。

## 验证

检查 skill 文件：

```bash
find ~/.agents/skills/document-SKILLs -maxdepth 2 -name SKILL.md | sort
```

检查常见系统依赖：

```bash
command -v pandoc
command -v pdftotext
command -v tesseract
command -v qpdf
command -v libreoffice
```

如果创建了 Claude Code / Codex 兼容链接：

```bash
find ~/.claude/skills ~/.codex/skills -maxdepth 2 -name SKILL.md | sort
```

## Agent 注意事项

- 这是多 skill 仓库，安装和兼容链接都要按子目录处理。
- 不要只把 `document-SKILLs` 整体链接到 Claude / Codex 的 skills 根目录。
- `docx` 和 `pptx` 需要 Node 依赖；`pdf` 和 `xlsx` 通常主要依赖 Python/系统工具。
- 系统依赖安装方式要按当前平台调整；上面的 `brew` 命令适用于 Homebrew 环境。
