# AI-Research-SKILLs 安装说明

来源仓库：

```text
https://github.com/Orchestra-Research/AI-Research-SKILLs
```

这个仓库不是单个 skill，而是一整套 AI research skill library。上游 README 当前宣称包含 98 个 skills、23 个分类，并提供 `@orchestra-research/ai-research-skills` 交互式安装器。安装前必须先读本文件，不要按普通单 skill 的方式直接复制全部内容。

## 安装前先确认

Agent 在安装前必须先向用户确认：

1. 是否真的要安装这套复杂 skill library，还是只需要其中一个分类或几个具体 skills。
2. 要安装到哪些客户端：仅共享目录、Claude Code、Codex，或同时兼容多个客户端。
3. 是否允许使用上游安装器创建它自己的统一目录 `~/.orchestra/skills/`。

默认建议：

- 不要默认安装全部 skills。
- 优先按分类或单个 skill 安装。
- 如果用户没有明确要求统一交给上游管理，继续沿用本仓库约定的 `~/.agents/skills`。

## 推荐安装方式：使用上游交互式安装器

适合用户愿意接受上游目录结构和交互式选择时使用。

```bash
npx @orchestra-research/ai-research-skills
```

上游安装器会：

- 检测已安装的 coding agents。
- 让用户选择全部安装、快速开始、按分类安装或按单个 skill 安装。
- 默认把 canonical copy 放到 `~/.orchestra/skills/`。
- 为 Claude Code、OpenCode、Codex、Cursor、Gemini CLI 等客户端创建链接或副本。

注意：这条路径和本仓库通常使用的 `~/.agents/skills` 统一落点不同。只有用户接受 `~/.orchestra/skills` 作为上游管理目录时，才使用这个方式。

常用命令：

```bash
npx @orchestra-research/ai-research-skills list
npx @orchestra-research/ai-research-skills update
npx @orchestra-research/ai-research-skills install --all
npx @orchestra-research/ai-research-skills install post-training
```

`install --all` 只有在用户明确要求安装全部时才运行。

## 保守安装方式：只复制选中的 skill

适合希望继续使用 `~/.agents/skills` 作为统一落点，或者只想安装少数 skills 的情况。

先克隆到临时目录：

```bash
git clone --depth 1 https://github.com/Orchestra-Research/AI-Research-SKILLs.git /tmp/ai-research-skills
mkdir -p ~/.agents/skills
```

然后只复制用户明确选择的 skill 目录。目录必须是包含 `SKILL.md` 的那一层。

示例：只安装论文写作和学术绘图：

```bash
cp -R /tmp/ai-research-skills/20-ml-paper-writing/ml-paper-writing ~/.agents/skills/ml-paper-writing
cp -R /tmp/ai-research-skills/20-ml-paper-writing/academic-plotting ~/.agents/skills/academic-plotting
```

示例：只安装 autonomous research orchestration：

```bash
cp -R /tmp/ai-research-skills/0-autoresearch-skill ~/.agents/skills/autoresearch
```

示例：只安装 post-training 中的 GRPO 和 verl：

```bash
cp -R /tmp/ai-research-skills/06-post-training/grpo-rl-training ~/.agents/skills/grpo-rl-training
cp -R /tmp/ai-research-skills/06-post-training/verl ~/.agents/skills/verl
```

如果需要兼容 Claude Code / Codex，再为已安装的 skills 创建链接：

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
ln -snf ~/.agents/skills/ml-paper-writing ~/.claude/skills/ml-paper-writing
ln -snf ~/.agents/skills/ml-paper-writing ~/.codex/skills/ml-paper-writing
```

只给实际安装的 skill 建链接，不要把整个上游仓库直接链接到客户端 skills 目录。

## 分类参考

上游当前主要分类包括：

| 分类 | 适用场景 |
|---|---|
| `autoresearch` | 自主研究编排、长期研究任务、自动路由到其它 skills |
| `ml-paper-writing` | ML / AI / Systems 论文写作、LaTeX、引用检查、学术绘图 |
| `ideation` | 研究选题、头脑风暴、提出新方向 |
| `model-architecture` | LitGPT、Mamba、NanoGPT、RWKV、TorchTitan 等模型架构 |
| `fine-tuning` | Axolotl、LLaMA-Factory、PEFT、Unsloth 等微调 |
| `post-training` | TRL、GRPO、OpenRLHF、SimPO、verl、slime 等后训练 |
| `distributed-training` | DeepSpeed、FSDP、Megatron、Accelerate、Ray Train 等分布式训练 |
| `optimization` | Flash Attention、bitsandbytes、GPTQ、AWQ、GGUF、HQQ 等优化 |
| `inference-serving` | vLLM、TensorRT-LLM、llama.cpp、SGLang 等推理服务 |
| `evaluation` | lm-evaluation-harness、BigCode、NeMo Evaluator 等评测 |
| `rag` | Chroma、FAISS、Pinecone、Qdrant、Sentence Transformers |
| `agents` | LangChain、LlamaIndex、CrewAI、AutoGPT |
| `multimodal` | CLIP、Whisper、LLaVA、BLIP-2、SAM、Stable Diffusion 等 |

安装前建议先让用户从分类中选择，不要逐个朗读所有 98 个 skills。

## 验证

如果使用上游安装器：

```bash
npx @orchestra-research/ai-research-skills list
find ~/.orchestra/skills -name SKILL.md | wc -l
```

如果使用 `~/.agents/skills` 保守安装：

```bash
find ~/.agents/skills -maxdepth 2 -name SKILL.md | sort
```

如果创建了 Claude Code / Codex 兼容链接：

```bash
find ~/.claude/skills ~/.codex/skills -maxdepth 2 -name SKILL.md | sort
```

## Agent 注意事项

- 不要把上游仓库根目录直接当成一个 skill 安装。
- 不要在未确认的情况下运行 `install --all`。
- 不要混用 `~/.orchestra/skills` 和 `~/.agents/skills` 两套 canonical copy，除非用户明确接受这种结构。
- 如果用户要求“安装 AI-Research-SKILLs”，先读取本文件，再确认安装范围和目标客户端。
- 如果上游 README 和 npm package README 的 skill 数量不一致，以安装器 `list` 的实际输出为准。
