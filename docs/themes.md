# Color themes

## Select a palette

After bootstrap, use these commands to list palettes, show the current palette, or select a palette:

```sh
mise run palette list
mise run palette current
mise run palette use charcoal-pastel
```

An asterisk marks the current palette in the list. If your selected palette is gone, select the default, `charcoal-pastel`. Reload or restart the terminal after a switch.

The palette applies to Ghostty, Konsole, iTerm2, and Windows Terminal. Neovim, Vim, and fzf use the terminal defaults for normal text. VS Code uses its default colors.

On Windows, a palette change keeps your shortcuts, font, and other settings outside the palette. The unapply task protects local edits from replacement by the original backup.

## Highlighting mode

Use `mise run palette mode min` for minimal highlighting or `mise run palette mode full` for full highlighting. Run `mise run palette mode` to see the current mode. You can switch palettes in either mode.

In minimal mode, most code uses the normal text color. Comments stay muted, strings keep their color, and definitions use an accent. The shell, search tools, Git, and multiplexer keep strong colors for cues such as matches, errors, and active labels.

Start a new shell and restart open editors to load the mode. Start a new tmux or Psmux server to apply the mode to its status bar.

## Add a palette

Copy a directory under `palettes/` and edit its four native palette files. Use a name that starts with a lowercase letter and contains only lowercase letters, digits, or hyphens. Keep all 16 ANSI colors consistent across the four files. Keep the `custom` scheme names and the iTerm2 profile identifier.

Add the palette and its ANSI colors to `EXPECTED` in `tests/test_palettes.py`. Run `mise run test:palettes`.

## Bat cache

After you change a file in `bat/themes/`, run `bat cache --build`. On Ubuntu, run `batcat cache --build`.
