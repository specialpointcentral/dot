# academic-research-suite 安装说明

来源仓库：[Imbad0202/academic-research-skills-codex](https://github.com/Imbad0202/academic-research-skills-codex)。实际技能目录为 `skills/academic-research-suite/`，上游直接安装说明见 [README](https://github.com/Imbad0202/academic-research-skills-codex#direct-skill-install-or-update)。

适用场景：研究问题梳理、文献综述、论文写作与修订、引用检查、模拟审稿、研究到论文流程和实验规划。

这是 ARS 的 **Codex 适配版单入口技能**，与本目录的 [AI-Research-SKILLs](AI-RESEARCH-SKILLS.md) 是不同项目。它包含 `ars/` 工作流、模板、脚本及 `codex/` 适配资源，不是单文件 skill。

## 安装前先确认

遵循 [../AGENTS.md](../AGENTS.md)：先收集选择，再提交完整计划，最终批准前不执行以下命令。

1. 是否安装 `academic-research-suite`，以及是否已有本地 skill 或插件提供同名入口。
2. 目标是否为 Codex；是否需要额外的 `~/.codex/skills` 兼容链接。Claude 原生版本按下文单独选择。
3. 使用哪个提交或版本；若已有目录、符号链接或用户修改，是保留、跳过还是按计划备份替换。

建议有学术研究需求时安装。采用本地 skill 方式，不自动添加 marketplace、插件、hooks、模型配置或额外 API 凭据。

## 安装步骤

需要 Git；下方元数据检查需要 Python 3。下面是新装示例，固定提交是 2026-10-19 核对过的来源，版本为 `3.23.1`，不代表未来始终最新。升级时重新核对上游，在计划中记录选定提交。

完整代码块在同一个 Bash 子 shell 中执行；目标存在时停止，不覆盖已有安装：

```bash
(
  set -eu
  ars_ref=71528d9349bcdacfbe94111f06d9e2d82215a44d
  ars_target="$HOME/.agents/skills/academic-research-suite"
  if [ -e "$ars_target" ] || [ -L "$ars_target" ]; then
    printf '%s\n' '目标已存在，请按批准的保留或升级计划处理。' >&2
    exit 1
  fi
  ars_stage=$(mktemp -d "${TMPDIR:-/tmp}/dot-ars.XXXXXX")
  git clone --filter=blob:none --no-checkout \
    https://github.com/Imbad0202/academic-research-skills-codex.git "$ars_stage/source"
  git -C "$ars_stage/source" checkout --detach "$ars_ref"
  test "$(git -C "$ars_stage/source" rev-parse HEAD)" = "$ars_ref"
  python3 - "$ars_stage/source" <<'PY'
import json, pathlib, re, sys
root = pathlib.Path(sys.argv[1])
skill = root / 'skills/academic-research-suite'
version = (root / 'VERSION').read_text().strip()
metadata = re.search(r'^  version: "([^"]+)"$', (skill / 'SKILL.md').read_text(), re.M)
manifest = json.loads((skill / 'manifest.json').read_text())
assert metadata and metadata.group(1) == version == manifest['adapter_version']
assert (skill / 'ars/deep-research/WORKFLOW.md').is_file()
assert (skill / 'codex').is_dir()
print('ARS package version:', version)
PY
  mkdir -p "$HOME/.agents/skills"
  cp -R "$ars_stage/source/skills/academic-research-suite" "$ars_target"
  diff -qr "$ars_stage/source/skills/academic-research-suite" "$ars_target"
  printf '来源提交：%s\n暂存目录：%s\n' "$ars_ref" "$ars_stage"
)
```

复制整个 `academic-research-suite/`，保留配套资源和许可文件；不要将 `ars/` 下各工作流拆成单独技能，也不要把整个上游仓库复制到 skills 根目录。暂存目录用于核验，后续按批准的清理安排处理。

若使用 Codex 自带的 `install-skill-from-github.py`，等价来源参数为 `--repo Imbad0202/academic-research-skills-codex --path skills/academic-research-suite`，并显式指定已批准的 `--ref`、`--dest "$HOME/.agents/skills"` 和 `--method git`；先确认安装器实际路径，不要求 Claude 环境存在此脚本。两种方式任选其一。

## Claude Code / Codex 兼容处理

Codex 能发现 `~/.agents/skills` 时不再创建重复入口。只有用户选择兼容链接且目标不存在时执行：

```bash
(
  set -eu
  ars_link="$HOME/.codex/skills/academic-research-suite"
  test -f "$HOME/.agents/skills/academic-research-suite/SKILL.md"
  if [ -e "$ars_link" ] || [ -L "$ars_link" ]; then
    printf '%s\n' '兼容入口已存在，先核对目标，不强制替换。' >&2
    exit 1
  fi
  mkdir -p "$HOME/.codex/skills"
  ln -s "$HOME/.agents/skills/academic-research-suite" "$ars_link"
)
```

不要把这个 Codex 适配目录直接链接到 `~/.claude/skills` 并宣称获得原生 Claude ARS。需要 Claude Code 原生版时，另行读取 [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) 的当前安装说明，确认其安装方式、范围和冲突处理，纳入计划后执行。选择“两端兼容”不等于授权安装另一套插件。

## 验证

```bash
test -f ~/.agents/skills/academic-research-suite/SKILL.md
test -f ~/.agents/skills/academic-research-suite/manifest.json
test -f ~/.agents/skills/academic-research-suite/ars/deep-research/WORKFLOW.md
test -d ~/.agents/skills/academic-research-suite/codex
```

创建兼容链接时，另检查 `readlink ~/.codex/skills/academic-research-suite` 和链接下的 `SKILL.md`。随后开启新的 Codex 会话，确认技能列表能发现一个 `academic-research-suite` 入口；可用时通过 `/skills` 查看。使用 `$academic-research-suite` 指定任务。文件存在、客户端发现和实际研究工作流成功是不同的验证结果，应分别报告。

## Agent 注意事项

- 更新时先在暂存目录核验新包，再按批准方案备份、替换目标；不要先删除旧目录或把新旧资源混合覆盖。
- 检查本地技能与插件是否重复，不能因文件复制成功就宣称插件已经安装。
- 正常使用不要求启用可选 full-runtime hooks、跨模型验证或安装全部 Python 依赖；只有所选工作流确有需要时另行确认。
- 不改写用户当前模型或 reasoning 设置；技能文档中的模型建议不会自动切换当前会话。
