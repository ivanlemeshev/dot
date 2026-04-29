# Theme Rules

These rules are the source of truth when adding or adjusting future theme YAML
files under `color/themes/`.

## Base Palette Rules

- If a theme defines `base_palette`, that section is the authoritative source of
  truth for the theme.
- Do not change values inside `base_palette` after they have been verified
  against the intended upstream palette.
- Do not invent new colors in derived sections when the same value already
  exists in `base_palette`.
- Do not treat `base_palette` as a semantic layer. Keep it limited to the
  canonical palette values that all other theme sections are derived from.
- If a theme has a known upstream palette, `base_palette` must match that source
  exactly, including any intentional reuse of the same hex value across multiple
  slots.
- Derived sections such as `ui`, `statusline`, `semantic`, `syntax`, `tool`,
  `tmux`, `ls_colors`, `fzf`, `fish`, `omp`, and similar maps must be built from
  `base_palette` rather than reinterpreting the palette independently.
- When a section needs a color that is not present in `base_palette`, add the
  rule to derive it from existing palette values instead of altering the base
  palette itself.
- Platform-specific override sections such as `windows_terminal` are allowed
  only for target-specific tweaks. They must be derived from `base_palette` and
  must not introduce a second source of truth for palette values.
