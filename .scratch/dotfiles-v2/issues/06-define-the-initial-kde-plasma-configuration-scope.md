# Define the initial KDE Plasma configuration scope

Type: grilling
Status: resolved
Blocked by: 04

## Question

Which KDE Plasma settings and visual choices belong in the first Fedora KDE Plasma platform layer, and which must remain outside the bootstrap until a later decision?

## Answer

The first Fedora KDE Plasma platform layer maps Caps Lock to Ctrl and disables the keyboard diacritics popup. Both settings are in the system-settings allow-list.

It does not set a wallpaper, global theme, icons, panel layout, widgets, window decorations, display, power, notification, workspace, shortcut, touchpad, or window-management settings. Ghostty configuration remains home-directory configuration that Chezmoi owns. Konsole configuration is excluded because Ghostty is the selected terminal.
