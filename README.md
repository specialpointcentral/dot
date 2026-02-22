# Dotfiles

个人开发环境配置文件，支持快速恢复到新机器。

## 包含内容

| 工具 | 配置文件 | 说明 |
|------|---------|------|
| zsh + oh-my-zsh + p10k | `shell/` | Shell 配置，主题，插件 |
| tmux | `tmux/tmux.conf` | 终端复用器配置 |
| neovim | 见下方单独说明 | LazyVim starter |
| claude | `claude/` | Claude CLI 设置 |
| codex | `codex/` | Codex CLI 设置 |
| opencode | `opencode/` | OpenCode + oh-my-opencode 设置 |

## 快速开始

```bash
git clone <your-repo-url> ~/dot
cd ~/dot
chmod +x install.sh
./install.sh          # 执行安装（自动备份已有文件）
./install.sh --dry-run  # 预览，不做任何修改
```

安装后编辑密钥文件：
```bash
vim ~/.secrets.zsh       # Shell 环境变量（API keys）
vim ~/.codex/auth.json   # Codex API key
```

## 工具安装指南

### 基础工具

| 工具 | macOS (Homebrew) | Ubuntu/Debian | 说明 |
|------|-----------------|---------------|------|
| Homebrew | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` | — | macOS 包管理器 |
| git | `brew install git` | `sudo apt install git` | 版本控制 |
| curl / wget | 系统自带 | `sudo apt install curl wget` | 下载工具 |

### Shell 环境

| 工具 | macOS | Ubuntu/Debian | 说明 |
|------|-------|---------------|------|
| zsh | `brew install zsh` | `sudo apt install zsh` | Shell |
| oh-my-zsh | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` | 同左 | Zsh 框架 |
| powerlevel10k | `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k` | 同左 | Zsh 主题 |
| zsh-autosuggestions | `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions` | 同左 | 自动补全插件 |
| zsh-syntax-highlighting | `git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting` | 同左 | 语法高亮插件 |

### 终端工具

| 工具 | macOS | Ubuntu/Debian | 说明 |
|------|-------|---------------|------|
| tmux | `brew install tmux` | `sudo apt install tmux` | 终端复用器 |
| neovim | `brew install neovim` | `sudo apt install neovim` 或 [从 release 安装](https://github.com/neovim/neovim/releases) | 编辑器 |

### Neovim 配置（LazyVim）

```bash
# 备份已有配置（如果有）
mv ~/.config/nvim ~/.config/nvim.bak

# 克隆 LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# 删除 .git 以便自行管理
rm -rf ~/.config/nvim/.git

# 启动 nvim，LazyVim 会自动安装插件
nvim
```

### Node.js 环境

| 工具 | 安装命令 | 说明 |
|------|---------|------|
| nvm | `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh \| bash` | Node 版本管理 |
| node | `nvm install --lts` | 安装最新 LTS 版本 |

### AI 工具

| 工具 | 安装命令 | 说明 |
|------|---------|------|
| claude | `npm install -g @anthropic-ai/claude-code` | Claude CLI |
| codex | `npm install -g @openai/codex` | OpenAI Codex CLI |
| opencode | `npm install -g opencode-ai` | OpenCode CLI |

### 可选工具

| 工具 | macOS | Ubuntu/Debian | 说明 |
|------|-------|---------------|------|
| conda (miniconda) | `brew install --cask miniconda` | [官方安装脚本](https://docs.conda.io/en/latest/miniconda.html) | Python 环境管理 |
| rust / cargo | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | 同左 | Rust 工具链 |
| docker | `brew install --cask docker` | [官方文档](https://docs.docker.com/engine/install/) | 容器 |

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
├── README.md
├── AGENTS.md              # 环境恢复 Playbook（人/Agent 两用）
├── install.sh             # 符号链接安装脚本
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
    └── oh-my-opencode.json
```
