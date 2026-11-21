# Color themes

## Select a palette

After bootstrap, use these commands to list palettes, show the current palette, or select a palette:

```sh
mise run palette list
mise run palette current
mise run palette use charcoal-pastel
```

An asterisk marks the current palette in the list. If your selected palette is gone, select the default, `charcoal-pastel`. Reload or restart the terminal after a switch.

The palette applies to Ghostty, Konsole, iTerm2, and Windows Terminal. VS Code uses its default colors.

## Add a palette

Copy a directory under `palettes/` and edit its four native palette files. Use a name that starts with a lowercase letter and contains only lowercase letters, digits, or hyphens. Keep all 16 ANSI colors consistent across the four files. Keep the `custom` scheme names and the iTerm2 profile identifier.

Add the palette and its ANSI colors to `EXPECTED` in `tests/test_palettes.py`. Run `mise run test:palettes`.

## Bat cache

After you change `bat/themes/custom.tmTheme`, run `bat cache --build`. On Ubuntu, run `batcat cache --build`.
