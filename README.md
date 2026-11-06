# Project Memory Skill · 自动维护项目记忆

让 AI 将长任务的关键进展、设计决策、踩坑解法和下一步写入 `PROJECT_MEMORY.md`，在新对话、上下文压缩或换模型后重新读取，继续工作。

本仓库包含完整技能指令、PowerShell 初始化脚本、Cursor 项目规则以及记忆和交接文档模板。

## 快速开始

下载并解压本仓库，或克隆：

```bash
git clone https://github.com/ttmomo1005-sudo/project-memory-skill.git
```

在 AI 能访问目标项目文件、执行命令的环境中，对 AI 说：

```text
先读取这个包的 INSTALL.md，按文档把 project-memory 安装到当前目标项目。
完成初始化、填写记忆初稿并验证安装后，再开始正式任务。
```

如果安装包与目标项目不同，请同时告诉 AI 目标项目的绝对路径。

## 手动安装到 Cursor

1. 将本仓库的 `project-memory` 整个文件夹复制到目标项目的 `.cursor/skills/project-memory/`。
2. 在 PowerShell 中运行，替换示例路径：

```powershell
powershell -ExecutionPolicy Bypass -File "C:\path\to\project\.cursor\skills\project-memory\scripts\init_memory.ps1" -ProjectRoot "C:\path\to\project" -ProjectName "My Project"
```

3. 请 AI 读取并填写目标项目根目录的 `PROJECT_MEMORY.md`。

初始化脚本会生成 `PROJECT_MEMORY.md` 和 `.cursor/rules/project-memory.mdc`。已有文件默认跳过；仅在明确需要覆盖时使用 `-Force`。

## 何时更新记忆

- 新对话开场：读取已有记忆。
- 完成里程碑、确定方案、用户纠正事实、解决问题：更新关键结论。
- 长对话或上下文压缩前后：保存进度，核对并重新读取记忆。
- 换模型或交接：按模板编写 `HANDOFF_<主题>.md`。

记忆建议保持约 250 行，详细资料放入 `docs/` 或交接文档。不要写入密钥、密码或访问令牌。

## 文件结构

```text
project-memory-skill/
├── README.md
├── INSTALL.md
└── project-memory/
    ├── SKILL.md
    ├── reference.md
    ├── scripts/init_memory.ps1
    └── templates/
        ├── PROJECT_MEMORY.template.md
        ├── project-memory.mdc
        └── HANDOFF.template.md
```

## 适用范围与边界

附带的初始化脚本目前面向 Windows PowerShell 和 Cursor，生成的是 Cursor `.mdc` 规则。其他 AI 工具可以读取技能内容，但需要将常驻指令接入该工具支持的机制；不能假设其他客户端会加载 `.cursor/rules/`。

自动更新依赖 AI 实际加载规则并执行文件读写。它不是后台常驻同步服务，不保存完整对话，也无法保证绝不丢失信息。文档中的约 70% 上下文占用是可见时的参考信号，并非脚本精确计量；没有每 250k token 的定时触发器。

安装步骤见 [INSTALL.md](INSTALL.md)，技能细节见 [SKILL.md](project-memory/SKILL.md)。
