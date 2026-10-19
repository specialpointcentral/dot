# Superpowers（using-superpowers）安装说明

来源仓库：[obra/superpowers](https://github.com/obra/superpowers)，技能位于 `skills/<skill-name>/`。

适用场景：需求澄清、实现计划、系统化调试、测试驱动开发、代码审查和完成前验证。`using-superpowers` 是入口技能，会指导 Agent 查找相关流程技能；仅安装入口不等于安装完整工作流。

本仓库采用 **本地 skills 安装方式**，统一落在 `~/.agents/skills`。上游 [README](https://github.com/obra/superpowers#installation) 也提供插件安装方式；下面是符合本仓库目录约定的文件部署方案，不安装 marketplace、SessionStart hooks 或其它插件组件。

## 安装前先确认

遵循 [../AGENTS.md](../AGENTS.md)，以下选择先纳入最终计划，批准后才执行命令。

1. 是否安装 Superpowers，以及范围是仅 `using-superpowers`、明确列出的技能子集，还是确认后的整套技能。
2. 是否需要 Claude Code / Codex 兼容链接；是否已有插件、同名目录或符号链接。
3. 选定的来源提交，以及已有安装的保留、跳过或升级处理方式。

建议需要完整开发流程的用户选择整套，但必须先确认范围，不能默认全量安装。只安装入口时，说明后续引用的其它技能可能缺失，不得假装这些技能已经可用。

## 安装步骤

需要 Git。2026-10-19 核对的提交为 `bb92a77741419a4ab5f06e711a283343f1ada0c3`，其 `skills/` 下有以下 15 个技能；未来版本需重新检查实际清单：

```text
brainstorming
diagnosing-superpowers
dispatching-parallel-agents
executing-plans
finishing-a-development-branch
receiving-code-review
requesting-code-review
subagent-driven-development
systematic-debugging
test-driven-development
using-git-worktrees
using-superpowers
verification-before-completion
writing-plans
writing-skills
```

下方新装示例仅选择 `using-superpowers`。执行前将 `selected_skills` 改成最终计划中已批准的名字；整套安装也应显式列出清单，不用通配符自动纳入未来新增技能。完整代码块需在同一个 Bash 子 shell 中执行：

```bash
(
  set -eu
  sp_ref=bb92a77741419a4ab5f06e711a283343f1ada0c3
  selected_skills=(using-superpowers)
  sp_stage=$(mktemp -d "${TMPDIR:-/tmp}/dot-superpowers.XXXXXX")
  git clone --filter=blob:none --no-checkout \
    https://github.com/obra/superpowers.git "$sp_stage/source"
  git -C "$sp_stage/source" checkout --detach "$sp_ref"
  test "$(git -C "$sp_stage/source" rev-parse HEAD)" = "$sp_ref"

  # 在复制任何技能前检查全部目标，包括失效符号链接。
  for s in "${selected_skills[@]}"; do
    case "$s" in ''|*[!a-z0-9-]*) exit 1 ;; esac
    test -f "$sp_stage/source/skills/$s/SKILL.md"
    if [ -e "$HOME/.agents/skills/$s" ] || [ -L "$HOME/.agents/skills/$s" ]; then
      printf '目标已存在：%s；请按批准的保留或升级计划处理。\n' "$s" >&2
      exit 1
    fi
  done
  mkdir -p "$HOME/.agents/skills"
  for s in "${selected_skills[@]}"; do
    cp -R "$sp_stage/source/skills/$s" "$HOME/.agents/skills/$s"
    diff -qr "$sp_stage/source/skills/$s" "$HOME/.agents/skills/$s"
  done
  printf '来源提交：%s\n暂存目录：%s\n' "$sp_ref" "$sp_stage"
)
```

每个技能必须复制完整目录，包含 `references/`、脚本和其它配套资源，不只复制 `SKILL.md`。保留来源提交、技能清单和上游许可信息；暂存目录后续按批准的清理安排处理。升级时先准备并核验新目录，再处理旧目录，不直接混合覆盖。

若使用 Codex 自带的 `install-skill-from-github.py`，来源为 `--repo obra/superpowers`；`--path` 传入已批准的 `skills/using-superpowers` 等路径，并指定固定 `--ref` 和 `--dest "$HOME/.agents/skills"`。先检查安装器是否存在，两种安装方式任选其一。

## Claude Code / Codex 兼容处理

若客户端不能直接发现统一目录，只为选定客户端和已安装技能建立链接。以下示例仅映射 Claude Code 的入口技能；将数组按批准范围调整，Codex 对应根目录为 `~/.codex/skills`：

```bash
(
  set -eu
  selected_skills=(using-superpowers)
  sp_client_root="$HOME/.claude/skills"
  for s in "${selected_skills[@]}"; do
    case "$s" in ''|*[!a-z0-9-]*) exit 1 ;; esac
    test -f "$HOME/.agents/skills/$s/SKILL.md"
    if [ -e "$sp_client_root/$s" ] || [ -L "$sp_client_root/$s" ]; then
      printf '兼容入口已存在：%s；先核对目标，不强制替换。\n' "$s" >&2
      exit 1
    fi
  done
  mkdir -p "$sp_client_root"
  for s in "${selected_skills[@]}"; do
    ln -s "$HOME/.agents/skills/$s" "$sp_client_root/$s"
  done
)
```

完整套件逐个映射已安装技能，不能只把一个包含全部子目录的 `superpowers/` 目录链接到客户端后就假定全部被发现。已有链接正确则保留；目标冲突时按计划处理，不使用强制链接覆盖其它技能。

## 验证

```bash
test -f ~/.agents/skills/using-superpowers/SKILL.md
test -f ~/.agents/skills/using-superpowers/references/codex-tools.md
test -f ~/.agents/skills/using-superpowers/references/claude-code-tools.md
```

按批准清单逐一检查其它技能的 `SKILL.md` 及配套目录，确认兼容链接指向正确来源。开启新的客户端会话，检查技能发现结果；Codex 可显式使用 `$using-superpowers`，其它客户端按其技能调用方式验证。不要把静态文件检查当作自动触发、hooks 或完整开发工作流已验证。

## Agent 注意事项

- 安装前检查是否已由插件提供同一套技能，避免双重注册；不擅自卸载插件或更改其启用状态。
- 只部署本地技能不会安装插件启动 hook，不能承诺每个客户端都自动注入入口。
- 部分流程可能引用其它技能、专用工具或上游仓库级资源，调用前检查依赖是否可用；缺失时明确报告，再按用户选择补齐。
- 技能中的并行代理、worktree 或模型建议受当前客户端能力和用户授权约束；安装文档不自动修改 Codex/Claude 的全局配置。
