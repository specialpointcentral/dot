# simplify 安装说明

来源仓库：

```text
https://github.com/brianlovin/claude-config.git
```

适用场景：

- 写完代码后简化最近修改。
- 减少重复、嵌套和不必要抽象。
- 统一局部代码风格，同时保持功能不变。

## 安装前先确认

Agent 在安装前必须先向用户确认：

1. 是否安装 `simplify`。
2. 是否只安装到 `~/.agents/skills`，还是同时兼容 Claude Code / Codex。

默认建议安装，因为它是轻量单 skill，不需要额外运行时依赖。

## 安装步骤

```bash
mkdir -p ~/.agents/skills
git clone https://github.com/brianlovin/claude-config.git /tmp/claude-config-skills
mkdir -p ~/.agents/skills/simplify
cp /tmp/claude-config-skills/skills/simplify/SKILL.md ~/.agents/skills/simplify/SKILL.md
```

## Claude Code / Codex 兼容处理

如果目标客户端不直接读取 `~/.agents/skills`，创建链接：

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
ln -snf ~/.agents/skills/simplify ~/.claude/skills/simplify
ln -snf ~/.agents/skills/simplify ~/.codex/skills/simplify
```

只为用户要求兼容的客户端创建链接。

## 验证

```bash
test -f ~/.agents/skills/simplify/SKILL.md
```

如果创建了 Claude Code / Codex 兼容链接：

```bash
test -f ~/.claude/skills/simplify/SKILL.md
test -f ~/.codex/skills/simplify/SKILL.md
```

## Agent 注意事项

- 这是单文件 skill，正常情况下只需要复制 `SKILL.md`。
- 不要把整个 `claude-config` 仓库复制到 skills 目录。
- 如果上游目录结构变化，先查找实际的 `skills/simplify/SKILL.md` 再安装。
