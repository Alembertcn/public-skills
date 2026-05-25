---
name: license-service-integrate
description: >-
  第三方软件集成 License Service 客户端授权：激活码 activate/check、设备/账号/混合绑定、
  Java/JS SDK 与裸 HTTP。Use when integrating license activation, activation key, LIC,
  license token, /api/license/activate, /api/license/check, 授权集成, 激活码, 许可证校验.
---

# License Service 客户端集成

教 Agent 帮**其它软件**接入 License Service 的**客户端授权协议**（仅终端 activate/check，非发码后台）。

## 何时读本 Skill

- 桌面/服务端/浏览器应用要接激活码授权
- 选型 SDK vs 裸 HTTP
- 实现激活、心跳、离线宽限、换机/换账号策略
- 排查 `activate` / `check` 错误码

元数据（默认 endpoint）→ [meta.yaml](meta.yaml)

---

## 1. 概念

```text
产品
  └─ 套餐：功能档位 + 扩展策略（写入 token）
  └─ 激活码 LIC-...
        ├─ binding_type   DEVICE / ACCOUNT / MIXED（生成时设定）
        ├─ plan_code      内嵌套餐，客户端通常可省略 plan_code
        ├─ days           激活后有效期（0=永久）
        └─ max_transfers  仅 DEVICE/MIXED；ACCOUNT 一码一账号

终端 ──POST /api/license/activate──► license_token + ack
     ──POST /api/license/check────► 绑定是否仍有效
```

| 绑定类型 | binding_target | 换绑 |
|----------|----------------|------|
| DEVICE | device_id | 可换机（max_transfers） |
| ACCOUNT | account_id | **不可换绑** |
| MIXED | device_id + account_id | 可换设备 |

---

## 2. 集成入口

| 方式 | 说明 |
|------|------|
| Java SDK | 向发码方索取 `sdk-java` |
| JS/TS SDK | 向发码方索取 `sdk-js` |
| 裸 HTTP | 任意语言，见 [examples.md](examples.md) |

**Endpoint**（见 `meta.yaml`）：

- `POST {endpoint}/api/license/activate`
- `POST {endpoint}/api/license/check`

客户端 API **无需 JWT**。

---

## 3. 集成流程

```
- [ ] 1. 拿到 activation_key（LIC-...）及 binding_type
- [ ] 2. 选定 binding_target
- [ ] 3. activate，持久化 license_id + ack + binding_target
- [ ] 4. 定时 check（5–15 分钟）+ 离线宽限
- [ ] 5. 无授权则限制功能或引导输入激活码
```

### activate 成功（Mode C）

```json
{
  "ok": true,
  "license_token": "...",
  "ack": "...",
  "ack_payload": { "license_id": "...", "binding_target": "..." }
}
```

### check

请求带 `license_id`、`binding_target`、`ack`；响应始终 200，看 `valid`。

详细字段与错误码 → [reference.md](reference.md)

---

## 4. SDK 示例

```java
LicenseClient client = LicenseClient.builder()
    .endpoint("https://license.ailuo.fun/license-service")
    .planCode("...")  // 与码内套餐一致，或裸 HTTP 省略 plan_code
    .bindingTarget(BindingTarget.device(deviceId))
    .build();
client.activate("LIC-....");
client.check();
```

```ts
const client = new LicenseClient({
  endpoint: 'https://license.ailuo.fun/license-service',
  planCode: '...',
  bindingTarget: BindingTarget.device(deviceId),
});
await client.activate('LIC-....');
```

---

## 5. 检查清单

- [ ] 只调 `/api/license/*`，不调发码管理 API
- [ ] activate 后持久化 ack；check 必须带 ack
- [ ] 账号绑定：换 account_id 会被拒
- [ ] 客户端不硬编码 admin token

---

## 6. Agent 工作流

1. 读 `meta.yaml` 的 `default_endpoint`
2. 确认 binding_type 与 binding_target 匹配
3. 优先 SDK，否则 [examples.md](examples.md) 裸 HTTP
4. curl 联调通过后再嵌入业务

更多示例 → [examples.md](examples.md)
