# Proposed cleanup manifest

Source commit: `b001cdd9f60a55ae9573d600a0b76252eac92a9d`. Branch: `feat/mise-ubuntu-dotfiles`.

This manifest lists exact tracked paths at this revision. The user approves this cleanup and root promotion on 2026-11-08. The next bootstrap migrates live links after the checkout update. It excludes live home directories and other checkouts. Rebuild the list if the tracked legacy tree changes.

## Conditions before deletion

- The user accepts deferred migration of the dependencies in [the live link audit](LIVE_LINK_AUDIT.md). Bootstrap replaces recognized legacy links after the checkout update.
- Preserve machine data and independent backups outside the managed source tree.
- The user permits removal and recreation of agent directories. The retained portable review skill comes from `ivanlemeshev/skills`.
- Keep the macOS work machine unchanged. Confirm how its old sources remain available before cleanup reaches that checkout.
- Update or replace `.github/workflows/lint.yml` before deleting its `lib/`, `install/`, and `bin/` inputs.
- The user approves removal of the listed legacy paths and promotion outside `mise/`.

Plugin source removal is already in the source commit. Remote plugin installation verification is skipped at the user request. This manifest makes no claim that remote installation passes.

## Retain at root

Keep Git control data, including this worktree's `.git` control file. Retain these tracked files. Review ignore and attribute rules when the new setup moves to root.

```text
.gitattributes
.github/pull_request_template.md
.github/workflows/lint.yml
.github/workflows/mise-migration.yml
.gitignore
.shellcheckrc
AGENTS.md
LICENSE
```

Keep every tracked file under `mise/` during legacy cleanup. Move those files to root only in the later promotion step. The temporary migration workflow remains until the promoted paths pass CI.

## Replace during promotion

Prepare the new root README from `mise/README.md`. Keep the current root README until replacement is ready.

```text
README.md
```

## Proposed tracked deletions

Count: 186 paths. Agent packages are included under the user's recreation decision. This list does not include `.git`, ignored files, or untracked files.

