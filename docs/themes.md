# Color themes

## Select a palette

Run these commands after bootstrap:

```sh
mise run palette list
mise run palette current
mise run palette use charcoal-pastel
mise run palette use warm-earth
```

`charcoal-pastel` is the default palette with a charcoal background and soft accent colors. `warm-earth` uses brown, olive, and cream tones. An asterisk marks the selected palette in the list.

The selection stays in `~/.local/state/dotfiles-palette/selection`. Bootstrap keeps this selection. Switching palettes does not change repository files. Reload or restart the terminal after a switch.

Ghostty, Konsole, and iTerm2 use links to the selected native palette files. Windows Terminal receives the selected palette and theme in its local settings. The script keeps its fonts, keybindings, and other settings. VS Code keeps its current colors.

## Add a palette

Copy a directory under `palettes/` and edit its four native palette files. Use a name that starts with a lowercase letter and contains only lowercase letters, digits, or hyphens. Keep all 16 ANSI colors consistent across the four files. Keep the `custom` scheme names and the iTerm2 profile identifier.

Run `mise run test:palettes` to check the included palettes and the switcher.

## Bat cache

After a change to `bat/themes/custom.tmTheme`, rebuild the theme cache:

```sh
bat cache --build
```

On Ubuntu, use `batcat cache --build`. Bootstrap rebuilds this cache on each platform.
