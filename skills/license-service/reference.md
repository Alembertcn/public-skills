# License Service 客户端 API 参考

协议版本：2026-05（与 License Service 客户端 Controller 对齐）。

## Base URL

```
{origin}/license-service/api/license/activate
{origin}/license-service/api/license/check
```

默认公网示例见 `meta.yaml` 的 `default_endpoint`。

---

## POST /api/license/activate

### 请求字段

| 字段 | 必填 | 说明 |
|------|------|------|
| `activation_key` | 是 | `LIC-{hash}-{hash}-XXXX-XXXX-XXXX` |
| `binding_target` | 是* | 设备 ID 或账号 ID |
| `instance_id` | 否 | 旧字段，等同 `binding_target` |
| `binding_target_type` | 否 | `DEVICE` / `ACCOUNT`；默认 `DEVICE` |
| `account_id` | MIXED 必填 | 混合绑定时账户 ID |
| `plan_code` | 条件 | 激活码已内嵌套餐时可省略；传则须一致 |
| `product_code` | 否 | 缺省 `default` |
| `license_token` | 否 | Mode B 离线预签；主流 Mode C 留空 |
| `client` | 否 | `{ "hostname": "...", "platform": "..." }` |

### 成功响应 200

```json
{
  "ok": true,
  "license_token": "<Mode C 非空>",
  "ack": "<signed>",
  "ack_payload": {
    "license_id": "lic_xxx",
    "binding_target": "...",
    "activated_at": "2026-05-23T08:00:00Z"
  }
}
```

### 失败响应

```json
{
  "detail": {
    "ok": false,
    "error": "<code>",
    "message": "...",
    "status": 400
  }
}
```

---

## POST /api/license/check

| 字段 | 必填 |
|------|------|
| `license_id` | 是 |
| `binding_target` 或 `instance_id` | 是 |
| `ack` | 强烈建议 |

```json
{ "ok": true, "valid": true, "reason": "", "checked_at": "..." }
```

| valid | reason |
|-------|--------|
| false | `binding_released` |
| false | `ack_superseded` |

---

## 错误码

| error | 场景 |
|-------|------|
| `invalid_activation_key` | 码不存在 |
| `activation_key_already_used` | 已绑其它目标 |
| `transfer_limit_exceeded` | 换机次数用尽 |
| `binding_type_mismatch` | 绑定类型不符 |
| `plan_code_mismatch` | plan_code 不一致 |
| `product_mismatch` | product_code 不符 |

---

## 绑定规则

1. 同 `binding_target` 重复 activate：允许（重装）
2. ACCOUNT 码换账号：拒绝
3. DEVICE/MIXED 换设备：消耗换机次数
4. 后台释放绑定 → check `binding_released`

集成方**只需**客户端 API，不需管理 API（`/license/*` 需 Keycloak）。
