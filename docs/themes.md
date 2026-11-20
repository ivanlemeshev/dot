# Color themes

## Select a palette

Run these commands after bootstrap:

```sh
mise run palette list
mise run palette current
mise run palette use charcoal-pastel
mise run palette use warm-earth
```

`charcoal-pastel` is the default palette. An asterisk marks the selected palette in the list.

| Palette | Appearance |
| --- | --- |
| `charcoal-pastel` | Charcoal background with soft accents |
| `warm-earth` | Brown, olive, and cream tones |
| `cold-graphite` | Cool gray background |
| `deep-ocean` | Dark blue background |
| `violet-graphite` | Dark violet background |
| `solarized-dark` | Blue-green background with brighter accents |
| `gruvbox-material-dark` | Dark gray background with warm accents |
| `gruvbox-material-dark-hard` | Darker background with brighter text and comments |
| `everforest-dark` | Gray-green background |
| `everforest-dark-hard` | Darker background with brighter text and comments |
| `commodore-64-soft` | Charcoal background with soft C64 colors |
| `ibm-sga-soft` | Charcoal background with soft CGA colors |
| `ibm-5151-green` | Green text on a dark green background |
| `dec-vt220-amber` | Amber text on a dark brown background |
| `amiga-workbench` | Blue-gray background with soft accents |
| `apple-ii` | Dark background with bright accents |
| `nextstep` | Charcoal background with gray accents |
| `risc-os` | Gray background with soft accents |
| `sgi-irix` | Dark blue background with cool accents |
| `ibm-3279` | Dark green background with soft accents |
| `dec-vt340` | Dark blue background with soft accents |
| `atari-st` | Dark gray background with soft accents |
| `mac-system-7` | Dark gray background with gray accents |
| `zx-spectrum` | Dark background with subdued accents |

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
