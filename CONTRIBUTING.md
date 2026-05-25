# 贡献指南

## 何时在本仓新增 skill

- 有一个**对外暴露 API/SDK** 的服务，第三方或新项目需要集成
- 集成知识不适合放在私有主仓（或主仓为 private）

## 命名规范

| 项 | 规则 | 示例 |
|----|------|------|
| 目录名 `service-id` | 小写、连字符、与产品/API 一致 | `license-service`, `payment-gateway` |
| `SKILL.md` frontmatter `name` | 同目录名或语义化 | `license-service-integrate` |
| `meta.yaml` `id` | 与目录名一致 | `license-service` |

## 每个 skill 最少包含

```
skills/<service-id>/
├── meta.yaml       # 必填
└── SKILL.md        # 必填
```

可选：`reference.md`、`examples.md`、`scripts/`（仅集成侧工具，无密钥）。

## meta.yaml 模板

```yaml
id: my-service
name: My Service 集成
version: "1.0.0"
tags: [api, webhook]
public_api: true
default_endpoint: https://api.example.com
docs_url: https://docs.example.com
sdk:
  npm: "@org/my-sdk"    # 可选
  maven: "com.org:my-sdk" # 可选
maintainer: your-team
```

## SKILL.md 写作要点

1. **description**（YAML）：第三人称，写清 WHAT + WHEN，便于 Agent 自动匹配
2. **不写入**：内网 IP、NAS 路径、`.env`、admin token、未公开的管理 API
3. **必写**：Base URL、鉴权方式、核心 API、错误码、联调顺序、检查清单
4. 篇幅：主文件建议 < 500 行；细节放 `reference.md`
5. 内部实现路径可写「联系发码方」或公开文档 URL，不要指向私有 Git 路径

## 从私有仓同步

1. 在私有仓完成 API 变更与验收
2. 只拷贝**集成方视角**文档到本仓
3. 更新 `meta.yaml` 的 `version`（semver）
4. 更新 `catalog.yaml`

## PR 检查清单

- [ ] 无密钥、无内网-only 信息
- [ ] `catalog.yaml` 已登记
- [ ] `SKILL.md` 含有效 frontmatter `name` + `description`
- [ ] 示例 endpoint 使用公网域名或 `{endpoint}` 占位符
