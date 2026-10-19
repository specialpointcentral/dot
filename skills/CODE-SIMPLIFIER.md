# code-simplifier 安装说明

来源：[Anthropic 官方插件仓库](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier)。原始定义位于 `plugins/code-simplifier/agents/code-simplifier.md`，属于 **Claude agent 定义**，不是上游直接提供的 `SKILL.md`。

本仓库将其适配为本地 `code-simplifier` skill，统一落在 `~/.agents/skills/code-simplifier/`，供 Codex / Claude Code 按各自的技能发现机制使用。此方式不安装官方插件，也不注册独立的 Claude subagent。

适用场景：在保持行为不变的前提下，整理最近修改的代码、减少不必要抽象、改善命名和可读性。目标项目的语言、规范和现有风格优先，不把 React / TypeScript 的约定套用到所有项目。

## 安装前先确认

遵循 [../AGENTS.md](../AGENTS.md)，将选择纳入最终计划，批准后执行。

1. 是否需要 `code-simplifier`；如果当前客户端已提供同名技能或插件，优先复用，不重复注册。
2. 安装到共享目录即可，还是需要 Claude Code / Codex 兼容链接。
3. 已有 `simplify`、`code-simplifier` 目录或链接如何处理：保留、跳过或按计划迁移。

建议需要代码整理且没有同类能力的开发环境安装。更换仓库的安装条目不等于授权删除用户机器上的旧技能；迁移时先确认目录归属和用户修改，再按批准范围处理。

## 安装步骤

需要 Python 3 和网络访问，不需要 Node 或额外 Python 包。下面使用 2026-10-19 核对的上游提交；更新时重新检查源文件，并记录选定提交，不盲目覆盖旧版本。

适配会保留上游正文及来源副本，重新生成 skill 的 `name` / `description`，不继承 `model: opus`。另加本仓库的适用范围说明：显式请求或已批准的代码整理阶段才执行，语言风格以项目为准。

```bash
python3 - <<'PY'
from pathlib import Path
from urllib.request import urlopen

ref = 'ea10b213686c90bb1984b2016937310e05336cf3'
source_path = 'plugins/code-simplifier/agents/code-simplifier.md'
url = f'https://raw.githubusercontent.com/anthropics/claude-plugins-official/{ref}/{source_path}'
target = Path.home() / '.agents/skills/code-simplifier'
if target.exists() or target.is_symlink():
    raise SystemExit('目标已存在，请按批准的保留或迁移计划处理。')

with urlopen(url, timeout=30) as response:
    source = response.read().decode('utf-8')
parts = source.split('---', 2)
if len(parts) != 3 or parts[0].strip() or 'name: code-simplifier' not in parts[1]:
    raise SystemExit('上游格式已变化，停止并检查，不生成技能。')
body = parts[2].strip()
if not body:
    raise SystemExit('上游正文为空，停止安装。')

header = '''---
name: code-simplifier
description: Simplify or refactor recently modified code for clarity while preserving behavior. Use when the user requests code cleanup or an approved plan includes a cleanup step.
---

# Code Simplifier — local skill adapter

## 本地适配规则

以下规则限定上游正文的适用范围，发生冲突时以这些规则为准：
- 仅在用户明确请求或已批准计划包含代码整理时执行，不自动扩大改动范围。
- 先读目标项目的 AGENTS.md / CLAUDE.md 和相关代码；项目语言及规范优先。
- 上游的 React、TypeScript、ES modules 等约定仅用于相应技术栈，且不得覆盖项目规范。
- 不改变外部行为；采用与改动相称的验证，不以代码更短作为唯一目标。
- 保持当前运行时的模型及权限；本技能不要求切换到 Opus 或启动子代理。

## 上游参考正文

'''
result = header + body + '\n'
target.mkdir(parents=True, exist_ok=False)
(target / 'SKILL.md').write_text(result, encoding='utf-8')
(target / 'upstream-agent.md').write_text(source, encoding='utf-8')
(target / 'SOURCE.txt').write_text(url + '\n', encoding='utf-8')
print(f'已写入本地 skill：{target}；来源提交：{ref}')
PY
```

不要将 Claude 的 agent 定义路径直接传给要求源目录存在 `SKILL.md` 的 skill 安装器，也不要从另一台机器的私有目录复制作为唯一安装来源。

## Claude Code / Codex 兼容处理

客户端已能发现共享目录时，不再创建重复入口。下面示例只为 Claude Code 建立链接；用户选择 Codex 时，将 `client_root` 改为 `$HOME/.codex/skills`。只执行批准的客户端范围：

```bash
(
  set -eu
  client_root="$HOME/.claude/skills"
  target="$client_root/code-simplifier"
  test -f "$HOME/.agents/skills/code-simplifier/SKILL.md"
  if [ -e "$target" ] || [ -L "$target" ]; then
    printf '%s\n' '兼容入口已存在，请先检查，不强制覆盖。' >&2
    exit 1
  fi
  mkdir -p "$client_root"
  ln -s "$HOME/.agents/skills/code-simplifier" "$target"
)
```

## 验证

```bash
test -f ~/.agents/skills/code-simplifier/SKILL.md
test -f ~/.agents/skills/code-simplifier/upstream-agent.md
test -f ~/.agents/skills/code-simplifier/SOURCE.txt
```

上述三个文件检查用于本说明的新装方式；复用已有技能时应按其原安装方式验证，不因缺少本说明的来源副本而覆盖它。若创建链接，检查实际链接目标和链接下的 `SKILL.md`。

开启新会话，确认客户端能发现 `code-simplifier`，且没有重复入口。实际整理代码需另有用户任务或已批准的计划；文件存在不代表已验证代码整理效果。

## Agent 注意事项

- 本条目替代原 `simplify` 安装推荐，同一客户端通常保留一个代码整理入口即可。
- 保留上游来源与本地适配规则的区别，不能称此适配文件为官方原版 skill。
- 升级时先在暂存目录核对上游变化，再按批准方案替换；不要自动移除旧 `simplify` 或用户已有的 `code-simplifier`。
