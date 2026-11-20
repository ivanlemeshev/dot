#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

mode="${1:-}"
case "$mode" in
  format | format:check | lint) ;;
  *)
    printf 'Usage: bash %s {format|format:check|lint}\n' "${0##*/}" >&2
    exit 2
    ;;
esac

bash_files=()
lua_files=()
markdown_files=()
prettier_files=()
toml_files=()

# NOTE: Git keeps ignored machine files outside the checks.
git rev-parse --show-toplevel >/dev/null
while IFS= read -r -d '' path; do
  [[ -f "$path" ]] || continue
  case "$path" in
    *.sh) bash_files+=("$path") ;;
    *.lua) lua_files+=("$path") ;;
    *.md)
      markdown_files+=("$path")
      prettier_files+=("$path")
      ;;
    *.json | *.yml | *.yaml) prettier_files+=("$path") ;;
    *.toml | *.toml.example) toml_files+=("$path") ;;
  esac
done < <(git ls-files --cached --others --exclude-standard -z)

case "$mode" in
  format | format:check)
    prettier_mode=--write
    shfmt_mode=-w
    stylua_args=(--verify)
    tombi_args=(--offline)
    if [[ "$mode" == format:check ]]; then
      prettier_mode=--check
      shfmt_mode=-d
      stylua_args+=(--check)
      tombi_args+=(--check)
    fi
    prettier "$prettier_mode" "${prettier_files[@]}"
    shfmt "$shfmt_mode" -i 2 -ci "${bash_files[@]}"
    stylua --config-path nvim/.stylua.toml "${stylua_args[@]}" "${lua_files[@]}"
    tombi format "${tombi_args[@]}" "${toml_files[@]}"
    ;;
  lint)
    shellcheck "${bash_files[@]}"
    markdownlint "${markdown_files[@]}"
    tombi lint --offline "${toml_files[@]}"
    ;;
esac
