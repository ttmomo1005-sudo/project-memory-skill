---
name: project-memory
description: >-
  Autonomously maintains a per-project long-term memory file (PROJECT_MEMORY.md)
  so long or multi-session tasks survive context compaction and model switches.
  Reads it at session start, updates it after milestones, design decisions,
  user corrections, discovered pitfalls, or when context grows large, and writes
  handoff documents on request. Use in any project that has PROJECT_MEMORY.md,
  when starting a long multi-step task in a new project, or when the user
  mentions 记忆库, 项目记忆, 上下文, 整理文档, 交接, handoff, 换模型, 续聊.
---

# Project Memory（全自动记忆库）

用户偏好：**自动整理文档、更新记忆库，不要等用户提醒；全自主。**

## 涉及的文件

| 文件 | 位置 | 作用 |
|------|------|------|
| `PROJECT_MEMORY.md` | 工作区根目录 | 权威记忆，续聊/换模型时先读它 |
| `.cursor/rules/project-memory.mdc` | 工作区 | alwaysApply 规则，保证每次对话都会读记忆 |
| `HANDOFF_<主题>.md` | 工作区根目录 | 可选，交接给其它模型时写 |

## 工作流程

1. **开场**：工作区有 `PROJECT_MEMORY.md` 就先读，再做实质改动。
2. **没有记忆文件**：任务是多步骤 / 会持续多轮时，直接初始化（见下节），不用征求同意。一次性的小问题不需要。
3. **更新时机**（满足任一就更新，不等提醒）：
   - 完成里程碑：新功能、新页面 / 接口、路径或启动方式变化
   - 出现有意设计：锁定行为、模式开关、默认值、技术选型
   - 用户纠正了重要事实，或任务方向改变
   - 踩到坑：环境、编码、端口、依赖等问题及其解法
   - 对话很长、上下文占用约 70% 以上，或刚发生过上下文压缩（出现了对话摘要）
   - 一轮里做了较多改动、准备结束回复之前
4. **怎么更新**：原地编辑，不整篇重写；刷新「最后更新」和「当前阶段」两行；删除过时内容或标 `[废弃]`。
5. **因上下文压力而更新后**：再读一遍记忆文件，然后继续原任务。
6. **告知方式**：不问"要不要记一下"；在回复末尾一句话带过即可，例如"已同步更新记忆库"。

## 初始化新项目

运行脚本（只用 ASCII 参数也可以，项目名可以是中文）：

```powershell
powershell -ExecutionPolicy Bypass -File "<本技能目录>/scripts/init_memory.ps1" -ProjectRoot "<项目根目录>" -ProjectName "<项目名>"
```

- 生成 `PROJECT_MEMORY.md` 和 `.cursor/rules/project-memory.mdc`
- 已存在的文件会跳过；加 `-Force` 才覆盖
- 生成后立刻根据当前对话填写第 1–4 节

脚本跑不了时，手动复制 `templates/` 下两个模板，替换 `{{PROJECT_NAME}}` 和 `{{DATE}}`。

## 交接文档（换模型 / 交给别人）

用户要求"总结给另一个模型"时：

1. 按 [templates/HANDOFF.template.md](templates/HANDOFF.template.md) 写 `HANDOFF_<主题>.md`
2. 必须包含：任务目标、当前进度、**所有相关文件的完整路径及作用**、启动步骤、已定决策、踩坑记录、按优先级排列的下一步
3. 用户不希望动原文件时，加入"复制出 `_v2` 副本再迭代"的方案：副本放哪、要改哪些端口 / 路径、怎么同时运行对比
4. 在 `PROJECT_MEMORY.md` 头部链接这份交接文档

## 写作规则

- 用用户的语言（中文用户就写中文短句）
- 只保留仍然有效的事实
- 路径写完整、可直接复制
- 不贴大段代码，只写函数名 / 变量名 / 位置
- 踩坑一行写清：现象 → 原因 → 解法
- **不写密钥、密码、token**
- 控制在约 250 行内；细节太多就挪到交接文档或 `docs/`

## 附带资源

- [templates/PROJECT_MEMORY.template.md](templates/PROJECT_MEMORY.template.md)：记忆文件模板
- [templates/project-memory.mdc](templates/project-memory.mdc)：项目规则模板
- [templates/HANDOFF.template.md](templates/HANDOFF.template.md)：交接文档模板
- [reference.md](reference.md)：全局"用户规则"文本、条目写法示例、判断技巧
