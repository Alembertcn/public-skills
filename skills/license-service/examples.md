# License Service 集成示例

默认 `ENDPOINT` = [meta.yaml](meta.yaml) 的 `default_endpoint`：`https://license.ailuo.fun/license-service`（本地联调改为 `http://127.0.0.1:8090/license-service`）。

## curl — 设备绑定

```bash
ENDPOINT="https://license.ailuo.fun/license-service"
AKEY="LIC-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx"
DEVICE_ID="$(uuidgen | tr -d '-' | tr 'A-Z' 'a-z')"

curl -sS -X POST "$ENDPOINT/api/license/activate" \
  -H 'Content-Type: application/json' \
  -d "{
    \"activation_key\": \"$AKEY\",
    \"binding_target\": \"$DEVICE_ID\",
    \"binding_target_type\": \"DEVICE\"
  }" | jq .
```

## curl — 账号绑定

```bash
curl -sS -X POST "$ENDPOINT/api/license/activate" \
  -H 'Content-Type: application/json' \
  -d '{
    "activation_key": "LIC-....",
    "binding_target": "user_12345",
    "binding_target_type": "ACCOUNT"
  }'
```

## Python（裸 HTTP）

```python
import json, urllib.request, uuid

ENDPOINT = "https://license.ailuo.fun/license-service"
DEVICE_ID = str(uuid.uuid4()).replace("-", "")

def post(path, body):
    req = urllib.request.Request(
        f"{ENDPOINT}{path}",
        data=json.dumps(body).encode(),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req) as resp:
        return json.load(resp)

r = post("/api/license/activate", {
    "activation_key": "LIC-....",
    "binding_target": DEVICE_ID,
    "binding_target_type": "DEVICE",
})
assert r["ok"]
```

## 联调顺序

1. 向发码方索取测试用 LIC
2. curl activate → `ok: true`
3. curl check → `valid: true`
4. 嵌入 SDK 或业务代码
5. 发码方释放绑定 → check 应 `valid: false`
