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
- `semantic`, `syntax`, and `tool` sections should agree on color families
  unless there is a clear reason to diverge.
- Informational, warning, error, success, prompt, and accent roles should each
  feel native to the theme rather than inherited from a different theme's logic.
- If a theme family has official or established role conventions, prefer those
  conventions over cross-theme uniformity.
- Reusing the same hue across sections is acceptable when it preserves the
  theme's identity; forcing one global mapping across all themes is not.

## Consistency Checks

When creating a new theme or reviewing an edited one:

1. Compare popup-related values against `ui.bg`.
2. Check floating terminal borders and bodies for the same background.
3. Check FZF and FzfLua backgrounds for unintended bands or border seams.
4. Check that statusline and tmux follow one shared bar strategy.
5. Check that neutral status/tmux bars are still visually distinct from `ui.bg`.
6. Check that semantic and syntax roles are derived from the current theme's own
   palette rather than copied from another theme.
