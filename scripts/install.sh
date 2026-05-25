#!/usr/bin/env bash
# 安装 skills 到 ~/.cursor/skills/
# 用法：
#   ./scripts/install.sh                 # 安装全部（跳过 _template）
#   ./scripts/install.sh license-service # 只安装指定 id
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"

install_one() {
  local id="$1"
  local src="$ROOT/skills/$id"
  if [ ! -f "$src/SKILL.md" ]; then
    echo "错误：未找到 $src/SKILL.md" >&2
    exit 1
  fi
  mkdir -p "$DEST"
  rm -rf "$DEST/$id"
  cp -R "$src" "$DEST/$id"
  echo "已安装: $DEST/$id"
}

if [ $# -ge 1 ]; then
  for id in "$@"; do
    install_one "$id"
  done
else
  for dir in "$ROOT/skills"/*/; do
    id="$(basename "$dir")"
    [ "$id" = "_template" ] && continue
    install_one "$id"
  done
fi

echo "Done. 详见 docs/cursor-setup.md"
