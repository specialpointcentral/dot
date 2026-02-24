# Dotfiles

个人开发环境配置文件，支持快速恢复到新机器。本文件是手动安装的标准指南。

每个 Step 按三类操作分块：

- **`[自动]`** — 可直接执行的命令，无需人工干预
- **`[手动]`** — 需要人工交互（输入密码、编辑密钥等），不可由脚本自动完成
- **`[检查]`** — 验证该步骤是否成功的命令

假定你已位于 dot 仓库根目录。先记录当前目录路径：

```bash
DOT_DIR="$(pwd)"
```

按以下章节从头完成环境搭建和配置部署。

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

#### [自动] 备份已有配置并复制文件

以下命令会将已有的 Shell 配置文件备份到 `~/.dot-backup/`，然后从仓库复制新的配置文件到目标位置。

```bash
mkdir -p ~/.dot-backup
for f in ~/.zshrc ~/.zshenv ~/.zprofile ~/.p10k.zsh; do
  [[ -e "$f" && ! -L "$f" ]] && mv "$f" ~/.dot-backup/
  [[ -L "$f" ]] && rm "$f"
done

cp "$DOT_DIR/shell/zshrc"    ~/.zshrc
cp "$DOT_DIR/shell/zshenv"   ~/.zshenv
cp "$DOT_DIR/shell/zprofile" ~/.zprofile
cp "$DOT_DIR/shell/p10k.zsh" ~/.p10k.zsh
```

#### [检查] 确认文件已就位

```bash
ls -la ~/.zshrc ~/.zshenv ~/.zprofile ~/.p10k.zsh
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

##### Agent 协助填写

如果由 AI Agent 执行本步骤，采用以下流程：

1. Agent 向用户逐一询问所需字段的值：
   - `ANTHROPIC_BASE_URL`
   - `ANTHROPIC_AUTH_TOKEN`
2. 用户回复后，Agent 将值写入 `~/.secrets.zsh`
3. **安全要求**：Agent 不得在终端输出、对话回复中显示密钥明文；写入时使用 `chmod 600` 确保权限

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

#### [自动] 备份已有配置并复制文件

```bash
mkdir -p ~/.dot-backup
[[ -e ~/.tmux.conf && ! -L ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.dot-backup/
[[ -L ~/.tmux.conf ]] && rm ~/.tmux.conf
cp "$DOT_DIR/tmux/tmux.conf" ~/.tmux.conf
```

#### [检查] 确认文件已就位

```bash
ls -la ~/.tmux.conf
```

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

创建 `~/.codex` 目录，复制 `config.toml` 配置文件。如果 `auth.json` 不存在，从模板复制并设置 `600` 权限。

```bash
mkdir -p ~/.codex
[[ -e ~/.codex/config.toml && ! -L ~/.codex/config.toml ]] && mv ~/.codex/config.toml ~/.dot-backup/
[[ -L ~/.codex/config.toml ]] && rm ~/.codex/config.toml
cp "$DOT_DIR/codex/config.toml" ~/.codex/config.toml

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
ls -la ~/.codex/config.toml ~/.codex/auth.json
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

#### [自动] 安装 oh-my-opencode-slim 插件

```bash
npx oh-my-opencode-slim@latest install
```

> 如果已安装 bun，也可用 `bunx oh-my-opencode-slim@latest install` 替代。

#### [检查] 确认文件和插件安装成功

```bash
ls -la ~/.config/opencode/opencode.json ~/.config/opencode/oh-my-opencode-slim.json
```

---

## 可选工具

| 工具 | macOS | Ubuntu / Debian | Arch / Manjaro | 说明 |
|------|-------|-----------------|----------------|------|
| conda (miniconda) | `brew install --cask miniconda` | [官方安装脚本](https://docs.conda.io/en/latest/miniconda.html) | [官方安装脚本](https://docs.conda.io/en/latest/miniconda.html) | Python 环境管理 |
| rust / cargo | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | 同左 | 同左 | Rust 工具链 |
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
├── README.md              # 手动安装标准指南
├── AGENTS.md              # AI Agent 执行指引
├── shell/
│   ├── zshrc              # Zsh 主配置
│   ├── zshenv             # Zsh 环境变量
│   ├── zprofile           # Zsh profile
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
└── opencode/
    ├── opencode.json
    └── oh-my-opencode-slim.json
```
