# Skills

本目录记录当前常用 agent skills 的来源、用途和安装入口。README 只作为总索引；每个 skill 的具体安装、依赖、兼容链接和验证步骤放在独立 md 里。

统一约定：

- 本仓库使用 `~/.agents/skills` 作为统一落点。
- 这里写的是当前实际路径，注意是 `agents` 复数，不是 `agent`。
- 如果 Claude Code / Codex 的某个版本不读取 `~/.agents/skills`，就把它当作源目录，再用符号链接同步到对应客户端的默认目录。
- 安装、恢复或迁移某个 skill 前，必须先读取该 skill 对应的独立 md。

## Agent 执行要求

当用户要求安装、恢复或迁移 skills 时，先读取 [../AGENTS.md](../AGENTS.md)，遵循统一的四阶段流程。不要直接一次性安装全部内容，先向用户确认以下选择。

以下选择以及独立 skill 文档中的“安装前先确认”均在收集选择阶段完成。按当前模式和工具能力优先使用 `request_user_input` 或等效工具；不可用时用普通消息提问。每轮提问后等待有效回答，异步返回、取消或沉默都不算确认。具体等待方式以根目录 `AGENTS.md` 为准。

### 1. 询问是否需要 Claude Code / Codex 兼容

先说明默认安装位置是：

```text
~/.agents/skills
```

然后询问用户是否还需要兼容其它客户端：

- 仅安装到 `~/.agents/skills`：适合当前客户端已经能读取该目录的情况。
- 同时支持 Claude Code：安装到 `~/.agents/skills`，再链接到 `~/.claude/skills`。
- 同时支持 Codex：安装到 `~/.agents/skills`，再链接到 `~/.codex/skills`。
- 同时支持 Claude Code 和 Codex：安装到 `~/.agents/skills`，再同时链接到 `~/.claude/skills` 和 `~/.codex/skills`。

如果用户不确定，建议选择“同时支持 Claude Code 和 Codex”，因为它只是创建符号链接，不会复制多份文件。

### 2. 逐个询问要安装哪些 skills

Agent 需要逐个列出 skill，并给出功能说明，让用户决定是否安装。不要只问“是否安装全部”。

用户确认选项后，先将所选 skills、依赖和兼容链接纳入最终安装计划；此时不安装、不创建目录或链接。完整计划获批且当前模式允许执行后，只安装计划内的 skills，并只为已安装的 skills 创建已批准的兼容链接。

## 当前技能清单

| Skill | 是否建议默认安装 | 主要用途 | 详细文档 |
|---|---|---|---|
| `agent-browser` | 是 | 浏览器自动化、网页测试、截图、表单填写、页面抓取、Electron 自动化。需要额外安装全局 `agent-browser` CLI。 | [`AGENT-BROWSER.md`](AGENT-BROWSER.md) |
| `code-simplifier` | 开发环境按需；已有则复用 | 基于 Anthropic agent 定义的本地 skill 适配，用于显式请求的代码整理，保持行为并遵循项目规范；替代 `simplify`，避免重复安装。 | [`CODE-SIMPLIFIER.md`](CODE-SIMPLIFIER.md) |
| `obsidian-cli` | 按需 | Obsidian vault 操作、搜索、daily note、任务、属性、标签和 backlinks。需要本机安装并启用 Obsidian CLI。 | [`OBSIDIAN-CLI.md`](OBSIDIAN-CLI.md) |
| `document-SKILLs` | 按需 | 文档处理工具集。包含 `docx`、`pdf`、`pptx`、`xlsx`，用于处理 Word、PDF、PowerPoint、Excel。依赖较多，占用空间较大。 | [`DOCUMENT-SKILLS.md`](DOCUMENT-SKILLS.md) |
| `AI-Research-SKILLs` | 按需 | AI research、训练、评测、推理、论文写作等综合 skill library。不是单个 skill，而是复杂集合。 | [`AI-RESEARCH-SKILLS.md`](AI-RESEARCH-SKILLS.md) |
| `academic-research-suite` | 按需 | ARS 的 Codex 单入口适配版，用于文献综述、论文写作、审稿和实验规划；必须保留整包资源。Claude 原生版单独选择。 | [`ACADEMIC-RESEARCH-SUITE.md`](ACADEMIC-RESEARCH-SUITE.md) |
| `using-superpowers` / Superpowers | 按需 | 开发流程入口及配套技能，覆盖需求澄清、规划、调试、测试和审查；先确认仅入口、技能子集或整套，本仓库采用本地 skills 方式。 | [`SUPERPOWERS.md`](SUPERPOWERS.md) |

“建议安装”不等于用户已选择。`academic-research-suite` 与 `AI-Research-SKILLs` 是不同项目；`using-superpowers` 是 Superpowers 的入口，不是完整套件。客户端兼容有例外：ARS Codex 适配版不能直接按通用模板链接给 Claude 并当作原生版，按对应独立文档处理。

## 新增自定义 skill 的约定

未来如果添加自己的 skill，按下面结构维护：

1. 在本目录新增一个独立 md，例如 `MY-SKILL.md`。
2. 在 README 的“当前技能清单”里加一行，只写用途简介和文档链接。
3. 在独立 md 里写清楚来源、安装位置、依赖、兼容链接、验证命令和注意事项。
4. 如果它不是单个 skill，而是包含多个子 skill 或上游安装器，必须在独立 md 里明确禁止默认全量安装。

独立 md 推荐包含这些小节：

```text
# <Skill 名称> 安装说明

来源仓库：
适用场景：
安装前先确认：
安装步骤：
Claude Code / Codex 兼容处理：
验证：
Agent 注意事项：
```

## 迁移顺序

完成只读检查、选择收集和最终计划批准后，按以下顺序执行；相关独立文档应已在规划阶段读完：

1. 先建 `~/.agents/skills`。
2. 核对所选 skill 的目标目录和已有内容，出现计划外冲突时暂停询问。
3. 只安装最终计划中已批准的 skills。
4. 最后按需把已安装的 skills 用符号链接同步到 Claude / Codex 的默认目录。

通用符号链接模板：

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
ln -snf ~/.agents/skills/<skill-name> ~/.claude/skills/<skill-name>
ln -snf ~/.agents/skills/<skill-name> ~/.codex/skills/<skill-name>
```

如果只需要兼容其中一个客户端，就只执行对应那一行。多子目录 skill 或复杂 skill library 仍以对应 md 里的说明为准。
