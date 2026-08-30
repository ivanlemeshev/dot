# Dotfiles

This context defines a personal system configuration that can set up a fresh operating system. It separates shared command-line configuration from operating-system desktop configuration.

## Language

**Dotfiles v2**:
The new configuration system developed in a separate directory of this repository. It does not change the current dotfiles until it has passed its acceptance tests.
_Avoid_: rewrite, replacement

**Target platform**:
An operating system and desktop environment combination that Dotfiles v2 supports.
_Avoid_: target OS, system

**Platform layer**:
Configuration that is specific to one target platform.
_Avoid_: desktop layer, OS layer

**Shared core**:
Command-line and development configuration that is common to supported target platforms.
_Avoid_: common configuration, universal layer

**Bootstrap**:
An explicit, repeatable command that installs public tools and applies safe system configuration to a fresh target platform.
_Avoid_: installer, setup script

**Migration**:
The controlled change from the current dotfiles to Dotfiles v2 after v2 has passed its acceptance tests.
_Avoid_: replacement, upgrade

**Windows shell boundary**:
Fish runs in MSYS2 as the interactive development shell on Windows. PowerShell remains available for Windows-only administration and bootstrap tasks.
_Avoid_: native Fish, PowerShell replacement

**Shared font stack**:
JetBrains Mono Nerd Font Mono is the primary coding and icon font. Noto Sans Mono CJK and Noto Color Emoji supply missing language and emoji glyphs.
_Avoid_: single universal font
