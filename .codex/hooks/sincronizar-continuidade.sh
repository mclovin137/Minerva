#!/usr/bin/env bash
# Adaptador Codex da convenção de continuidade em docs/.
set -euo pipefail
raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
exec bash "$raiz/.claude/hooks/sincronizar-continuidade.sh" "$@"
