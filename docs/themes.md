# Color themes

## Windows

Run this command from the repository root in PowerShell:

```powershell
.\windows\update-themes.ps1
```

The script updates the custom Windows Terminal palette and theme and selects them for all profiles. It keeps fonts, keybindings, and other settings. It needs no administrator access. Bootstrap applies the same themes with the full terminal settings.

VS Code and the other linked theme files use repository changes when you reload or restart the application.

## Ubuntu, Fedora KDE, and macOS

Ghostty, Konsole, and iTerm2 use linked theme files after setup. Reload or restart the terminal after a theme change. No theme update script is necessary.

## Bat cache

After a change to `bat/themes/custom.tmTheme`, rebuild the theme cache:

```sh
bat cache --build
```

On Ubuntu, use `batcat cache --build`. Bootstrap rebuilds this cache on each platform.
