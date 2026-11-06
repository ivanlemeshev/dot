# Ubuntu setup with mise

This folder holds a separate Ubuntu setup. It does not change the existing setup.

Clone this repository on Ubuntu 26.04.

## Machine settings

Copy the example file if you want local machine and Git values:

```sh
cp mise/config.local.toml.example mise/config.local.toml
```

Edit `mise/config.local.toml` before setup. Mise loads it as a global configuration override.

The setup links `~/.config/mise` to `mise`. Mise then loads one global `config.toml` for packages, tools, dotfiles, and tasks.

The setup stops if `~/.config/mise` already exists and points elsewhere. Move that directory before setup to keep its current contents.

Git ignores `config.local.toml`. Docker excludes it from the build context. The example lists the Ubuntu fields from `config.env.example`.

The setup applies `TIMEZONE` and the Git values from this file. It stores Git settings in `~/.config/git/config.local`. The managed `~/.gitconfig` includes that local file.

The default time zone is UTC. The default Git branch is `main`. The setup leaves Git identity unset when you omit it. `MACHINE_NAME` sets the Ubuntu hostname.

Run one command from the repository root:

```sh
./mise/bootstrap.sh
```

The script installs Git, curl, mise, Ubuntu packages, and mise tools. It links the application configuration. It installs Fish plugins, Nerd Fonts, the Tree-sitter CLI, Neovim tools, and Neovim parsers. It checks the setup. It then starts Fish with mise active.

The setup installs Fish, fzf, Vim, and Ghostty from Ubuntu packages. GitHub CLI uses its official apt repository. It installs Neovim from the latest stable GitHub release.

The script runs from Bash and ends in Fish. This matches the current Ubuntu bootstrap flow.

Use the dry run to review package and link changes first. This mode requires mise. It does not install packages or change links:

```sh
./mise/bootstrap.sh --dry-run
```

To test in Docker, build and run the same one-command setup:

```sh
docker build --file mise/Dockerfile --tag dot-mise-current .
docker run --rm dot-mise-current ./bootstrap.sh --no-shell
```

Docker excludes `config.local.toml`. Pass environment variables to `docker run` if you want to test local values in the container. Set a container hostname with Docker's `--hostname` option.

Use `--no-shell` to stop after verification.

Run `mise run verify` and `mise dot status --missing` from any directory to review the result. Run `mise dot unapply` to remove managed dotfile links.

To remove the global config link, run this command from the repository root after `mise dot unapply`:

```sh
test "$(readlink -f "$HOME/.config/mise")" = "$(readlink -f mise)" && rm "$HOME/.config/mise"
```

Edit `config.local.toml` to set a Git user name and email. The setup keeps these values outside the shared configuration.

Application directories sit beside `config.toml`. Mise links them to the paths that each application reads. Fish links `config.fish` and each managed file in `conf.d/`. Fish keeps plugin files in the home configuration directory.

The `tasks/` directory holds executable Mise tasks. Long setup actions use Bash file tasks. Mise reads each task description from its `#MISE` header. Short commands and task dependencies stay in `config.toml`.

The terminal controls the ANSI palette. Mise enables automatic CLI colors and keeps `NO_COLOR` unset in activated shells. It links the custom bat theme and builds the bat cache. Fish sets the fzf color roles. Git uses automatic color output. GitHub CLI uses accessible 4-bit colors. Vim and Neovim use the custom ANSI color roles. Neovim's status line uses ANSI color indexes 0–15. Tmux and Oh My Posh use terminal colors. The setup links Ghostty to the custom terminal palette. It keeps psmux outside the Ubuntu task and link lists. PowerShell runs on Ubuntu through mise for the PowerShell language server.

Bootstrap stops before package changes if the global mise configuration points elsewhere. It preserves that configuration. Move it before setup to select this configuration. Bootstrap does not upgrade all system packages or remove unused packages.

Neovim setup waits for Mason tools and Tree-sitter parsers. Verification fails if a required tool, parser, or managed link is missing.

Bash activation keeps PATH setup and mise activation in one managed block. Link removal and restoration keep this order.
