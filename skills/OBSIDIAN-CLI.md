# obsidian-cli 安装说明

来源仓库：

```text
https://github.com/kepano/obsidian-skills.git
```

适用场景：

- 操作 Obsidian vault。
- 搜索、创建和读取笔记。
- 管理 daily note、任务、属性、标签和 backlinks。

这个 skill 依赖本机 Obsidian CLI。当前本机实际命令是 `obsidian-cli`；如果目标环境只提供 `obsidian`，需要按实际命令调整 skill 文本或创建符号链接。

## 安装前先确认

Agent 在安装前必须先向用户确认：

1. 是否安装 `obsidian-cli` skill。
2. 是否已经安装并启用 Obsidian CLI。
3. 是否只安装到 `~/.agents/skills`，还是同时兼容 Claude Code / Codex。

默认按需安装，因为只有使用 Obsidian vault 时才需要。

## 安装步骤

```bash
mkdir -p ~/.agents/skills
git clone https://github.com/kepano/obsidian-skills.git /tmp/obsidian-skills
mkdir -p ~/.agents/skills/obsidian-cli
cp /tmp/obsidian-skills/skills/obsidian-cli/SKILL.md ~/.agents/skills/obsidian-cli/SKILL.md
```

然后在 Obsidian 应用里启用 CLI。

## Claude Code / Codex 兼容处理

如果目标客户端不直接读取 `~/.agents/skills`，创建链接：

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
ln -snf ~/.agents/skills/obsidian-cli ~/.claude/skills/obsidian-cli
ln -snf ~/.agents/skills/obsidian-cli ~/.codex/skills/obsidian-cli
```

只为用户要求兼容的客户端创建链接。

## 验证

```bash
test -f ~/.agents/skills/obsidian-cli/SKILL.md
command -v obsidian-cli
```

如果当前环境使用 `obsidian` 作为命令名：

```bash
command -v obsidian
```

如果创建了 Claude Code / Codex 兼容链接：

```bash
test -f ~/.claude/skills/obsidian-cli/SKILL.md
test -f ~/.codex/skills/obsidian-cli/SKILL.md
```

## Agent 注意事项

- 安装 skill 不代表 Obsidian vault 已授权或 CLI 可用，必须验证命令存在。
- 不要假设命令一定叫 `obsidian`；当前本机记录是 `obsidian-cli`。
- 涉及用户笔记内容时，先确认目标 vault 和操作范围。
