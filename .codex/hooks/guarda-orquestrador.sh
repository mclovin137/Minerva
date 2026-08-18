#!/usr/bin/env bash
# PreToolUse — alerta antes de mutações. O payload Codex não fornece agent_id,
# então bloquear aqui também impediria as escritas autorizadas dos subagentes.
set -euo pipefail
entrada="$(cat)"
ferramenta="$(printf '%s' "$entrada" | jq -r '.tool_name // empty')"
mutacao=0
case "$ferramenta" in
  apply_patch) mutacao=1 ;;
  Bash)
    comando="$(printf '%s' "$entrada" | jq -r '.tool_input.command // empty')"
    if printf '%s' "$comando" | grep -Eq -e '(^|[;&|(]|[[:space:]])(rm|mv|cp|mkdir|rmdir|touch|ln|chmod|chown|truncate|dd|tee|shred|unlink)([[:space:]]|$)' -e '(sed|perl)[[:space:]]+-i' -e 'git[[:space:]]+(add|commit|rm|mv|checkout|switch|reset|restore|apply|clean|push|merge|rebase|stash|init|tag)([[:space:]]|$)' -e '(^|[^0-9&>])>{1,2}[[:space:]]*[^&[:space:]]'; then mutacao=1; fi ;;
esac
[ "$mutacao" -eq 1 ] || exit 0
jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: "Antes da mutação, confirme a delegação: a sessão principal é o Homem de Ferro e não escreve arquivos. O PreToolUse do Codex não distingue sessão principal de subagentes; este adaptador alerta, mas não bloqueia as escritas legítimas dos delegados. Contrato: docs/agentes/homem-de-ferro.md."}}'
