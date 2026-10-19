# Dotfiles

个人开发环境配置文件，支持快速恢复到新机器。本文件提供各组件的安装步骤，既可手动参考，也可交给 Codex / Claude Code 执行。

## 交给 AI 安装

Agent 必须先读取 [AGENTS.md](AGENTS.md) 的统一流程：**只读检查 → 收集选择 → 生成计划并等待批准 → 执行与验证**。Claude Code 入口见 [CLAUDE.md](CLAUDE.md)。下文命令是步骤参考，不代表授权安装所有组件。

在本仓库目录中启动 Agent，直接说：

```text
请根据本仓库配置我的开发环境。
```

如果通过 GitHub 链接交给 Agent，使用：

```text
请根据 https://github.com/specialpointcentral/dot 配置我的开发环境。
```

提问工具选择、Plan / Default 兼容、未回答时等待和最终计划批准规则统一维护在 `AGENTS.md`，无需在 prompt 中重复。Agent 读取本页后必须先读取该文件，再开展安装任务。

## 安装步骤约定

每个 Step 按三类操作分块：

- **`[自动]`** — 最终计划批准且模式允许后，可由 Agent 执行的步骤
- **`[手动]`** — 需要用户交互（输入密码、登录、编辑密钥等），提示后等待用户完成
- **`[检查]`** — 验证步骤；前期仅执行只读检查，有写入或下载行为的检查需纳入批准计划

假定你已位于 dot 仓库根目录。先记录当前目录路径：

```bash
DOT_DIR="$(pwd)"
```

按最终批准的组件范围和步骤顺序执行以下章节，不默认安装整套环境。备份、移动文件、复制模板和创建链接也属于执行阶段。

---

## zsh 安装和配置

### Step 1: zsh 安装

#### [自动] 安装 zsh

| macOS (Homebrew) | Ubuntu / Debian | Arch / Manjaro |
|-----------------|-----------------|----------------|
| `brew install zsh` | `sudo apt install zsh` | `sudo pacman -S zsh` |

#### [检查] 确认 zsh 已安装

```bash
zsh --version
```

### Step 2: 安装 oh my zsh（含必要配置）

#### [自动] 安装 oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### [自动] 安装 powerlevel10k 主题

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

#### [手动] 参看模板并合并 Shell 配置（建议由 AI 协助）

考虑到不同系统与已有配置差异较大，这里不建议直接 `cp` 覆盖。建议先备份，再以仓库文件为**参看模板**逐项合并到本机配置。

```bash
mkdir -p ~/.dot-backup
for f in ~/.zshrc ~/.p10k.zsh; do
  [[ -e "$f" && ! -L "$f" ]] && mv "$f" ~/.dot-backup/
  [[ -L "$f" ]] && rm "$f"
done
```

参看文件：
- `"$DOT_DIR/shell/zshrc"` → 目标 `~/.zshrc`
- `"$DOT_DIR/shell/p10k.zsh"` → 目标 `~/.p10k.zsh`

#### [检查] 确认文件已就位

```bash
ls -la ~/.zshrc ~/.p10k.zsh
```

### Step 3: 安装 zsh 插件

#### [自动] 安装 zsh-autosuggestions

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

#### [自动] 安装 zsh-syntax-highlighting

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

#### [检查] 确认插件目录存在

```bash
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 密钥文件配置

#### [自动] 从模板复制密钥文件并设置权限

如果 `~/.secrets.zsh` 不存在，从模板复制并设置 `600` 权限，确保只有当前用户可读写。

```bash
if [[ ! -f ~/.secrets.zsh ]]; then
  cp "$DOT_DIR/shell/secrets.zsh.example" ~/.secrets.zsh
  chmod 600 ~/.secrets.zsh
