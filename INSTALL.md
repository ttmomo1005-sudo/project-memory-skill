# 项目记忆 · 启用安装说明（给 AI 先执行）

> **给用户**：把本文件夹拷到目标项目旁或项目内，对新对话说：
> 「先读 `INSTALL.md`，按文档把项目记忆装好，装完再开始任务。」
>
> **给 AI**：本文件是强制安装清单。用户让你启用记忆时，**先完整做完下面步骤并回报结果**，再开始任何业务任务。不要只读不装。

---

## 目标

在目标项目中装好「长期项目记忆」，使得：

1. 每次新对话开场先读 `PROJECT_MEMORY.md`
2. 里程碑 / 设计决策 / 踩坑 / 上下文变长时，**主动更新**记忆，不等用户提醒
3. 换模型 / 换会话时仍能从记忆文件恢复关键背景

---

## 路径约定

下文用：

- `{{PACKAGE}}` = 本安装包根目录（含本 `INSTALL.md` 的那一层）
- `{{PROJECT}}` = 用户当前要工作的**项目根目录**（通常是 Cursor 工作区根）

本包内技能本体：

```text
{{PACKAGE}}/project-memory/
├── SKILL.md
├── reference.md
├── scripts/init_memory.ps1
└── templates/
    ├── PROJECT_MEMORY.template.md
    ├── project-memory.mdc
    └── HANDOFF.template.md
```

---

## 安装步骤（按顺序执行）

### Step 1 — 确认项目根目录

- 以 Cursor 当前工作区根目录为 `{{PROJECT}}`
- 若用户另指定了路径，以用户指定为准
- 向用户确认一句：`将在 <绝对路径> 启用项目记忆`

### Step 2 — 安装 skill（供 Agent 发现）

把整个 skill 目录复制到：

```text
{{PROJECT}}/.cursor/skills/project-memory/
```

要求：

- 目标路径下必须有 `SKILL.md`
- 一并复制 `scripts/`、`templates/`、`reference.md`
- 若目标已存在同名 skill：保留已有内容，除非用户要求覆盖

### Step 3 — 初始化记忆文件与 alwaysApply 规则

在 PowerShell 中执行（把路径换成真实绝对路径）：

```powershell
powershell -ExecutionPolicy Bypass -File "{{PACKAGE}}\project-memory\scripts\init_memory.ps1" -ProjectRoot "{{PROJECT}}" -ProjectName "<项目名>"
```

脚本会生成（已存在则跳过，除非加 `-Force`）：

| 文件 | 作用 |
|------|------|
| `{{PROJECT}}/PROJECT_MEMORY.md` | 权威长期记忆 |
| `{{PROJECT}}/.cursor/rules/project-memory.mdc` | alwaysApply 规则，提示 AI 在每轮对话中遵守记忆流程（依赖客户端加载规则） |

脚本失败时的手动兜底：

1. 复制 `templates/PROJECT_MEMORY.template.md` → `{{PROJECT}}/PROJECT_MEMORY.md`
2. 复制 `templates/project-memory.mdc` → `{{PROJECT}}/.cursor/rules/project-memory.mdc`
3. 把模板里的 `{{PROJECT_NAME}}`、`{{DATE}}` 替换成真实项目名和当前日期时间
4. `.mdc` 必须用 **无 BOM 的 UTF-8**（BOM 会破坏 frontmatter）

### Step 4 — 填写记忆初稿

不要留空模板。立刻根据**当前已知信息**填写 `PROJECT_MEMORY.md` 至少：

1. 目标与用户要求
2. 当前进度
3. 关键路径
4. 已定决策 / 已知坑（若有）

并更新顶部的「最后更新」「当前阶段」。

### Step 5 — 自检清单（全部勾上才算完成）

- [ ] `{{PROJECT}}/.cursor/skills/project-memory/SKILL.md` 存在
- [ ] `{{PROJECT}}/PROJECT_MEMORY.md` 存在且已填初稿（不是空模板）
- [ ] `{{PROJECT}}/.cursor/rules/project-memory.mdc` 存在，且含 `alwaysApply: true`
- [ ] 已向用户简短汇报：装好了哪些路径

### Step 6 — 安装完成后再开始任务

自检通过后回复用户一句，例如：

> 项目记忆已启用。之后会自动维护 `PROJECT_MEMORY.md`。可以开始正式任务。

然后才进入用户真正要做的工作。

---

## 启用后的自动行为（装好后必须遵守）

1. **开场**：做实质改动前先读 `PROJECT_MEMORY.md`
2. **自更新**（满足任一即更新，不问“要不要记”）：
   - 完成里程碑（功能 / 接口 / 路径 / 启动方式变化）
   - 出现有意设计（默认值、模式、选型）
   - 用户纠正重要事实，或任务方向改变
   - 踩坑并找到解法
   - 对话很长、上下文约 70%+，或刚发生上下文压缩
3. **因上下文压力更新后**：再读一遍记忆文件，再继续原任务
4. **写作**：只保留仍有效事实；路径可复制；不贴大段代码；**不写密钥**
5. **体量**：尽量控制在约 250 行；细节过多写入 `HANDOFF_<主题>.md` 或 `docs/`
6. **告知**：回复末尾一句话即可，例如「已同步更新记忆库」

换模型 / 交接时：按 `templates/HANDOFF.template.md` 写 `HANDOFF_<主题>.md`，并在 `PROJECT_MEMORY.md` 头部链接它。

更细的写法见：`project-memory/reference.md`

---

## 用户一句话触发示例

把本包放到项目旁或项目内后，直接说：

```text
先读 INSTALL.md，
按文档把项目记忆装到当前工作区，装完再开始任务。
```

或：

```text
按 INSTALL.md 启用 project-memory，然后我们开始做 XXX。
```

---

## 常见误区

| 误区 | 正确做法 |
|------|----------|
| 只读 SKILL.md，不复制、不初始化 | 必须完成 Step 2–5 |
| skill 丢在随便一个子目录 | 必须在 `.cursor/skills/project-memory/` |
| 只有 `PROJECT_MEMORY.md`，没有 alwaysApply 规则 | 新对话不一定会自动读/写 |
| 以为“读一次说明就永久生效” | 自动行为靠已安装的 rule + 记忆文件 |
| 把密钥写进记忆 | 禁止 |

---

## 可选：全局用户规则（多项目常驻）

若希望所有项目都更稳，可在 Cursor → Settings → Rules → User Rules 追加：

```text
长任务自动维护项目记忆：工作区根目录有 PROJECT_MEMORY.md 时，开场先读；
完成里程碑、出现有意设计、用户纠正事实、踩坑、或上下文很长时，主动更新它，
不要等我提醒。多步骤的新项目若没有该文件，按 project-memory 技能直接初始化。
不要把密钥写进去。
```

有项目级 `.cursor/rules/project-memory.mdc` 时，以上为加强项，不是替代。
