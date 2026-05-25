---
name: my-service-integrate
description: >-
  Integrate with My Service API for third-party apps. Use when the user asks to
  integrate my-service, call My Service API, SDK, webhook, or 集成某某服务.
---

# My Service 集成

> 复制本目录为 `skills/<service-id>/` 后替换全部占位内容。

## 何时使用

- 第三方应用要调用 **My Service** 的公开 API
- 需要 SDK 选型、鉴权、错误处理、联调步骤

**不覆盖**：服务部署、运维、管理后台 — 那些留在私有主仓库。

---

## 1. 概念

（用 5–10 行说明核心对象与关系。）

---

## 2. Endpoint 与鉴权

| 项 | 值 |
|----|-----|
| Base URL | `https://api.example.com` |
| 鉴权 | `Authorization: Bearer <token>` / API Key / 匿名 |

---

## 3. 核心 API

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/v1/...` | ... |

详细字段 → [reference.md](reference.md)  
示例 → [examples.md](examples.md)

---

## 4. 推荐集成流程

```
- [ ] 1. 向服务方申请凭证 / API Key
- [ ] 2. 实现首次调用并联调
- [ ] 3. 错误处理与重试
- [ ] 4. 生产环境配置
```

---

## 5. 检查清单

- [ ] 不使用硬编码密钥；用环境变量
- [ ] 处理速率限制与超时
- [ ] 日志不打印 token

---

## 6. Agent 工作流

1. 读 `meta.yaml` 确认 endpoint
2. 优先官方 SDK；否则裸 HTTP
3. 按 examples 联调后再嵌入业务