fi
```

#### [手动] 编辑密钥文件，填入真实 API keys

打开 `~/.secrets.zsh`，将模板中的占位符替换为你的真实密钥。

```bash
vim ~/.secrets.zsh
```

字段说明：
- `ANTHROPIC_BASE_URL` — Anthropic API 的基础 URL
- `ANTHROPIC_AUTH_TOKEN` — Anthropic API 认证令牌

##### Agent 协助说明字段

如果由 AI Agent 执行本步骤，采用以下流程：

1. 规划时确认服务地址、认证方式，以及用户是否准备在执行阶段手动填写凭据，不询问真实 token。
2. 最终计划批准后，Agent 按需创建模板并说明字段，用户在本机编辑 `~/.secrets.zsh`。
3. Agent 等待用户完成回复，再检查文件是否存在及权限是否为 `600`，不读取或显示密钥值。

#### [检查] 确认文件存在且权限为 600

```bash
ls -la ~/.secrets.zsh
stat -c '%a' ~/.secrets.zsh 2>/dev/null || stat -f '%Lp' ~/.secrets.zsh
```

---

## tmux 安装和配置

### Step 1: 安装 tmux

#### [自动] 安装 tmux

| macOS (Homebrew) | Ubuntu / Debian | Arch / Manjaro |
|-----------------|-----------------|----------------|
| `brew install tmux` | `sudo apt install tmux` | `sudo pacman -S tmux` |

#### [检查] 确认 tmux 已安装

```bash
tmux -V
```

### Step 2: 配置 tmux

#### [自动] 安装 TPM（Tmux Plugin Manager）

```bash
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
```

#### [自动] 备份已有配置并复制文件

```bash
mkdir -p ~/.dot-backup
mkdir -p ~/.tmux/scripts
[[ -e ~/.tmux.conf && ! -L ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.dot-backup/
[[ -L ~/.tmux.conf ]] && rm ~/.tmux.conf
cp "$DOT_DIR/tmux/scripts/continuum-save-status.sh" ~/.tmux/scripts/
chmod +x ~/.tmux/scripts/continuum-save-status.sh
cp "$DOT_DIR/tmux/tmux.conf" ~/.tmux.conf
```

#### [检查] 确认文件已就位

```bash
ls -la ~/.tmux.conf
ls -la ~/.tmux/scripts/continuum-save-status.sh
ls ~/.tmux/plugins/tpm/tpm
```

首次进入 tmux 后按 `prefix + I` 安装配置中声明的插件。

本配置包含 `samleeney/tmux-agent-status`，用于在 tmux 中跟踪 Claude Code 和 Codex
agent 状态。插件默认会自动创建状态 sidebar，并把 agent 状态摘要追加到 tmux status line。
`prefix + S` 的 target switcher 依赖 `fzf`；如果本机尚未安装，请先参考「可选工具」安装。

常用按键：

| 按键 | 功能 |
|------|------|
| `prefix + S` | 打开 agent target switcher |
| `prefix + o` | 聚焦或创建 agent status sidebar |
| `prefix + N` | 跳到下一个 ready/done agent |
| `prefix + W` | 将当前 session/pane 设为 wait |
| `prefix + p` | park 当前 session/pane |

#### [自动] 配置 Claude Code hooks

`claude/settings.json` 已包含 `tmux-agent-status` 的 Claude Code hooks，部署 Claude 配置时会
同步到 `~/.claude/settings.json`。如果本机已有自定义 Claude Code 配置，确认 `hooks`
中保留以下事件：

- `UserPromptSubmit`
- `PreToolUse`
- `Stop`
- `Notification`

这些事件应调用 `~/.tmux/plugins/tmux-agent-status/hooks/better-hook.sh`。

#### [自动] 配置 Codex hooks

`codex/config.toml` 已包含：

```toml
[features]
hooks = true
```

`codex/hooks.json` 已包含 `tmux-agent-status` 的 Codex hooks，部署 Codex 配置时会同步到
`~/.codex/hooks.json`。重启 Codex 后，如 Codex 提示 hook command 需要 trust，运行 `/hooks`
并信任新 hook 命令。

---

## Neovim 安装和配置

### Step 1: 安装 neovim

#### [自动] 安装 neovim

| macOS (Homebrew) | Ubuntu / Debian | Arch / Manjaro |
|-----------------|-----------------|----------------|
| `brew install neovim` | `sudo apt install neovim` 或 [从 release 安装](https://github.com/neovim/neovim/releases) | `sudo pacman -S neovim` |

#### [检查] 确认 neovim 已安装

```bash
nvim --version | head -1
```

### Step 2: 配置 LazyVim

#### [自动] 克隆 LazyVim starter

```bash
# 备份已有配置（如果有）
[[ -d ~/.config/nvim ]] && mv ~/.config/nvim ~/.config/nvim.bak

# 克隆 LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# 删除 .git 以便自行管理
rm -rf ~/.config/nvim/.git
```

#### [手动] 启动 nvim 完成插件安装

首次启动 nvim，LazyVim 会自动下载并安装所有插件，等待完成即可。

```bash
nvim
```

---

## 安装 Node.js（AI 工具前置依赖）

以下 AI 工具（Claude / Codex / OpenCode）均依赖 Node.js，请先完成此步骤。

### [自动] 通过 nvm 安装 Node.js

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc  # 或 source ~/.zshrc
nvm install --lts
nvm use --lts
```

### [检查] 确认 Node.js 已就绪

```bash
node --version
npm --version
```

---

## 安装 Skills（Agent 扩展）

本仓库将 agent skills 的统一安装位置设为 `~/.agents/skills`（注意是 `agents` 复数）。当前技能来源和迁移说明见 `skills/README.md`。

### Step 1: 创建 Skills 目录

#### [自动] 创建统一落点

```bash
mkdir -p ~/.agents/skills
```

### Step 2: 安装常用 Skills

#### [手动] 按需安装 skills

参考 `"$DOT_DIR/skills/README.md"` 安装以下 skills：

- `agent-browser` — 浏览器自动化、网页测试、Electron 自动化
- `code-simplifier` — 按项目规范整理最近修改的代码，已有同类能力时复用，见 [安装说明](skills/CODE-SIMPLIFIER.md)
- `obsidian-cli` — 操作 Obsidian vault
- `document-SKILLs` — Word / PDF / PPTX / XLSX 处理
- `academic-research-suite` — 文献综述、论文写作、审稿和实验规划，见 [安装说明](skills/ACADEMIC-RESEARCH-SUITE.md)
- `using-superpowers` / Superpowers — 开发流程入口及配套技能，见 [安装说明](skills/SUPERPOWERS.md)

建议将实际技能安装到 `~/.agents/skills`，与当前机器保持一致。`document-SKILLs` 可以直接 clone 到 `~/.agents/skills/document-SKILLs`。`academic-research-suite` 需复制完整技能包；Superpowers 逐个复制已批准的完整技能目录，不能只复制入口文件或默认安装全部内容。其它单文件 skills 按对应说明部署。

#### [手动] 处理 Claude Code / Codex 兼容性

如果当前 Claude Code / Codex 版本不能读取 `~/.agents/skills`，不要复制多份文件；将 `~/.agents/skills` 作为源目录，再用符号链接映射到客户端自己的默认目录。

常见映射方式：

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
for s in agent-browser obsidian-cli; do
  ln -snf ~/.agents/skills/$s ~/.claude/skills/$s
  ln -snf ~/.agents/skills/$s ~/.codex/skills/$s
done

for s in docx pdf pptx xlsx; do
  ln -snf ~/.agents/skills/document-SKILLs/$s ~/.claude/skills/$s
  ln -snf ~/.agents/skills/document-SKILLs/$s ~/.codex/skills/$s
done
```

`document-SKILLs` 需要按 `docx`、`pdf`、`pptx`、`xlsx` 分别链接，避免客户端只扫描一层 skill 目录时读不到。

`code-simplifier`、ARS 和 Superpowers 的兼容方式以各自独立说明为准：`code-simplifier` 先检查并复用已有能力；ARS Codex 适配版不直接链接给 Claude；Superpowers 只链接已批准并已安装的技能，不覆盖已有同名入口。

#### [检查] 确认 skills 已就位

```bash
find ~/.agents/skills -maxdepth 4 -name SKILL.md -print
```

---

## 安装 Claude

### Step 1: 安装 Claude CLI

#### [自动] 通过 npm 安装

```bash
npm install -g @anthropic-ai/claude-code
```

#### [检查] 确认已安装

```bash
claude --version
```

### Step 2: 配置 Claude

#### [自动] 创建目录并复制配置文件

```bash
mkdir -p ~/.claude
for f in settings.json settings.local.json; do
  [[ -e ~/.claude/$f && ! -L ~/.claude/$f ]] && mv ~/.claude/$f ~/.dot-backup/
  [[ -L ~/.claude/$f ]] && rm ~/.claude/$f
done
cp "$DOT_DIR/claude/settings.json"       ~/.claude/settings.json
cp "$DOT_DIR/claude/settings.local.json" ~/.claude/settings.local.json
```

#### [检查] 确认文件已就位

```bash
ls -la ~/.claude/settings.json ~/.claude/settings.local.json
```

---

## 安装 Codex

### Step 1: 安装 Codex CLI

#### [自动] 通过 npm 安装

```bash
npm install -g @openai/codex
```

#### [检查] 确认已安装

```bash
codex --version
```

### Step 2: 配置 Codex

#### [自动] 创建目录、复制配置文件和认证模板

创建 `~/.codex` 目录，复制 `config.toml` 和 `hooks.json` 配置文件。如果 `auth.json` 不存在，从模板复制并设置 `600` 权限。

```bash
mkdir -p ~/.codex
[[ -e ~/.codex/config.toml && ! -L ~/.codex/config.toml ]] && mv ~/.codex/config.toml ~/.dot-backup/
[[ -L ~/.codex/config.toml ]] && rm ~/.codex/config.toml
cp "$DOT_DIR/codex/config.toml" ~/.codex/config.toml
cp "$DOT_DIR/codex/hooks.json" ~/.codex/hooks.json

if [[ ! -f ~/.codex/auth.json ]]; then
  cp "$DOT_DIR/codex/auth.json.example" ~/.codex/auth.json
  chmod 600 ~/.codex/auth.json
fi
```

#### [手动] 编辑认证文件，填入 OpenAI API key

打开 `~/.codex/auth.json`，将 `your-api-key-here` 替换为你的真实 OpenAI API key（以 `sk-` 开头）。

```bash
vim ~/.codex/auth.json
```

#### [检查] 确认文件和认证文件权限正确

```bash
ls -la ~/.codex/config.toml ~/.codex/hooks.json ~/.codex/auth.json
stat -c '%a' ~/.codex/auth.json 2>/dev/null || stat -f '%Lp' ~/.codex/auth.json
```

---

## 安装 OpenCode

### Step 1: 安装 OpenCode CLI

#### [自动] 通过 npm 安装

```bash
npm install -g opencode-ai
```

#### [检查] 确认已安装

```bash
opencode --version
```

### Step 2: 配置 OpenCode

#### [自动] 创建目录并复制配置文件

```bash
mkdir -p ~/.config/opencode
for f in opencode.json oh-my-opencode-slim.json; do
  [[ -e ~/.config/opencode/$f && ! -L ~/.config/opencode/$f ]] && mv ~/.config/opencode/$f ~/.dot-backup/
  [[ -L ~/.config/opencode/$f ]] && rm ~/.config/opencode/$f
done
cp "$DOT_DIR/opencode/opencode.json"             ~/.config/opencode/opencode.json
cp "$DOT_DIR/opencode/oh-my-opencode-slim.json"  ~/.config/opencode/oh-my-opencode-slim.json
```

#### [手动] 修改 opencode.json 中的服务地址和 API key

`~/.config/opencode/opencode.json` 中的 `baseURL` 和 `apiKey` 是占位符，请按实际服务配置替换：

- `provider.anthropic.options.baseURL` 默认是 `https://your-api-endpoint/v1`
- `provider.openai.options.baseURL` 默认是 `https://your-api-endpoint/`
- `provider.anthropic.options.apiKey` 默认是 `sk-xxxxxxxxxx`
- `provider.openai.options.apiKey` 默认是 `sk-xxxxxxxxxx`

请将 `your-api-endpoint` 替换为你的实际服务地址，并将 `sk-xxxxxxxxxx` 替换为真实 API key。不要将真实 API key 提交到仓库。
如果由 Agent 执行安装，规划时确认服务地址和认证方式；最终计划批准后，由用户在本机填写真实 API key，不粘贴到聊天或问答工具中。Agent 等待完成回复，再检查文件权限，不读取密钥值。包含真实 API key 的配置应设置为 `600`：

```bash
chmod 600 ~/.config/opencode/opencode.json
```

#### [自动] 安装 oh-my-opencode-slim 插件

```bash
npx oh-my-opencode-slim@latest install
```

> 如果已安装 bun，也可用 `bunx oh-my-opencode-slim@latest install` 替代。

#### [检查] 确认文件和插件安装成功

```bash
ls -la ~/.config/opencode/opencode.json ~/.config/opencode/oh-my-opencode-slim.json
```

### Step 3: OpenCode 授权

#### [手动] 执行授权命令

```bash
opencode auth
```

请完成以下授权与配置：
- GitHub 授权
- 填写 OpenAI Key 与 Claude Key

---

## 可选工具

| 工具 | macOS | Ubuntu / Debian | Arch / Manjaro | 说明 |
|------|-------|-----------------|----------------|------|
| conda (miniconda) | `brew install --cask miniconda` | [官方安装脚本](https://docs.conda.io/en/latest/miniconda.html) | [官方安装脚本](https://docs.conda.io/en/latest/miniconda.html) | Python 环境管理 |
| rust / cargo | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | 同左 | 同左 | Rust 工具链 |
| fzf | `brew install fzf` | `sudo apt install fzf` | `sudo pacman -S fzf` | tmux-agent-status target switcher |
| docker | `brew install --cask docker` | [官方文档](https://docs.docker.com/engine/install/) | `sudo pacman -S docker` | 容器 |

## 密钥管理

所有密钥通过独立文件管理，不进入 git：

- `~/.secrets.zsh` — Shell 环境变量（ANTHROPIC_BASE_URL, ANTHROPIC_AUTH_TOKEN 等）
- `~/.codex/auth.json` — Codex API key

模板文件：
- `shell/secrets.zsh.example`
- `codex/auth.json.example`

## 目录结构

```
dot/
├── .gitignore
├── README.md              # AI 安装入口与组件安装步骤
├── AGENTS.md              # 统一规划、提问、批准与执行规则
├── CLAUDE.md              # Claude Code 入口，引用统一规则
├── shell/
│   ├── zshrc              # Zsh 主配置
│   ├── p10k.zsh           # Powerlevel10k 主题配置
│   └── secrets.zsh.example
├── tmux/
│   └── tmux.conf
├── claude/
│   ├── settings.json
│   └── settings.local.json
├── codex/
│   ├── config.toml
│   └── auth.json.example
├── skills/
│   └── README.md           # Agent skills 来源和安装说明
└── opencode/
    ├── opencode.json
    └── oh-my-opencode-slim.json
```
