# Choose the Dotfiles v2 configuration model

Type: grilling
Status: resolved
Blocked by: 02

## Question

Which configuration model and directory structure make the Fedora bootstrap safe, repeatable, testable, and ready for future shared-core and platform-layer support without copying the current dotfiles structure?

## Answer

Dotfiles v2 uses Chezmoi as the cross-platform owner of home-directory configuration. It has one Chezmoi source directory. Chezmoi templates and `.chezmoiignore.tmpl` select platform-specific files from explicit `platform` data. The bootstrap detects and validates one supported target platform, then writes that value into the local Chezmoi data configuration. It stops on an unknown or unsupported target platform.

The Dotfiles v2 layout is:

```text
v2/
  bootstrap.sh
  bootstrap.ps1
  chezmoi/
    .chezmoiignore.tmpl
    .chezmoitemplates/
    dot_config/
  manifests/
    shared-core.toml
    fedora-kde.toml
  adapters/
    fedora-kde.sh
    ubuntu.sh
    arch.sh
    macos.sh
    windows.ps1
```

`shared-core.toml` declares logical tools. Each platform manifest maps them to native package names. Manifests use TOML. Chezmoi owns only home-directory files, templates, and shell hooks. Platform adapters own package installation and allow-listed system settings. The current Fedora KDE Plasma adapter is implemented first. The other adapters are placeholders until those target platforms are supported.

Each bootstrap has a native entry point: `bootstrap.sh` for Linux and macOS, and `bootstrap.ps1` for Windows. Its fixed sequence is: detect and validate the platform; preview privileged actions; apply the privileged adapter stage; apply the standard-user adapter stage; run a Chezmoi diff; apply Chezmoi only after confirmation; then run verification. An unmanaged Chezmoi target stops the bootstrap and lists the conflict. A later migration command may create reviewed timestamped backups.

Mise is the only managed tool version manager. It reads project `.tool-versions` files for asdf compatibility. When a project requires the `asdf` command, asdf is an unactivated project-specific compatibility tool. Legacy asdf plugins are not a native Windows solution. Direnv is included with its Fish hook. Project environments require `direnv allow`; tracked `.envrc` files contain no secrets; local secrets are loaded only from `.env.private` through `dotenv_if_exists`.
