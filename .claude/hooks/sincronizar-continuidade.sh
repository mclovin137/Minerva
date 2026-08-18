#!/usr/bin/env bash
# Adaptador Claude Code da convenção de continuidade em docs/. Mantém somente
# as seções geradas de docs/plan.md e docs/state.md; não interpreta payload,
# não executa caminhos e não muda checklist, significado ou outro arquivo.
set -euo pipefail

modo="${1:-sync}"
case "$modo" in
  init|sync) ;;
  *) printf 'Modo inválido: %s\n' "$modo" >&2; exit 2 ;;
esac

# O evento é deliberadamente descartado: o estado é derivado do filesystem.
if [ ! -t 0 ]; then
  cat >/dev/null || true
fi

if [ -n "${ATENA_CONTINUITY_ROOT:-}" ]; then
  raiz="$(cd "$ATENA_CONTINUITY_ROOT" && pwd -P)"
elif [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
  raiz="$(cd "$CLAUDE_PROJECT_DIR" && pwd -P)"
else
  raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
fi

plan="$raiz/docs/plan.md"
state="$raiz/docs/state.md"
plan_dir="$(dirname "$plan")"
state_dir="$(dirname "$state")"
[ -f "$plan" ] && [ -f "$state" ] || exit 0

if [ -n "${ATENA_CONTINUITY_RUNTIME_DIR:-}" ]; then
  runtime="$ATENA_CONTINUITY_RUNTIME_DIR"
else
  id_raiz="$(printf '%s' "$raiz" | sha256sum | cut -c1-16)"
  runtime="${TMPDIR:-/tmp}/atena-continuity-$(id -u)-$id_raiz"
fi
mkdir -p "$runtime"
chmod 700 "$runtime"

exec 9>"$runtime/lock"
if ! flock -w 5 9; then
  printf 'Não foi possível adquirir o lock de continuidade.\n' >&2
  exit 1
fi

snapshot="$runtime/snapshot.tsv"
novo="$(mktemp "$runtime/snapshot-novo.XXXXXX")"
trap 'rm -f "$novo" "${inventario:-}" "${plan_tmp:-}" "${state_tmp:-}"' EXIT

gerar_snapshot() {
  local destino="$1"
  local inventario_local
  inventario_local="$(mktemp "$runtime/inventario.XXXXXX")"

  while IFS= read -r -d '' arquivo; do
    local relativo base
    relativo="${arquivo#"$raiz"/}"
    base="${relativo##*/}"

    case "$relativo" in
      docs/plan.md|docs/state.md|docs/.plan.md.tmp.*|docs/.state.md.tmp.*|.git/*|.idea/*|vendor/*|node_modules/*|build/*|dist/*|coverage/*|storage/framework/*|bootstrap/cache/*|.claude/.continuity/*) continue ;;
    esac
    case "$relativo" in
      *$'\n'*|*$'\t'*) continue ;;
    esac
    case "$base" in
      Dockerfile|Containerfile|Makefile|composer.lock|package-lock.json|pnpm-lock.yaml|yarn.lock) ;;
      *.md|*.txt|*.php|*.json|*.jsonc|*.yaml|*.yml|*.xml|*.toml|*.ini|*.conf|*.env.example|*.example|*.sh|*.bash|*.sql|*.js|*.jsx|*.ts|*.tsx|*.css|*.scss|*.html|*.blade.php|*.graphql|*.gql) ;;
      *) continue ;;
    esac

    printf '%s\t%s\n' "$relativo" "$(sha256sum "$arquivo" | cut -d' ' -f1)" >>"$inventario_local"
  done < <(find "$raiz" -type f -print0)

  LC_ALL=C sort -t $'\t' -k1,1 "$inventario_local" >"$destino"
  rm -f "$inventario_local"
}

gerar_snapshot "$novo"

if [ "$modo" = "init" ] || [ ! -f "$snapshot" ]; then
  snapshot_tmp="$(mktemp "$runtime/snapshot-base.XXXXXX")"
  cp "$novo" "$snapshot_tmp"
  mv -f "$snapshot_tmp" "$snapshot"
  exit 0
fi

declare -A antes depois
while IFS=$'\t' read -r caminho hash; do
  [ -n "$caminho" ] && antes["$caminho"]="$hash"
done <"$snapshot"
while IFS=$'\t' read -r caminho hash; do
  [ -n "$caminho" ] && depois["$caminho"]="$hash"
done <"$novo"

criados=()
alterados=()
removidos=()
for caminho in "${!depois[@]}"; do
  if [ -z "${antes[$caminho]+presente}" ]; then
    criados+=("$caminho")
  elif [ "${antes[$caminho]}" != "${depois[$caminho]}" ]; then
    alterados+=("$caminho")
  fi
done
for caminho in "${!antes[@]}"; do
  [ -z "${depois[$caminho]+presente}" ] && removidos+=("$caminho")
done

if [ "${#criados[@]}" -eq 0 ] && [ "${#alterados[@]}" -eq 0 ] && [ "${#removidos[@]}" -eq 0 ]; then
  exit 0
fi

ordenar_array() {
  if [ "$#" -gt 0 ]; then printf '%s\n' "$@" | LC_ALL=C sort; fi
}

agora="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
corpo_plan="$(mktemp "$runtime/corpo-plan.XXXXXX")"
corpo_state="$(mktemp "$runtime/corpo-state.XXXXXX")"
trap 'rm -f "$novo" "$corpo_plan" "$corpo_state" "${plan_tmp:-}" "${state_tmp:-}"' EXIT

{
  printf 'Última sincronização: `%s`\n\n' "$agora"
  printf -- '- Criados desde o snapshot anterior: %d\n' "${#criados[@]}"
  printf -- '- Alterados desde o snapshot anterior: %d\n' "${#alterados[@]}"
  printf -- '- Removidos desde o snapshot anterior: %d\n' "${#removidos[@]}"
  printf '\nEste registro não altera nem conclui a checklist da task.\n'
} >"$corpo_plan"

{
  printf 'Última sincronização: `%s`\n' "$agora"
  printf '\n### Criados\n'
  if [ "${#criados[@]}" -eq 0 ]; then printf -- '- Nenhum.\n'; else while IFS= read -r caminho; do printf -- '- `%s`\n' "$caminho"; done < <(ordenar_array "${criados[@]}"); fi
  printf '\n### Alterados\n'
  if [ "${#alterados[@]}" -eq 0 ]; then printf -- '- Nenhum.\n'; else while IFS= read -r caminho; do printf -- '- `%s`\n' "$caminho"; done < <(ordenar_array "${alterados[@]}"); fi
  printf '\n### Removidos\n'
  if [ "${#removidos[@]}" -eq 0 ]; then printf -- '- Nenhum.\n'; else while IFS= read -r caminho; do printf -- '- `%s`\n' "$caminho"; done < <(ordenar_array "${removidos[@]}"); fi
} >"$corpo_state"

substituir_secao() {
  local alvo="$1" inicio="$2" fim="$3" corpo="$4" temporario="$5"
  grep -Fqx "$inicio" "$alvo" || return 1
  grep -Fqx "$fim" "$alvo" || return 1
  awk -v inicio="$inicio" -v fim="$fim" -v corpo="$corpo" '
    $0 == inicio {
      print
      while ((getline linha < corpo) > 0) print linha
      close(corpo)
      ignorar=1
      next
    }
    $0 == fim { ignorar=0; print; next }
    !ignorar { print }
  ' "$alvo" >"$temporario"
}

plan_tmp="$(mktemp "$plan_dir/.plan.md.tmp.XXXXXX")"
state_tmp="$(mktemp "$state_dir/.state.md.tmp.XXXXXX")"
substituir_secao "$plan" '<!-- atena-continuity:plan:start -->' '<!-- atena-continuity:plan:end -->' "$corpo_plan" "$plan_tmp"
substituir_secao "$state" '<!-- atena-continuity:state:start -->' '<!-- atena-continuity:state:end -->' "$corpo_state" "$state_tmp"
chmod --reference="$plan" "$plan_tmp"
chmod --reference="$state" "$state_tmp"
mv -f "$plan_tmp" "$plan"
mv -f "$state_tmp" "$state"

snapshot_tmp="$(mktemp "$runtime/snapshot-final.XXXXXX")"
cp "$novo" "$snapshot_tmp"
mv -f "$snapshot_tmp" "$snapshot"
