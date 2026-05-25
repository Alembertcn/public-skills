# integration-skills

**对外公开的 Cursor Agent Skills 合集** — 帮助第三方（或内部新项目）快速集成各服务的 API / SDK。

与私有主仓库（如 `jeecg`）分离：主仓放源码与运维；本仓只放**集成方需要知道的事**。

## 仓库定位

| 放这里 | 不放这里 |
|--------|----------|
| 客户端 API / SDK 集成 skill | 服务端源码、NAS 部署脚本 |
| curl / 多语言示例 | Keycloak、内网地址、密钥 |
| 错误码、联调清单 | 运营后台操作细节 |

后续每上线一个新对外服务，在本仓 `skills/<服务名>/` 增加一个 skill 即可。

## 目录结构

```text
integration-skills/
├── catalog.yaml              # 技能索引（机器可读）
├── skills/
│   ├── _template/            # 新 skill 模板
│   └── <service-id>/         # 每个服务一个目录
│       ├── meta.yaml         # 元数据（endpoint、标签、版本）
│       ├── SKILL.md          # Cursor skill 主文件（必需）
│       ├── reference.md      # API 参考（可选）
│       └── examples.md       # 示例（可选）
├── scripts/
│   ├── install.sh            # 安装到 ~/.cursor/skills
│   └── install.ps1
└── docs/
    └── cursor-setup.md       # Cursor 使用说明
```

## 快速安装（Cursor）

### 安装全部 skills

```bash
git clone https://github.com/<your-org>/integration-skills.git
cd integration-skills
./scripts/install.sh
# Windows: .\scripts\install.ps1
```

默认安装到 `~/.cursor/skills/`（用户级，所有项目可用）。

### 只安装某一个

```bash
./scripts/install.sh license-service
# Windows: .\scripts\install.ps1 -Skill license-service
```

### 项目级安装（团队共享）

```bash
git submodule add https://github.com/<your-org>/integration-skills.git .cursor/integration-skills
ln -s ../../integration-skills/skills/license-service .cursor/skills/license-service
```

## 已有 Skills

见 [catalog.yaml](catalog.yaml)。

| ID | 说明 |
|----|------|
| `license-service` | 激活码授权：activate / check、设备/账号绑定 |

## 新增一个 Skill

1. 复制 `skills/_template/` → `skills/<service-id>/`
2. 填写 `meta.yaml` 与 `SKILL.md`（见 [CONTRIBUTING.md](CONTRIBUTING.md)）
3. 在 `catalog.yaml` 登记
4. PR 合并

## 与私有仓库的关系

```text
私有 jeecg                         公开 integration-skills
├── license-service/  ──提炼──►   skills/license-service/
├── 部署 / Keycloak                 （无运维内容）
└── .cursor/skills/（内部）         第三方 clone 本仓即可
```

私有仓 skill 变更时，同步 PR 到本仓对应目录（只拷集成相关文件）。

## License

各 skill 文档随服务协议；代码示例 MIT（如目录内无另行说明）。
