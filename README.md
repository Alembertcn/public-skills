# public-skills

**个人对外公开的 Cursor Agent Skills 合集** — 供第三方开发者、合作方或新项目使用。

内容不限于 API 集成，也可包含：公开产品指南、SDK 用法、联调手册、对外协议说明等。  
**集成（integration）只是其中一类**，见各 skill 的 `meta.yaml` → `category`。

私有主仓库（如 `jeecg`）继续放源码与运维；**本仓只放可以公开的部分**。

## 放什么 / 不放什么

| 放这里 | 不放这里 |
|--------|----------|
| 对外 API、SDK、集成 skill | 服务端源码、未公开业务逻辑 |
| 公开联调示例、错误码 | NAS / 内网部署、密钥 |
| 第三方能独立使用的指南 | Keycloak、运营后台内部流程 |

## 目录结构

```text
public-skills/
├── catalog.yaml              # 技能索引
├── skills/
│   ├── _template/            # 新 skill 模板
│   └── <skill-id>/           # 每个 skill 一个目录
│       ├── meta.yaml         # 元数据（category、endpoint、版本）
│       ├── SKILL.md          # 必需
│       ├── reference.md      # 可选
│       └── examples.md       # 可选
├── scripts/
│   ├── install.sh
│   └── install.ps1
└── docs/
    └── cursor-setup.md
```

## Skill 分类（category）

| category | 说明 | 示例 |
|----------|------|------|
| `integration` | 第三方接入 API / SDK | `license-service` |
| `guide` | 公开产品/平台使用指南 | （待增） |
| `tooling` | 对外工具、CLI | （待增） |

在 `catalog.yaml` 与 `meta.yaml` 中标注，便于检索。

## 安装（Cursor）

```bash
git clone https://github.com/Alembertcn/public-skills.git
cd public-skills
./scripts/install.sh                  # 全部
./scripts/install.sh license-service  # 指定 id
```

Windows: `.\scripts\install.ps1 -Skill license-service`

详见 [docs/cursor-setup.md](docs/cursor-setup.md)。

## 已有 Skills

见 [catalog.yaml](catalog.yaml)。

| ID | 分类 | 说明 |
|----|------|------|
| `license-service` | integration | 激活码授权 activate / check |

## 新增 Skill

1. 复制 `skills/_template/` → `skills/<skill-id>/`
2. 填写 `meta.yaml`（含 `category`）与 `SKILL.md`
3. 登记 [catalog.yaml](catalog.yaml)
4. 见 [CONTRIBUTING.md](CONTRIBUTING.md)

## 与私有仓库

```text
私有 jeecg（或其它项目）     公开 public-skills
├── 源码 / 运维        ──提炼──►  skills/<id>/
└── .cursor/skills/内部版          第三方 clone 即用
```

私有仓变更后，将**可公开**部分同步 PR 到本仓。
