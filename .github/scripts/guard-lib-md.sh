#!/usr/bin/env bash
# Compara dependências diretas declaradas em manifestos com o inventário docs/lib.md.
set -euo pipefail
raiz="${1:-.}"
cd "$raiz"
if [ ! -f docs/lib.md ]; then
  printf 'Inventário ausente: docs/lib.md\n' >&2
  exit 1
fi
temporario="$(mktemp -d)"
trap 'rm -rf "$temporario"' EXIT
manifestos="$temporario/manifestos"
dependencias="$temporario/dependencias"
registradas="$temporario/registradas"
find . -type d \( -name .git -o -name node_modules \) -prune -o -type f \( -name go.mod -o -name package.json \) -print | LC_ALL=C sort > "$manifestos"
if [ ! -s "$manifestos" ]; then
  printf 'Nenhum manifesto de dependência encontrado; guard não aplicável.\n'
  exit 0
fi
: > "$dependencias"
while IFS= read -r manifesto; do
  case "$manifesto" in
    */go.mod|./go.mod)
      awk '/^require[[:space:]]+\(/ { em_bloco = 1; next } em_bloco && /^\)/ { em_bloco = 0; next } /^require[[:space:]]+/ { print $2; next } em_bloco && /^[[:space:]]*[^[:space:]\/]/ { print $1 }' "$manifesto" >> "$dependencias"
      ;;
    */package.json|./package.json)
      jq -r '(.dependencies // {} | keys[]) , (.devDependencies // {} | keys[]) , (.optionalDependencies // {} | keys[])' "$manifesto" >> "$dependencias"
      ;;
  esac
done < "$manifestos"
LC_ALL=C sort -u "$dependencias" -o "$dependencias"
awk -F'|' '/^\|/ { nome = $2; gsub(/^[[:space:]]+|[[:space:]]+$/, "", nome); if (nome != "" && nome != "Nome" && nome !~ /^-+$/) print nome }' docs/lib.md | LC_ALL=C sort -u > "$registradas"
achados=0
while IFS= read -r dependencia; do
  if ! grep -Fqx -- "$dependencia" "$registradas"; then
    printf 'Dependência declarada sem registro em docs/lib.md: %s\n' "$dependencia" >&2
    achados=1
  fi
done < "$dependencias"
if [ "$achados" -ne 0 ]; then
  exit 1
fi
printf 'Manifestos e docs/lib.md estão coerentes.\n'
