#!/usr/bin/env bash
# Adaptador Claude do onboarding canônico; não grava estado nem executa recursos.
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
documento="$repo/docs/recursos-template.md"
[ -f "$documento" ] || exit 0
jq -n --rawfile conteudo "$documento" '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: ("[ONBOARDING DE RECURSOS — Minerva]\n\n" + $conteudo)}}'
