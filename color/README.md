# Color Scheme

## Files

- `color-scheme.yaml` — source of truth for the color scheme
- `extend-color-scheme` — script that converts hex colors to iTerm2 RGB float
  values and writes them into the YAML file

## Schema

```yaml
name: "My Scheme"
hex:
  foreground: "#rrggbb"
  background: "#rrggbb"
  colors:
    black: "#rrggbb"
    red: "#rrggbb"
    green: "#rrggbb"
    yellow: "#rrggbb"
    blue: "#rrggbb"
    magenta: "#rrggbb"
    cyan: "#rrggbb"
    white: "#rrggbb"
    brightBlack: "#rrggbb"
    brightRed: "#rrggbb"
    brightGreen: "#rrggbb"
    brightYellow: "#rrggbb"
    brightBlue: "#rrggbb"
    brightMagenta: "#rrggbb"
    brightCyan: "#rrggbb"
    brightWhite: "#rrggbb"
```

All 18 keys are required. Key names and order must match exactly.

## Usage

1. Copy `color-scheme.yaml` and fill in your hex values under `hex:`.
2. Run the script:

```sh
./extend-color-scheme my-scheme.yaml
```

The script appends (or replaces) an `iterm2:` section with the same structure,
converting each hex color to 18-decimal-place RGB float components as required
by iTerm2. The `hex:` section is not modified.
