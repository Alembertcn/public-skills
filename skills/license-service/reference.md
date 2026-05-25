# License Service 客户端 API 参考

协议版本：2026-05。客户端统一走 `/api/license/*`，**无需 JWT**。

## Base URL

**默认接入**（[meta.yaml](meta.yaml) `default_endpoint`）：

```
https://license.ailuo.fun/license-service
```

完整 URL 示例：

```
https://license.ailuo.fun/license-service/api/license/resolve   ← 推荐先调
https://license.ailuo.fun/license-service/api/license/activate
https://license.ailuo.fun/license-service/api/license/check
```

本地联调将 origin 换为 `http://127.0.0.1:8090` 即可（仍须带 `/license-service` 前缀）。

---

## POST /api/license/resolve（统一配置查询）

**不消耗激活码、不绑定**。根据激活码 + `product_id` 返回发码时的全部客户端所需配置；后续新增字段只扩展本响应，不再新增零散查询接口。

### 请求

| 字段 | 必填 | 说明 |
|------|------|------|
| `activation_key` | 是 | 用户输入的激活码 |
| `product_id` | 是 | 集成方写死的本产品主键 |

### 成功响应 200

```json
{
  "ok": true,
  "activation_key": "LIC-...",
  "product_id": "lic-xxx",
  "product_name": "KF 客服",
  "tenant_id": "...",
  "binding_type": "DEVICE",
  "binding_target_type": "DEVICE",
  "requires_account_id": false,
  "max_transfers": 3,
  "transfer_used": 0,
  "plan_code": "pro",
  "plan_name": "专业版",
  "plan_policy": { },
  "days": 365,
  "permanent": false,
  "used": false,
  "used_binding_target": null,
  "activatable": true,
  "features": { }
}
```

| 字段 | 说明 |
|------|------|
| `binding_type` | 发码时选定：`DEVICE` / `ACCOUNT` / `MIXED` |
| `binding_target_type` | SDK 构造 `binding_target` 用的类型提示 |
| `requires_account_id` | `MIXED` 为 true，activate 须带 `account_id` |
| `plan_code` / `plan_name` | 码内绑定套餐（发码时写入；无则为空） |
| `plan_bound` | 是否已绑定套餐 |
| `days` / `permanent` | 授权天数；0 表示永久 |
| `activatable` | 当前码是否仍可激活（含换机余量） |

### SDK 推荐流程

```java
ActivationResolve cfg = client.resolve(activationKey);
BindingTarget target = cfg.suggestBindingTarget(deviceId, accountId);
client.activate(activationKey, target);
// 或一步：client.activateSmart(activationKey, accountId);
```

---

## POST /api/license/activate

| 字段 | 必填 | 说明 |
|------|------|------|
| `activation_key` | 是 | 激活码 |
| `product_id` | 是 | 须与码一致 |
| `binding_target` | 是 | 本机 device_id 或 account_id |
| `binding_target_type` | 否 | 默认 `DEVICE` |
| `account_id` | MIXED 必填 | 混合绑定账户 |
| `client` | 否 | 可选上报 hostname |

套餐 `plan_code` **不在 activate 请求中传递**，由激活码发码时绑定；接入方通过 resolve 查看 `plan_code` / `plan_bound` 即可。

成功响应含 `license_token`、`ack`、`ack_payload.product_id`。

---

## POST /api/license/check

| 字段 | 必填 |
|------|------|
| `product_id` | 是 |
| `binding_target` | 是 |
| `ack` | 强烈建议 |

---

## 错误码（resolve / activate 共用）

| error | 场景 |
|-------|------|
| `invalid_activation_key` | 码不存在 |
| `product_id_mismatch` | product_id 与码所属产品不一致 |
| `binding_type_mismatch` | 绑定类型与码要求不符 |
| `activation_key_already_used` | 已绑且不可换绑 |
| `transfer_limit_exceeded` | 换机次数用尽 |
