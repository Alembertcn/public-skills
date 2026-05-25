# 在 Cursor 中使用 public-skills

本仓库是**个人对外公开的 Skills 合集**（含 integration、guide 等）。安装方式相同。

## 用户级（推荐）

```bash
git clone https://github.com/<your-org>/public-skills.git
cd public-skills
./scripts/install.sh
./scripts/install.sh license-service
```

目标目录：`~/.cursor/skills/<skill-id>/`

Windows:

```powershell
.\scripts\install.ps1
.\scripts\install.ps1 -Skill license-service
```

## 项目级（子模块）

```bash
git submodule add https://github.com/<your-org>/public-skills.git .cursor/public-skills
ln -sf ../public-skills/skills/license-service .cursor/skills/license-service
```

## 验证

向 Agent 提问与某 skill 的 `description` 相关的问题，确认其加载对应 SKILL.md。

## 更新

```bash
git pull && ./scripts/install.sh
```
