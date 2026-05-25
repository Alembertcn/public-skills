# Cursor 中使用 integration-skills

## 方式一：用户级（推荐）

所有项目自动可用：

```bash
git clone https://github.com/<your-org>/integration-skills.git
cd integration-skills
./scripts/install.sh              # 安装全部
./scripts/install.sh license-service   # 只装一个
```

安装目标：`~/.cursor/skills/<skill-id>/`

重启 Cursor 或新开 Agent 会话后，Agent 会根据 skill 的 `description` 自动匹配。

## 方式二：项目级

仅当前仓库可用，适合团队统一版本：

```bash
# 在项目根目录
git submodule add https://github.com/<your-org>/integration-skills.git .cursor/integration-skills

# 按需链接 skill（示例：license-service）
# Linux/macOS:
ln -sf ../integration-skills/skills/license-service .cursor/skills/license-service

# Windows（管理员或开发者模式）:
# mklink /D .cursor\skills\license-service .cursor\integration-skills\skills\license-service
```

`.gitignore` 若忽略 `.cursor/*`，需保留：

```gitignore
.cursor/*
!.cursor/skills/
!.cursor/skills/**
```

## 方式三：手动复制

复制 `skills/<id>/` 整个目录到：

- 用户级：`~/.cursor/skills/<id>/`
- 项目级：`<project>/.cursor/skills/<id>/`

## 验证

在 Cursor Agent 中提问：

> 帮我集成 license 激活码，endpoint 是 https://license.ailuo.fun/license-service

Agent 应加载 `license-service-integrate` skill 并给出 activate/check 流程。

## 更新

```bash
cd integration-skills && git pull
./scripts/install.sh   # 覆盖安装到 ~/.cursor/skills
```

子模块方式：`git submodule update --remote`
