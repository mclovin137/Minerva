#!/usr/bin/env bash
# SessionStart — injeta a definição canônica do Batman no Codex.
set -euo pipefail
if [ ! -t 0 ]; then cat >/dev/null || true; fi
raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
documento="$raiz/docs/agentes/batman.md"
[ -f "$documento" ] || exit 0
jq -n --rawfile conteudo "$documento" '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: ("[PAPEL DA SESSÃO PRINCIPAL — projeto Minerva]\n\n" + $conteudo)}}'
