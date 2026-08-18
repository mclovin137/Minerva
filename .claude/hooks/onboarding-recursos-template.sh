#!/usr/bin/env bash
# Adaptador Claude do onboarding canônico; apresenta somente documentos e skills selecionáveis.
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
documentos="$(find "$repo/docs" -type f -name '*.md' ! -path "$repo/docs/agentes/*" ! -path "$repo/docs/skills/*" ! -path "$repo/docs/roles/*" -printf '%P\n' | LC_ALL=C sort | sed 's#^#- docs/#')"
skills="$(find "$repo/docs/skills" -maxdepth 1 -type f -name '*.md' -printf '%f\n' | LC_ALL=C sort | sed 's#\.md$##' | sed 's#^#- #')"
contexto="[ONBOARDING DE RECURSOS — Minerva]

Documentos disponíveis:
$documentos

Skills disponíveis:
$skills

Agentes e hooks seguem seus contratos e a configuração versionada; não são opções de escolha.

Quais documentos e skills do template você quer habilitar nesta sessão? Escolha os itens pelo nome, todos ou nenhum."
jq -n --arg conteudo "$contexto" '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $conteudo}}'
