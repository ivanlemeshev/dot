# Theme Rules

These rules are the source of truth when adding or adjusting future theme YAML
files under `color/themes/`.

## Background Rules

Use one main editor background for seamless surfaces:

- `ui.bg` is the canonical main background.
- `semantic.popup_bg` and `ui.popup_bg` should match `ui.bg` when floating
  windows, terminal floats, and popup borders are expected to visually blend
  into the editor background.
- `fzf.bg` should match `ui.bg`.
- `fzf.gutter` should match `ui.bg`.
- `fzf."bg+"` should also match `ui.bg` when the selected row should not create
  a second background band inside floating pickers.

Use alternate surfaces only when deliberate contrast is needed:

- `ui.bg_alt`, `semantic.surface`, `semantic.surface_alt`, `statusline.*_bg`,
  `tmux.*_bg`, and selection colors may differ from `ui.bg`.
- Selection and active-row states should be expressed with selection colors,
  accent colors, or foreground changes, not by introducing an unrelated popup
  background.

## Statusline And Tmux Rules

Statusline and tmux should read as one system, even if they are rendered by
different tools.

- Decide whether the theme wants neutral bars or accent-driven bars, then apply
  that decision consistently to both `statusline` and `tmux`.
- `statusline.section_bg`, `statusline.inactive_bg`, `tmux.bar_bg`, and
  `tmux.message_bg` should belong to the same surface family.
- When statusline and tmux are meant to be visible chrome rather than fully
  blended overlays, their neutral bar backgrounds should not equal `ui.bg`. Keep
  them on a distinct surface so the bars remain readable as separate UI layers
  against the editor background.
- Active blocks should use the same visual strategy in both places: inverted
  blocks in both, or accent blocks in both.
- Alert and bell states should remain compatible across both tools:
  `tmux.alert_*` and `tmux.bell_*` should not introduce a palette logic that
  conflicts with `statusline` mode colors.
- Border colors should stay aligned with the broader UI border story:
  `tmux.border_fg` and `tmux.border_active_fg` should feel consistent with
  `ui.border` and `ui.border_active`.
- The status/tmux layer may differ from `ui.bg`, but that contrast must be
  intentional and internally consistent.

## Semantic Color Rules

Every theme must derive semantics from its own palette and visual language.

- Do not copy semantic role mappings from another theme just because the schema
  matches.
- Start from the theme's native palette, then assign roles according to how the
  theme naturally communicates emphasis, neutrality, warnings, and structure.
- When a theme has an official editor implementation, map `syntax` roles from
  that implementation's highlight groups before using terminal ANSI intuition.
  Terminal `yellow`, `green`, and `blue` slots are not enough to infer syntax
  semantics.
- `semantic`, `syntax`, and `tool` sections should agree on color families
  unless there is a clear reason to diverge.
- Informational, warning, error, success, prompt, and accent roles should each
  feel native to the theme rather than inherited from a different theme's logic.
- If a theme family has official or established role conventions, prefer those
  conventions over cross-theme uniformity.
- For Melange specifically, preserve the upstream rule that control flow uses
  warm colors and data uses cold colors: statements/keywords are warm yellow,
  operators are red, functions/specials are bright yellow, strings are blue,
  types are cyan, constants/numbers are magenta, and identifiers remain on the
  main foreground unless a more specific upstream group says otherwise.
- Reusing the same hue across sections is acceptable when it preserves the
  theme's identity; forcing one global mapping across all themes is not.

## Terminal Palette Rules

The `ansi` block is a terminal palette, not an editor semantic palette.

- If a theme family has an official terminal export or canonical upstream
  palette, `ansi` must match that source exactly.
- Do not infer `white`, `bright_white`, or `bright_black` from luminance or from
  generic light-vs-dark intuition; those slots are family-specific and may
  intentionally overlap or differ in ways that look surprising out of context.
- Do not copy terminal ANSI values from another family just because the schema
  matches.
- When a terminal palette and editor palette disagree, treat the upstream
  terminal palette as authoritative for `ansi` and the upstream editor palette
  as authoritative for the rest of the theme.

## Cross-Section Role Rules

The same real-world concept should use the same color across generated targets
unless a theme has a strong, documented reason to split it.

- Directory and path roles should stay aligned across `semantic.directory`,
  `tool.path`, `tool.directory`, `ls_colors.directory`, `fish.valid_path`, and
  `fish.cwd`.
- Executable and command roles should stay aligned across `semantic.executable`,
  `tool.executable`, `ls_colors.executable`, and `fish.command`. If an official
  editor theme treats executable files differently from shell executable
  conventions, prefer the official role and document the choice.
- Symlink and special-file roles should stay aligned across `semantic.symlink`,
  `tool.symlink`, and the closest file-listing special-file slot such as
  `ls_colors.special`.
- Success and clean-state roles should stay aligned across `semantic.success`,
  `tool.git_clean`, `omp.git_clean`, `omp.status_ok`, and any positive-match
  color such as `fzf.hl`.
- Error, root, dirty-state, behind-state, alert, and failed-status roles should
  stay aligned across `semantic.error`, `tool.root`, `tool.git_dirty`,
  `tool.git_behind`, `omp.root`, `omp.git_dirty`, `omp.git_behind`,
  `omp.status_error`, `tmux.alert_bg`, `ls_colors.error`, `fish.error`,
  `fish.cancel`, `fish.cwd_root`, and `fish.status`.
- Warning, prompt, title, bell, marker, and spinner roles should stay in one
  compatible accent family across `semantic.warning`, `semantic.prompt`,
  `semantic.title`, `tmux.bell_bg`, `fzf.marker`, and `fzf.spinner`.
- Informational, ahead-state, host, and pointer roles should stay aligned across
  `semantic.info`, `semantic.changed`, `tool.git_ahead`, `omp.host`,
  `omp.git_ahead`, `fish.host`, and `fzf.pointer`.
- Keep syntax-specific shades separate when the official editor theme uses
  brighter or dimmer variants for code semantics. Cross-section consistency is
  for shared UI/tool/file concepts, not a reason to flatten syntax highlighting.

## Consistency Checks

When creating a new theme or reviewing an edited one:

1. Compare popup-related values against `ui.bg`.
2. Check floating terminal borders and bodies for the same background.
3. Check FZF and FzfLua backgrounds for unintended bands or border seams.
4. Check that statusline and tmux follow one shared bar strategy.
5. Check that neutral status/tmux bars are still visually distinct from `ui.bg`.
6. Check that semantic and syntax roles are derived from the current theme's own
   palette rather than copied from another theme.
7. Check that directory/path, executable/command, symlink/special-file,
   success/clean, error/root/dirty, warning/prompt, and info/ahead/host roles
   are consistent across sections.
