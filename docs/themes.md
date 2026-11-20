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

| Palette                      | Appearance                                                |
| ---------------------------- | --------------------------------------------------------- |
| `charcoal-pastel`            | Charcoal background with soft accents                     |
| `warm-earth`                 | Brown, olive, and cream tones                             |
| `cold-graphite`              | Cool gray background                                      |
| `deep-ocean`                 | Dark blue background                                      |
| `violet-graphite`            | Dark violet background                                    |
| `solarized-dark-soft`        | Blue-green background with brighter accents               |
| `gruvbox-material-dark`      | Dark gray background with warm accents                    |
| `gruvbox-material-dark-hard` | Darker background with brighter text and comments         |
| `everforest-dark`            | Gray-green background                                     |
| `everforest-dark-hard`       | Darker background with brighter text and comments         |
| `commodore-64-soft`          | Charcoal background with soft C64 colors                  |
| `ibm-sga-soft`               | Charcoal background with soft CGA colors                  |
| `ibm-5151-green`             | Green text on a dark green background                     |
| `dec-vt220-amber`            | Amber text on a dark brown background                     |
| `amiga-workbench`            | Blue-gray background with soft accents                    |
| `apple-ii`                   | Dark background with bright accents                       |
| `nextstep`                   | Charcoal background with gray accents                     |
| `risc-os`                    | Gray background with soft accents                         |
| `sgi-irix`                   | Dark blue background with cool accents                    |
| `ibm-3279`                   | Dark green background with soft accents                   |
| `dec-vt340`                  | Dark blue background with soft accents                    |
| `atari-st`                   | Dark gray background with soft accents                    |
| `mac-system-7`               | Dark gray background with gray accents                    |
| `zx-spectrum`                | Dark background with subdued accents                      |
| `spacedust`                  | Dark teal background with cyan, green, and orange accents |
| `min-gruvbox-dark`           | Warm dark background with Min Gruvbox accents             |
| `min-gruvbox-light`          | Cream background with Min Gruvbox accents                 |
| `min-kanagawa-dark`          | Dark Dragon background with Min Kanagawa accents          |
| `min-kanagawa-light`         | Pale Lotus background with Min Kanagawa accents           |
| `alabaster-dark`             | Dark teal background with Alabaster Dark terminal colors  |
| `alabaster-light`            | Near-white background with Alabaster terminal colors      |

The selection stays in `~/.local/state/dotfiles-palette/selection`. Bootstrap keeps this selection. Switching palettes does not change repository files. Reload or restart the terminal after a switch.

Ghostty, Konsole, and iTerm2 use links to the selected native palette files. Windows Terminal receives the selected palette and theme in its local settings. The script keeps its fonts, keybindings, and other settings. VS Code uses its default colors. The palette command does not change VS Code.

## Palette sources

[`spacedust`](https://github.com/marcelbeumer/spacedust.vim/blob/master/colors/spacedust.vim) maps the Vim theme colors to ANSI slots. It uses the `Normal` background and foreground and the `Comment` color for ANSI 8. The Vim theme does not define a terminal ANSI palette.

The `min-*` palettes use the [Min Gruvbox and Kanagawa flavors](https://github.com/dybdeskarphet/min.nvim/tree/6ebcf3847b3aa42fe05b3c5c1ff33991a5af6007/lua/min/flavors) with `contrast = "low"`. ANSI 0 uses the editor background (`base_01`). ANSI 8 uses `base_07`. ANSI 7 and 15 use `base_15`. Normal and bright accents use the same upstream colors. The light variants use a light background and dark text.

The Alabaster palettes use the terminal colors from [Alabaster Light](https://github.com/tonsky/vscode-theme-alabaster/blob/7e8e48c0f33022cd3cf5fec0114c307d63663e39/theme/alabaster-color-theme.json) and the [Alabaster Dark port](https://github.com/gargakshit/vscode-theme-alabaster-dark/blob/b9b4d2904b1e7e4a0b79eed65979f3799e4b3993/themes/alabaster-dark-color-theme.json) that the original project links to. ANSI 0 and 7 use the editor background and foreground. ANSI 15 also uses the editor foreground in the light palette. Other ANSI slots keep the upstream terminal colors.

## Add a palette

Copy a directory under `palettes/` and edit its four native palette files. Use a name that starts with a lowercase letter and contains only lowercase letters, digits, or hyphens. Keep all 16 ANSI colors consistent across the four files. Keep the `custom` scheme names and the iTerm2 profile identifier.

Run `mise run test:palettes` to check the included palettes and the switcher.

## Bat cache

After a change to `bat/themes/custom.tmTheme`, rebuild the theme cache:

```sh
bat cache --build
```

On Ubuntu, use `batcat cache --build`. Bootstrap rebuilds this cache on each platform.
