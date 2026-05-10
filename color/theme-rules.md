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
7. Keep `bg` as the editor background, not as the default statusline or
   selection surface.
8. Keep `selection` as the selection surface and `statusline` as the main
   status bar surface.

## Semantics

1. Use semantic slots consistently.
2. Use dedicated slots for fields, namespaces, modules, parameters, members, and
   constants when those slots exist.
3. `StatusLine` and lualine `normal_bg` should follow the theme's `statusline`
   role unless the theme explicitly defines a different convention.
4. Selection-bearing UI like `Visual`, `PmenuSel`, selected tabs, selected
   completion rows, and selection backgrounds should follow the theme's
   `selection` role.
5. Do not repurpose `normal_bg` while adjusting selection surfaces.

## Theme Families

1. Do not copy semantic choices from one theme family into another.
2. Keep each family inside its own palette and style.
3. When fixing one family, keep the change limited to that family unless the
   request explicitly includes others.

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
5. Keep background-bearing values on neutral base-palette layers.
6. Do not use accent slots for panels, tabs, floats, menus, borders, or other
   background surfaces unless the theme already does that by convention.
7. Recheck `normal_bg`, `section_bg`, `selection_bg`, and `statusline_bg`
   separately when adjusting a theme family.