```text
.claude/skills/lem/.claude-plugin/plugin.json
.claude/skills/lem/skills/pdf-summary/SKILL.md
.claude/skills/lem/skills/pdf-summary/scripts/book_coverage.py
.claude/skills/lem/skills/review/SKILL.md
.claude/skills/lem/skills/review/references
.claude/skills/lem/skills/simplify/SKILL.md
.claude/skills/lem/skills/simplify/references
.claude/skills/lem/skills/software-design-review/SKILL.md
.claude/skills/ub-mode/SKILL.md
.codex/skills/lem-pdf-summary/SKILL.md
.codex/skills/lem-pdf-summary/agents/openai.yaml
.codex/skills/lem-pdf-summary/scripts/book_coverage.py
.codex/skills/lem-review/SKILL.md
.codex/skills/lem-review/agents/openai.yaml
.codex/skills/lem-review/references/examples.md
.codex/skills/lem-review/references/review-method.md
.codex/skills/lem-simplify/SKILL.md
.codex/skills/lem-simplify/agents/openai.yaml
.codex/skills/lem-simplify/references/simplification-method.md
.codex/skills/lem-software-design-review/SKILL.md
.codex/skills/lem-software-design-review/agents/openai.yaml
.config/bat/config
.config/bat/themes/custom.tmTheme
.config/emacs/init.el
.config/fish/conf.d/custom_theme.fish
.config/fish/conf.d/fzf_colors.fish
.config/fish/conf.d/ls_colors.fish
.config/fish/config.fish
.config/ghostty/config
.config/ghostty/themes/custom
.config/git/colors
.config/konsole/custom.colorscheme
.config/konsole/dot.profile.in
.config/mise/config.toml
.config/nvim/.stylua.toml
.config/nvim/init.lua
.config/nvim/lua/config/autocmds.lua
.config/nvim/lua/config/diagnostics.lua
.config/nvim/lua/config/filetype_options.lua
.config/nvim/lua/config/helpers.lua
.config/nvim/lua/config/keymaps.lua
.config/nvim/lua/config/large_files.lua
.config/nvim/lua/config/options.lua
.config/nvim/lua/config/pack.lua
.config/nvim/lua/lem/binary.lua
.config/nvim/lua/lem/diagnostic_border.lua
.config/nvim/lua/lem/git_status.lua
.config/nvim/lua/lem/theme.lua
.config/nvim/lua/plugins/autocomplete.lua
.config/nvim/lua/plugins/diagnostics.lua
.config/nvim/lua/plugins/editing.lua
.config/nvim/lua/plugins/essentials.lua
.config/nvim/lua/plugins/explorer.lua
.config/nvim/lua/plugins/filetypes.lua
.config/nvim/lua/plugins/formatting.lua
.config/nvim/lua/plugins/git.lua
.config/nvim/lua/plugins/http.lua
.config/nvim/lua/plugins/indentation.lua
.config/nvim/lua/plugins/lem.lua
.config/nvim/lua/plugins/linting.lua
.config/nvim/lua/plugins/lsp.lua
.config/nvim/lua/plugins/mason.lua
.config/nvim/lua/plugins/search.lua
.config/nvim/lua/plugins/statusline.lua
.config/nvim/lua/plugins/treesitter.lua
.config/nvim/lua/plugins/ui.lua
.config/nvim/plugin/filetypes.lua
.config/oh-my-posh/theme.omp.json
.config/psmux/psmux.conf
.config/ripgrep/config
.config/tmux/.tmux.conf
.config/vim/.vimrc
.dockerignore
Dockerfile
Makefile
bin/bootstrap
bin/bootstrap-fedora.sh
bin/bootstrap-macos.sh
bin/bootstrap-ubuntu.sh
bin/bootstrap.ps1
bin/reset-nvim
bin/set-git-repo-user
config.env.example
docs/README.md
docs/ansi-colors-migration.md
docs/fish.md
docs/fzf.md
docs/neovim.md
docs/tmux.md
install/fedora/bat.sh
install/fedora/clean.sh
install/fedora/codex.sh
install/fedora/dotfiles.sh
install/fedora/emacs.sh
install/fedora/essentials.sh
install/fedora/fish.sh
install/fedora/fzf.sh
install/fedora/gh.sh
install/fedora/ghostty.sh
install/fedora/git.sh
install/fedora/grpcurl.sh
install/fedora/keyboard.sh
install/fedora/konsole.sh
install/fedora/mise.sh
install/fedora/nerd-fonts.sh
install/fedora/nvim.sh
install/fedora/oh-my-posh.sh
install/fedora/openspec.sh
install/fedora/racket.sh
install/fedora/tmux.sh
install/fedora/tree-sitter.sh
install/fedora/update.sh
install/fedora/vim.sh
install/fedora/worktrunk.sh
install/fedora/yt-dlp.sh
install/macos/bat.sh
install/macos/claude-code.sh
install/macos/codex.sh
install/macos/copilot-cli.sh
install/macos/essentials.sh
install/macos/fish.sh
install/macos/gh.sh
install/macos/ghostty.sh
install/macos/git.sh
install/macos/homebrew.sh
install/macos/iterm2.sh
install/macos/mise.sh
install/macos/nerd-fonts.sh
install/macos/nvim.sh
install/macos/oh-my-posh.sh
install/macos/openspec.sh
install/macos/racket.sh
install/macos/tmux.sh
install/macos/tree-sitter.sh
install/macos/update.sh
install/macos/vim.sh
install/macos/vm.sh
install/macos/worktrunk.sh
install/ubuntu/bat.sh
install/ubuntu/claude-code.sh
install/ubuntu/clean.sh
install/ubuntu/codex.sh
install/ubuntu/copilot-cli.sh
install/ubuntu/essentials.sh
install/ubuntu/fish.sh
install/ubuntu/fzf.sh
install/ubuntu/gh.sh
install/ubuntu/git.sh
install/ubuntu/grpcurl.sh
install/ubuntu/mise.sh
install/ubuntu/nerd-fonts.sh
install/ubuntu/nvim.sh
install/ubuntu/oh-my-posh.sh
install/ubuntu/openspec.sh
install/ubuntu/powershell.sh
install/ubuntu/racket.sh
install/ubuntu/specity.sh
install/ubuntu/tmux.sh
install/ubuntu/tree-sitter.sh
install/ubuntu/update.sh
install/ubuntu/vim.sh
install/ubuntu/vm.sh
install/ubuntu/worktrunk.sh
install/ubuntu/yt-dlp.sh
lib/git-colors.sh
lib/link.sh
lib/log.sh
lib/print.sh
lib/prompt.sh
macos/iterm2/custom.json
windows/bootstrap/fonts.ps1
windows/bootstrap/git.ps1
windows/bootstrap/helpers.ps1
windows/bootstrap/keyboard-map.ps1
windows/bootstrap/keyboard.ps1
windows/bootstrap/links-common.ps1
windows/bootstrap/links.ps1
windows/bootstrap/mise.ps1
windows/bootstrap/packages.ps1
windows/bootstrap/terminal.ps1
windows/bootstrap/worktrunk.ps1
windows/powershell/profile.ps1
windows/powershell/yt-dlp.ps1
windows/terminal/settings.json
windows/vscode/keybindings.json
windows/vscode/settings.json
```

## Ignored and untracked files

The scoped ignored-file inventory finds `mise/nvim/nvim-pack-lock.json`. Preserve it during promotion. This audit records names only and does not read ignored file contents. At the source revision, Git reports no untracked files before these audit documents are created. Do not use a blanket clean command.

## Remaining work

The approved legacy deletions and root promotion now run in this feature worktree. No live link changes or backup operations run on the host. Approval of the manifest does not imply permission to change the macOS work machine or Windows Terminal settings. Verify the final cleanup diff against this manifest before a cleanup commit.
