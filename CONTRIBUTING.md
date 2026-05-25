# 贡献指南（本仓库维护者）

## 本仓定位

**个人所有、对外公开**的 Cursor Skills 合集 — 不是「集成专用仓」，集成只是 `category: integration` 的一类。

其它类型示例：

- `guide` — 公开产品文档、最佳实践
- `tooling` — 对外 CLI / 工具链
- `integration` — 第三方接 API / SDK

## 何时新增 skill

- 有一段知识**可以给外部的人或 Agent 用**
- 不适合放在私有主仓库，或私有仓里有一份「内部完整版 + 公开精简版」

## 命名

| 项 | 规则 |
|----|------|
| 目录 `skill-id` | 小写连字符，语义清晰 |
| `SKILL.md` → `name` | 与触发词一致，如 `license-service-integrate` |

## 最少文件

```
skills/<skill-id>/
├── meta.yaml    # 必填，含 category
└── SKILL.md     # 必填
```

## meta.yaml

```yaml
id: my-skill
name: 展示名称
category: integration   # integration | guide | tooling | other
version: "1.0.0"
tags: []
public_api: false       # 若涉及对外 API 则 true
default_endpoint: ""    # 可选
maintainer: ailuo
```

## 写作原则

1. **description** 写清 Agent 何时自动加载
2. **禁止** 内网 IP、密钥、未公开管理 API
3. 主文件 < 500 行，细节放 `reference.md`
4. 从私有仓同步时只拷**可公开**段落

## PR 检查

- [ ] `catalog.yaml` 已登记 `category`
- [ ] 无敏感信息
- [ ] `meta.yaml` + `SKILL.md` 齐全
