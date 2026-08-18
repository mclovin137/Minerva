#!/usr/bin/env bash
# Adaptador Codex do onboarding canônico; não grava estado nem executa recursos.
set -euo pipefail
if [ ! -t 0 ]; then cat >/dev/null || true; fi
raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
documento="$raiz/docs/recursos-template.md"
[ -f "$documento" ] || exit 0
jq -n --rawfile conteudo "$documento" '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: ("[ONBOARDING DE RECURSOS — Minerva]\n\n" + $conteudo)}}'
