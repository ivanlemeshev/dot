# Theme Rules

Use these rules when editing files under `color/themes/` and the related
generators.

## Structure

1. Use `tomorrow-night.yaml` as the structural baseline.
2. Keep the same top-level sections in every theme file.
3. Do not invent new `base_palette` keys unless the baseline already has them.
4. Do not add standalone hex values outside `base_palette`.

## Palette

1. Every section value must come from that theme's own `base_palette`.
2. If a slot already exists, reuse it.
3. If a slot does not exist in the baseline, do not create it just for one case.
4. Accent slots may be the same or different, depending on the theme.
5. Use the theme's existing convention for accent slots; do not change one
   without a reason.
6. Slot names are semantic labels, not literal hues. If a theme assigns an
   accent role to an existing slot, keep that assignment consistent for that
   theme.

## Semantics

1. Use semantic slots consistently.
2. Use dedicated slots for fields, namespaces, modules, parameters, members, and
   constants when those slots exist.

## Theme Families

1. Do not copy semantic choices from one theme family into another.
2. Keep each family inside its own palette and style.

## Generated Files

1. Update the matching generator when a palette key changes.
2. Keep generator inputs and theme files in sync.
3. Check the generated Neovim, tmTheme, Fish, and terminal outputs after
   changes.

## Validation

1. Audit every section value against `base_palette`.
2. Confirm no extra palette keys were introduced.
3. Verify visible UI colors, syntax colors, and mode/status colors separately.
4. Make the smallest change that satisfies the requested theme behavior.
