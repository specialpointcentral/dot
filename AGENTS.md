# Environment Setup Playbook

这是一份环境恢复指南，人和 AI Agent 都能按步骤执行。

每个步骤标注了：
- `[手动]` — 需要人工操作（如输入密码、确认安装）
- `[自动]` — 可以直接执行命令
- `[检查]` — 验证步骤是否成功

---

## Phase 1: 基础环境

### Step 1.1 — 包管理器

**macOS:**
```bash
# [手动] 安装 Homebrew（需要输入密码）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Linux (Ubuntu/Debian):**
```bash
# [自动]
sudo apt update && sudo apt upgrade -y
```

```bash
# [检查] 验证
brew --version   # macOS
apt --version    # Linux
```

### Step 1.2 — Git

```bash
# [自动]
brew install git        # macOS
# sudo apt install git  # Linux
```

```bash
# [检查]
git --version
```

### Step 1.3 — 克隆 dotfiles

```bash
# [自动]
git clone <your-repo-url> ~/dot
```

---

## Phase 2: Shell 环境

### Step 2.1 — Zsh

```bash
# [自动]
brew install zsh        # macOS
# sudo apt install zsh  # Linux
```

```bash
# [手动] 设为默认 shell（需要输入密码）
chsh -s $(which zsh)
```

```bash
# [检查]
echo $SHELL  # 应该显示 /bin/zsh 或 /usr/bin/zsh
```

### Step 2.2 — Oh My Zsh

```bash
# [手动] 安装（会提示是否切换默认 shell）
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Step 2.3 — Zsh 插件和主题

```bash
# [自动] Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# [自动] zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# [自动] zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

```bash
# [检查]
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k/
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/
```

### Step 2.4 — 链接 Shell 配置

```bash
# [自动]
cd ~/dot && ./install.sh
```

### Step 2.5 — 配置密钥

```bash
# [手动] 编辑密钥文件，填入真实的 API keys
vim ~/.secrets.zsh
```

```bash
# [检查] 重新加载 shell，确认无报错
source ~/.zshrc
echo $ANTHROPIC_BASE_URL  # 应该有值
```

---

## Phase 3: 终端工具

### Step 3.1 — Tmux

```bash
# [自动]
brew install tmux        # macOS
# sudo apt install tmux  # Linux
```

```bash
# [检查] install.sh 已经链接了 tmux.conf
tmux -V
tmux new -s test    # 启动测试，Ctrl-a d 退出
```

### Step 3.2 — Neovim + LazyVim

```bash
# [自动]
brew install neovim        # macOS
# sudo apt install neovim  # Linux（或从 GitHub release 安装最新版）
```

```bash
# [自动] 克隆 LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

```bash
# [手动] 首次启动，LazyVim 自动安装插件（需要等待）
nvim
```

```bash
# [检查]
nvim --version
```

---

## Phase 4: Node.js 环境

### Step 4.1 — NVM + Node

```bash
# [自动]
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

```bash
# [自动] 重新加载 shell 后
source ~/.zshrc
nvm install --lts
```

```bash
# [检查]
node --version
npm --version
```

---

## Phase 5: AI 工具

### Step 5.1 — Claude CLI

```bash
# [自动]
npm install -g @anthropic-ai/claude-code
```

```bash
# [手动] install.sh 已链接配置，但需要配置密钥
vim ~/.codex/auth.json
```

```bash
# [检查]
claude --version
```

### Step 5.2 — Codex CLI

```bash
# [自动]
npm install -g @openai/codex
```

```bash
# [检查]
codex --version
```

### Step 5.3 — OpenCode

```bash
# [自动]
npm install -g opencode-ai
```

```bash
# [自动] 安装 oh-my-opencode-slim 插件
bunx oh-my-opencode-slim@latest install
```

```bash
# [检查]
opencode --version
```

---

## Phase 6: 可选工具

### Step 6.1 — Conda (Python 环境管理)

```bash
# macOS
brew install --cask miniconda

# Linux
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

### Step 6.2 — Rust

```bash
# [手动] 安装（有交互式选项）
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Step 6.3 — Docker

```bash
# macOS
brew install --cask docker

# Linux: 参考 https://docs.docker.com/engine/install/
```

---

## 完成检查清单

执行完所有步骤后，逐项验证：

```bash
# [检查] 所有工具版本
zsh --version
tmux -V
nvim --version
node --version
nvm --version
git --version
claude --version 2>/dev/null || echo "claude not installed"
codex --version 2>/dev/null || echo "codex not installed"
```

```bash
# [检查] 配置文件链接正确
ls -la ~/.zshrc        # -> ~/dot/shell/zshrc
ls -la ~/.tmux.conf    # -> ~/dot/tmux/tmux.conf
ls -la ~/.p10k.zsh     # -> ~/dot/shell/p10k.zsh
```

```bash
# [检查] 密钥已配置
[[ -f ~/.secrets.zsh ]] && echo "secrets.zsh OK" || echo "MISSING: ~/.secrets.zsh"
[[ -f ~/.codex/auth.json ]] && echo "codex auth OK" || echo "MISSING: ~/.codex/auth.json"
```
