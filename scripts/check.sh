#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

mode="${1:-}"
case "$mode" in
  setup) exec pwsh -NoProfile -File scripts/check.ps1 setup ;;
  test:palettes) exec python -m unittest discover -s tests -v ;;
  format | format:check | lint) ;;
  *)
    printf 'Usage: bash %s {setup|test:palettes|format|format:check|lint}\n' "${0##*/}" >&2
    exit 2
    ;;
esac

bash_files=()
lua_files=()
markdown_files=()
prettier_files=()
toml_files=()
fish_files=()
python_files=()
powershell_files=()
workflow_files=()
yaml_files=()

# NOTE: Git keeps ignored machine files outside the checks.
git rev-parse --show-toplevel >/dev/null
while IFS= read -r -d '' path; do
  [[ -f "$path" ]] || continue
  case "$path" in
    *.sh) bash_files+=("$path") ;;
    *.fish) fish_files+=("$path") ;;
    *.py) python_files+=("$path") ;;
    *.ps1 | *.psm1 | *.psd1) powershell_files+=("$path") ;;
    *.lua) lua_files+=("$path") ;;
    *.md)
      markdown_files+=("$path")
      prettier_files+=("$path")
      ;;
    .github/workflows/*.yml | .github/workflows/*.yaml)
      workflow_files+=("$path")
      yaml_files+=("$path")
      ;;
    *.json) prettier_files+=("$path") ;;
    *.yml | *.yaml) yaml_files+=("$path") ;;
    *.toml | *.toml.example) toml_files+=("$path") ;;
  esac
done < <(git ls-files --cached --others --exclude-standard -z)

case "$mode" in
  format | format:check)
    prettier_mode=--write
    shfmt_mode=-w
    psfmt_mode=--write
    stylua_args=(--verify)
    tombi_args=(--offline)
    yamlfmt_args=(-formatter retain_line_breaks=true -formatter indent=2)
    fish_mode=--write
    ruff_fix_mode=--fix-only
    ruff_format_args=()
    if [[ "$mode" == format:check ]]; then
      prettier_mode=--check
      shfmt_mode=-d
      psfmt_mode=--check
      stylua_args+=(--check)
      tombi_args+=(--check)
      yamlfmt_args+=(-lint)
      fish_mode=--check
      ruff_fix_mode=--diff
      ruff_format_args+=(--check)
    fi
    prettier "$prettier_mode" "${prettier_files[@]}"
    shfmt "$shfmt_mode" -i 2 -ci "${bash_files[@]}"
    stylua --config-path nvim/.stylua.toml "${stylua_args[@]}" "${lua_files[@]}"
    tombi format "${tombi_args[@]}" "${toml_files[@]}"
    yamlfmt "${yamlfmt_args[@]}" "${yaml_files[@]}"
    fish_indent "$fish_mode" "${fish_files[@]}"
    ruff check "$ruff_fix_mode" "${python_files[@]}"
    ruff format "${ruff_format_args[@]}" "${python_files[@]}"
    ruff check "$ruff_fix_mode" --select I001 "${python_files[@]}"
    pwsh -NoProfile -File scripts/check.ps1 syntax "${powershell_files[@]}"
    psfmt --preset otbs "$psfmt_mode" "${powershell_files[@]}"
    python scripts/check_data.py "$mode"
    ;;
  lint)
    shellcheck "${bash_files[@]}"
    markdownlint "${markdown_files[@]}"
    tombi lint --offline "${toml_files[@]}"
    for path in "${fish_files[@]}"; do fish --no-execute "$path"; done
    ruff check "${python_files[@]}"
    selene "${lua_files[@]}"
    actionlint "${workflow_files[@]}"
    pwsh -NoProfile -File scripts/check.ps1 lint "${powershell_files[@]}"
    python scripts/check_data.py lint
    ;;
esac
