# agent-browser 安装说明

来源仓库：

```text
https://github.com/vercel-labs/agent-browser.git
```

适用场景：

- 打开网页、点击按钮、填写表单、截图、抓取页面内容。
- 测试本地 Web app。
- 自动化部分 Electron 应用。

这个 skill 需要两部分：全局 `agent-browser` CLI，以及 skill 定义文件。

## 安装前先确认

Agent 在安装前必须先向用户确认：

1. 是否安装全局 `agent-browser` CLI。
2. 是否只安装到 `~/.agents/skills`，还是同时兼容 Claude Code / Codex。

默认建议安装，因为它是通用浏览器自动化能力，但不要代替用户登录网站或输入敏感凭据。

## 安装步骤

创建统一落点：

```bash
mkdir -p ~/.agents/skills
```

安装全局 CLI：

```bash
npm install -g agent-browser
agent-browser install
```

安装 skill 定义：

```bash
git clone https://github.com/vercel-labs/agent-browser.git /tmp/agent-browser-skills
mkdir -p ~/.agents/skills/agent-browser
cp /tmp/agent-browser-skills/skills/agent-browser/SKILL.md ~/.agents/skills/agent-browser/SKILL.md
```

## Claude Code / Codex 兼容处理

如果目标客户端不直接读取 `~/.agents/skills`，创建链接：

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
ln -snf ~/.agents/skills/agent-browser ~/.claude/skills/agent-browser
ln -snf ~/.agents/skills/agent-browser ~/.codex/skills/agent-browser
```

只为用户要求兼容的客户端创建链接。

## 验证

```bash
agent-browser --help
test -f ~/.agents/skills/agent-browser/SKILL.md
```

如果创建了 Claude Code / Codex 兼容链接：

```bash
test -f ~/.claude/skills/agent-browser/SKILL.md
test -f ~/.codex/skills/agent-browser/SKILL.md
```

## Agent 注意事项

- 安装 skill 定义不等于 CLI 可用，必须验证 `agent-browser --help`。
- 如果 `npm install -g` 因网络、权限或 Node 环境失败，先确认当前 Node/npm 来源，再重试。
- 不要在没有用户明确授权的情况下使用 browser automation 输入密码、token 或其它敏感信息。
