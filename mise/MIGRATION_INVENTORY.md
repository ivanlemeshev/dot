# Migration inventory

Source commit: `adc2d16`.
Branch: `feat/mise-ubuntu-dotfiles`.
The initial worktree has no unrelated changes.
The migration plan is already committed at this source revision.

This inventory covers every tracked file outside `mise/` at the source commit.
It excludes private machine values and ignored files.
It is not a deletion approval.
The cleanup manifest uses the selected decisions and the later live link audit.

## Selected decisions

- D01 keeps the approved repository metadata at root.
- D02 retains both utilities as explicit mise tasks.
- D03 moves skill distribution to a separate repository with tagged releases and on-demand installation.
- D04 removes Copilot CLI and Specify CLI support.
- D05 removes VM tooling support.
- D06 removes OpenSpec support from all platforms.
- D07 maps Caps Lock to Ctrl in Ubuntu desktop sessions.
- WSL and containers use the host keyboard mapping.
- D08 uses an explicit one-time import command for existing machine settings.
- D09 retains an optional machine-specific Konsole font override.
- The import preserves the legacy `KDE_TERMINAL_FONT` value.
- D10 uses temporary GitHub Actions jobs for automated verification on all four platforms.
- The macOS work machine stays unchanged.
- D12 upgrades native packages during bootstrap.
- Windows WinGet upgrades apply only to packages declared in mise.
- D13 retains `ub-mode` as an upstream skill with on-demand installation from a pinned commit.
- The final layout promotes mise contents to root after legacy cleanup.

## Additional findings

The legacy Ubuntu and Fedora bootstrap paths run a full system upgrade.
The new bootstrap installs required packages without a full system upgrade.
D12 selects full package upgrades on Unix platforms.
Windows WinGet upgrades use the declared mise packages.
Bootstrap contains native package upgrade steps.
Remote Windows and macOS verification remains pending.

The tracked `codex/` directory also contains a plugin marketplace and language learning plugins.
The skills export includes this distribution tree in its scope review.

The Claude `ub-mode` copy comes from a third-party skill.
D13 keeps its upstream name outside the personal `lem` namespace.
The separate skills repository keeps the installation command.
The Claude package contains tracked symlinks to Codex reference files.
The export must preserve their contents without leaving links into this repository.

The one-time import command exists under D08.
Its verification covers existing local values and repeated imports.
The import preserves existing Git identity when no replacement value exists.
The Ubuntu desktop Caps Lock adapter exists under D07.
WSL and containers use the host keyboard mapping.

## Exact tracked inventory

| Legacy path | Role | Replacement or destination | Disposition |
| --- | --- | --- | --- |
| `.claude/skills/lem/.claude-plugin/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/lem/skills/pdf-summary/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/lem/skills/pdf-summary/scripts/book_coverage.py` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/lem/skills/review/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/lem/skills/review/references` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/lem/skills/simplify/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/lem/skills/simplify/references` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/lem/skills/software-design-review/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.claude/skills/ub-mode/SKILL.md` | Third-party skill | Pinned upstream installation under D13 | Preserve until replacement installation and live link migration pass |
| `.codex/skills/lem-pdf-summary/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-pdf-summary/agents/openai.yaml` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-pdf-summary/scripts/book_coverage.py` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-review/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-review/agents/openai.yaml` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-review/references/examples.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-review/references/review-method.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-simplify/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-simplify/agents/openai.yaml` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-simplify/references/simplification-method.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-software-design-review/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.codex/skills/lem-software-design-review/agents/openai.yaml` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `.config/bat/config` | Application configuration | mise/bat/config | Copied; legacy removal waits for live link migration |
| `.config/bat/themes/custom.tmTheme` | Application configuration | mise/bat/themes/custom.tmTheme | Copied; legacy removal waits for live link migration |
| `.config/emacs/init.el` | Legacy editor | None | Emacs stays excluded; deletion waits for cleanup approval |
| `.config/fish/conf.d/custom_theme.fish` | Application configuration | mise/fish/conf.d/custom_theme.fish | Copied; legacy removal waits for live link migration |
| `.config/fish/conf.d/fzf_colors.fish` | Application configuration | mise/fish/conf.d/fzf_colors.fish | Copied; legacy removal waits for live link migration |
| `.config/fish/conf.d/ls_colors.fish` | Application configuration | mise/fish/conf.d/ls_colors.fish | Copied; legacy removal waits for live link migration |
| `.config/fish/config.fish` | Application configuration | mise/fish/config.fish | Adapted; legacy removal waits for live link migration |
| `.config/ghostty/config` | Application configuration | mise/ghostty/config | Copied; legacy removal waits for live link migration |
| `.config/ghostty/themes/custom` | Application configuration | mise/ghostty/themes/custom | Copied; legacy removal waits for live link migration |
| `.config/git/colors` | Git palette | mise/git/colors | Copied; live Git include links still need migration |
| `.config/konsole/custom.colorscheme` | Konsole configuration | mise/fedora/konsole/custom.colorscheme | Static replacement; local font override exists under D09 |
| `.config/konsole/dot.profile.in` | Konsole configuration | mise/fedora/konsole/dot.profile | Static replacement; local font override exists under D09 |
| `.config/mise/config.toml` | Legacy tool versions | mise/config.toml and platform files | Replaced; live configuration links still need migration |
| `.config/nvim/.stylua.toml` | Application configuration | mise/nvim/.stylua.toml | Copied; legacy removal waits for live link migration |
| `.config/nvim/init.lua` | Application configuration | mise/nvim/init.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/autocmds.lua` | Application configuration | mise/nvim/lua/config/autocmds.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/diagnostics.lua` | Application configuration | mise/nvim/lua/config/diagnostics.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/filetype_options.lua` | Application configuration | mise/nvim/lua/config/filetype_options.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/helpers.lua` | Application configuration | mise/nvim/lua/config/helpers.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/keymaps.lua` | Application configuration | mise/nvim/lua/config/keymaps.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/large_files.lua` | Application configuration | mise/nvim/lua/config/large_files.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/options.lua` | Application configuration | mise/nvim/lua/config/options.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/config/pack.lua` | Application configuration | mise/nvim/lua/config/pack.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/lem/binary.lua` | Application configuration | mise/nvim/lua/lem/binary.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/lem/diagnostic_border.lua` | Application configuration | mise/nvim/lua/lem/diagnostic_border.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/lem/git_status.lua` | Application configuration | mise/nvim/lua/lem/git_status.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/lem/theme.lua` | Application configuration | mise/nvim/lua/lem/theme.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/autocomplete.lua` | Application configuration | mise/nvim/lua/plugins/autocomplete.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/diagnostics.lua` | Application configuration | mise/nvim/lua/plugins/diagnostics.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/editing.lua` | Application configuration | mise/nvim/lua/plugins/editing.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/essentials.lua` | Application configuration | mise/nvim/lua/plugins/essentials.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/explorer.lua` | Application configuration | mise/nvim/lua/plugins/explorer.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/filetypes.lua` | Application configuration | mise/nvim/lua/plugins/filetypes.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/formatting.lua` | Application configuration | mise/nvim/lua/plugins/formatting.lua | Adapted; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/git.lua` | Application configuration | mise/nvim/lua/plugins/git.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/http.lua` | Application configuration | mise/nvim/lua/plugins/http.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/indentation.lua` | Application configuration | mise/nvim/lua/plugins/indentation.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/lem.lua` | Application configuration | mise/nvim/lua/plugins/lem.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/linting.lua` | Application configuration | mise/nvim/lua/plugins/linting.lua | Adapted; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/lsp.lua` | Application configuration | mise/nvim/lua/plugins/lsp.lua | Adapted; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/mason.lua` | Application configuration | mise/nvim/lua/plugins/mason.lua | Adapted; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/search.lua` | Application configuration | mise/nvim/lua/plugins/search.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/statusline.lua` | Application configuration | mise/nvim/lua/plugins/statusline.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/treesitter.lua` | Application configuration | mise/nvim/lua/plugins/treesitter.lua | Adapted; legacy removal waits for live link migration |
| `.config/nvim/lua/plugins/ui.lua` | Application configuration | mise/nvim/lua/plugins/ui.lua | Copied; legacy removal waits for live link migration |
| `.config/nvim/plugin/filetypes.lua` | Application configuration | mise/nvim/plugin/filetypes.lua | Adapted; legacy removal waits for live link migration |
| `.config/oh-my-posh/theme.omp.json` | Application configuration | mise/oh-my-posh/theme.omp.json | Copied; legacy removal waits for live link migration |
| `.config/psmux/psmux.conf` | Application configuration | mise/psmux/psmux.conf | Copied; legacy removal waits for live link migration |
| `.config/ripgrep/config` | Application configuration | mise/ripgrep/config | Copied; legacy removal waits for live link migration |
| `.config/tmux/.tmux.conf` | Application configuration | mise/tmux/.tmux.conf | Copied; legacy removal waits for live link migration |
| `.config/vim/.vimrc` | Application configuration | mise/vim/.vimrc | Copied; legacy removal waits for live link migration |
| `.dockerignore` | Legacy Docker context rules | Prepared final Docker ignore rules | Replace; preserve private file exclusions |
| `.gitattributes` | Repository metadata | Retain at root under D01 | Keep; update rules when the source layout changes |
| `.github/pull_request_template.md` | Repository automation or pull request metadata | Retained root metadata under D01 | Keep; update legacy paths before cleanup |
| `.github/workflows/lint.yml` | Repository automation or pull request metadata | Retained root metadata under D01 | Keep; update legacy paths before cleanup |
| `.gitignore` | Repository metadata | Retain at root under D01 | Keep; update rules when the source layout changes |
| `.shellcheckrc` | Repository metadata | Retain at root under D01 | Keep; update rules when the source layout changes |
| `AGENTS.md` | Repository metadata | Retain at root under D01 | Keep; update rules when the source layout changes |
| `Dockerfile` | Legacy Ubuntu sandbox | mise/Dockerfile and mise/Dockerfile.fedora | Replace after documentation and Makefile updates |
| `LICENSE` | Repository metadata | Retain at root under D01 | Keep; update rules when the source layout changes |
| `Makefile` | Developer commands | Prepared commands for the final layout | Replace legacy lint and sandbox paths |
| `README.md` | Repository documentation | Prepared mise README and final root README | Replace old bootstrap and machine setting instructions |
| `bin/bootstrap` | Legacy bootstrap entrypoint | mise/bootstrap.sh | Replaced; documentation and live installations still need migration |
| `bin/bootstrap-fedora.sh` | Legacy bootstrap entrypoint | mise/bootstrap.sh | Replaced; documentation and live installations still need migration |
| `bin/bootstrap-macos.sh` | Legacy bootstrap entrypoint | mise/bootstrap.sh | Replaced; documentation and live installations still need migration |
| `bin/bootstrap-ubuntu.sh` | Legacy bootstrap entrypoint | mise/bootstrap.sh | Replaced; documentation and live installations still need migration |
| `bin/bootstrap.ps1` | Legacy bootstrap entrypoint | mise/bootstrap.ps1 | Replaced; documentation and live installations still need migration |
| `bin/reset-nvim` | Explicit utility task | Planned mise task | Explicit mise task exists under D02 |
| `bin/set-git-repo-user` | Explicit utility task | Planned mise task | Explicit mise task exists under D02 |
| `codex/.agents/plugins/marketplace.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-dictionary/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-dictionary/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-dictionary/skills/dictionary/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-errors/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-errors/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-errors/skills/error-coach/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-grammar/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-grammar/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-grammar/skills/grammar/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-teacher/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-teacher/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-teacher/skills/english-teacher/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-writing/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-writing/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/english-writing/skills/writing/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-dictionary/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-dictionary/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-dictionary/skills/dictionary/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-grammar/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-grammar/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-grammar/skills/grammar/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-teacher/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-teacher/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-teacher/skills/teacher/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-yki/assets/logo.png` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-yki/plugin.json` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `codex/plugins/suomi-yki/skills/suomi-yki/SKILL.md` | Skill package or skill reference | Separate skills repository from D03 | Preserve until export, release, installation, and live link migration pass |
| `config.env.example` | Legacy local setting example | mise/config.local.toml.example | The D08 import command replaces the legacy settings flow |
| `docs/README.md` | Legacy application documentation | Reviewed documentation in the final layout | Review content and update paths before approved legacy removal |
| `docs/ansi-colors-migration.md` | Legacy application documentation | Reviewed documentation in the final layout | Review content and update paths before approved legacy removal |
| `docs/fish.md` | Legacy application documentation | Reviewed documentation in the final layout | Review content and update paths before approved legacy removal |
| `docs/fzf.md` | Legacy application documentation | Reviewed documentation in the final layout | Review content and update paths before approved legacy removal |
| `docs/neovim.md` | Legacy application documentation | Reviewed documentation in the final layout | Review content and update paths before approved legacy removal |
| `docs/tmux.md` | Legacy application documentation | Reviewed documentation in the final layout | Review content and update paths before approved legacy removal |
| `install/fedora/bat.sh` | Active bootstrap step | mise/bat and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/clean.sh` | Active bootstrap step | mise/linux/tasks/configure/cleanup | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/codex.sh` | Standalone installer | Mise platform installers and a separate skills repository | CLI installation exists; skill transfer and on-demand installer remain pending D03 |
| `install/fedora/dotfiles.sh` | Standalone installer | mise/config.linux.toml | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/emacs.sh` | Active bootstrap step | None | Excluded by prior request; deletion waits for cleanup approval |
| `install/fedora/essentials.sh` | Active bootstrap step | mise/linux/packages and mise/config.macos.toml | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/fish.sh` | Active bootstrap step | mise/fish and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/fzf.sh` | Active bootstrap step | The platform package declarations and mise/fish/conf.d/fzf_colors.fish | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/gh.sh` | Active bootstrap step | mise/linux/tasks/configure/gh and mise/macos/tasks/configure | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/ghostty.sh` | Active bootstrap step | mise/ghostty and the platform package declarations | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/git.sh` | Active bootstrap step | mise/git/config and mise/linux/tasks/configure/git | Shared Git configuration exists; the D08 import command exists |
| `install/fedora/grpcurl.sh` | Active bootstrap step | The Linux grpcurl task and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/keyboard.sh` | Active bootstrap step | mise/fedora/state.py | KDE replacement exists; The selected Ubuntu desktop adapter remains pending under D07 |
| `install/fedora/konsole.sh` | Active bootstrap step | mise/fedora/konsole and mise/fedora/state.py | Shared profile exists; local font override exists under D09 |
| `install/fedora/mise.sh` | Active bootstrap step | mise/bootstrap.sh and mise/config.toml | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/nerd-fonts.sh` | Active bootstrap step | mise/linux/tasks/configure/fonts and macOS font casks | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/nvim.sh` | Active bootstrap step | mise/nvim and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/oh-my-posh.sh` | Active bootstrap step | mise/oh-my-posh and the platform installers | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/openspec.sh` | Standalone installer | None | Mise installation and verification are removed under D06 |
| `install/fedora/racket.sh` | Active bootstrap step | None | Excluded by prior request; deletion waits for cleanup approval |
| `install/fedora/tmux.sh` | Active bootstrap step | mise/tmux and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/tree-sitter.sh` | Active bootstrap step | mise/linux/tasks/configure/tree-sitter and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/update.sh` | Active bootstrap step | Platform bootstrap upgrade adapters under D12 | Bootstrap upgrades native packages under D12 |
| `install/fedora/vim.sh` | Active bootstrap step | mise/vim and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/worktrunk.sh` | Active bootstrap step | mise/linux/tasks/configure/worktrunk and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/fedora/yt-dlp.sh` | Active bootstrap step | Mise Linux tool declaration and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/macos/bat.sh` | Active bootstrap step | mise/bat and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/macos/claude-code.sh` | Standalone installer | Mise platform installers and a separate skills repository | CLI installation exists; skill transfer and on-demand installer remain pending D03 |
| `install/macos/codex.sh` | Standalone installer | Mise platform installers and a separate skills repository | CLI installation exists; skill transfer and on-demand installer remain pending D03 |
| `install/macos/copilot-cli.sh` | Standalone installer | None | Remove capability under D04 or D05; old script remains until cleanup |
| `install/macos/essentials.sh` | Active bootstrap step | mise/linux/packages and mise/config.macos.toml | Replacement exists; final removal still needs cleanup approval |
| `install/macos/fish.sh` | Active bootstrap step | mise/fish and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/macos/gh.sh` | Active bootstrap step | mise/linux/tasks/configure/gh and mise/macos/tasks/configure | Replacement exists; final removal still needs cleanup approval |
| `install/macos/ghostty.sh` | Active bootstrap step | mise/ghostty and the platform package declarations | Replacement exists; final removal still needs cleanup approval |
| `install/macos/git.sh` | Active bootstrap step | mise/git/config and mise/linux/tasks/configure/git | Shared Git configuration exists; the D08 import command exists |
| `install/macos/homebrew.sh` | Active bootstrap step | mise/bootstrap.sh | Covered by macOS bootstrap |
| `install/macos/iterm2.sh` | Active bootstrap step | mise/macos/iterm2 and mise/macos/state.py | Covered; temporary platform CI verification remains pending |
| `install/macos/mise.sh` | Active bootstrap step | mise/bootstrap.sh and mise/config.toml | Replacement exists; final removal still needs cleanup approval |
| `install/macos/nerd-fonts.sh` | Active bootstrap step | mise/linux/tasks/configure/fonts and macOS font casks | Replacement exists; final removal still needs cleanup approval |
| `install/macos/nvim.sh` | Active bootstrap step | mise/nvim and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/macos/oh-my-posh.sh` | Active bootstrap step | mise/oh-my-posh and the platform installers | Replacement exists; final removal still needs cleanup approval |
| `install/macos/openspec.sh` | Standalone installer | None | Mise installation and verification are removed under D06 |
| `install/macos/racket.sh` | Active bootstrap step | None | Excluded by prior request; deletion waits for cleanup approval |
| `install/macos/tmux.sh` | Active bootstrap step | mise/tmux and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/macos/tree-sitter.sh` | Active bootstrap step | mise/linux/tasks/configure/tree-sitter and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/macos/update.sh` | Standalone installer | Platform bootstrap upgrade adapters under D12 | Bootstrap upgrades native packages under D12 |
| `install/macos/vim.sh` | Active bootstrap step | mise/vim and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/macos/vm.sh` | Standalone installer | None | Remove capability under D04 or D05; old script remains until cleanup |
| `install/macos/worktrunk.sh` | Active bootstrap step | mise/linux/tasks/configure/worktrunk and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/bat.sh` | Active bootstrap step | mise/bat and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/claude-code.sh` | Standalone installer | Mise platform installers and a separate skills repository | CLI installation exists; skill transfer and on-demand installer remain pending D03 |
| `install/ubuntu/clean.sh` | Active bootstrap step | mise/linux/tasks/configure/cleanup | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/codex.sh` | Standalone installer | Mise platform installers and a separate skills repository | CLI installation exists; skill transfer and on-demand installer remain pending D03 |
| `install/ubuntu/copilot-cli.sh` | Standalone installer | None | Remove capability under D04 or D05; old script remains until cleanup |
| `install/ubuntu/essentials.sh` | Active bootstrap step | mise/linux/packages and mise/config.macos.toml | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/fish.sh` | Active bootstrap step | mise/fish and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/fzf.sh` | Active bootstrap step | The platform package declarations and mise/fish/conf.d/fzf_colors.fish | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/gh.sh` | Active bootstrap step | mise/linux/tasks/configure/gh and mise/macos/tasks/configure | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/git.sh` | Active bootstrap step | mise/git/config and mise/linux/tasks/configure/git | Shared Git configuration exists; the D08 import command exists |
| `install/ubuntu/grpcurl.sh` | Active bootstrap step | The Linux grpcurl task and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/mise.sh` | Active bootstrap step | mise/bootstrap.sh and mise/config.toml | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/nerd-fonts.sh` | Active bootstrap step | mise/linux/tasks/configure/fonts and macOS font casks | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/nvim.sh` | Active bootstrap step | mise/nvim and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/oh-my-posh.sh` | Active bootstrap step | mise/oh-my-posh and the platform installers | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/openspec.sh` | Standalone installer | None | Mise installation and verification are removed under D06 |
| `install/ubuntu/powershell.sh` | Standalone installer | Mise platform tool declarations | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/racket.sh` | Active bootstrap step | None | Excluded by prior request; deletion waits for cleanup approval |
| `install/ubuntu/specity.sh` | Standalone installer | None | Remove capability under D04 or D05; old script remains until cleanup |
| `install/ubuntu/tmux.sh` | Active bootstrap step | mise/tmux and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/tree-sitter.sh` | Active bootstrap step | mise/linux/tasks/configure/tree-sitter and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/update.sh` | Active bootstrap step | Platform bootstrap upgrade adapters under D12 | Bootstrap upgrades native packages under D12 |
| `install/ubuntu/vim.sh` | Active bootstrap step | mise/vim and the platform configure tasks | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/vm.sh` | Standalone installer | None | Remove capability under D04 or D05; old script remains until cleanup |
| `install/ubuntu/worktrunk.sh` | Active bootstrap step | mise/linux/tasks/configure/worktrunk and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `install/ubuntu/yt-dlp.sh` | Active bootstrap step | Mise Linux tool declaration and the macOS native package | Replacement exists; final removal still needs cleanup approval |
| `lib/git-colors.sh` | Legacy installer or utility helper | Platform adapters and planned utility tasks | Keep until remaining bin utilities and CI references have replacements |
| `lib/link.sh` | Legacy installer or utility helper | Platform adapters and planned utility tasks | Keep until remaining bin utilities and CI references have replacements |
| `lib/log.sh` | Legacy installer or utility helper | Platform adapters and planned utility tasks | Keep until remaining bin utilities and CI references have replacements |
| `lib/print.sh` | Legacy installer or utility helper | Platform adapters and planned utility tasks | Keep until remaining bin utilities and CI references have replacements |
| `lib/prompt.sh` | Legacy installer or utility helper | Platform adapters and planned utility tasks | Keep until remaining bin utilities and CI references have replacements |
| `macos/iterm2/custom.json` | Application configuration | mise/macos/iterm2/custom.json | Copied; legacy removal waits for live link migration |
| `windows/bootstrap/fonts.ps1` | Windows bootstrap module | mise/windows/fonts.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/git.ps1` | Windows bootstrap module | mise/git/config and mise/windows/helpers.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/helpers.ps1` | Windows bootstrap module | mise/windows/helpers.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/keyboard-map.ps1` | Windows bootstrap module | mise/windows/keyboard-map.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/keyboard.ps1` | Windows bootstrap module | mise/windows/keyboard.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/links-common.ps1` | Windows bootstrap module | mise/windows/helpers.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/links.ps1` | Windows bootstrap module | mise/config.windows.toml and mise/windows/helpers.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/mise.ps1` | Windows bootstrap module | mise/bootstrap.ps1 and mise/windows/toolchains.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/packages.ps1` | Windows bootstrap module | mise/config.windows.toml and mise/windows/toolchains.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/terminal.ps1` | Windows bootstrap module | mise/windows/terminal.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/bootstrap/worktrunk.ps1` | Windows bootstrap module | mise/windows/powershell/profile.ps1 | Replacement exists; Windows migration and full installation check remain pending |
| `windows/powershell/profile.ps1` | Application configuration | mise/windows/powershell/profile.ps1 | Adapted; legacy removal waits for live link migration |
| `windows/powershell/yt-dlp.ps1` | Application configuration | mise/windows/powershell/yt-dlp.ps1 | Copied; legacy removal waits for live link migration |
| `windows/terminal/settings.json` | Application configuration | mise/windows/terminal/settings.json | Copied; legacy removal waits for live link migration |
| `windows/vscode/keybindings.json` | Application configuration | mise/windows/vscode/keybindings.json | Adapted; legacy removal waits for live link migration |
| `windows/vscode/settings.json` | Application configuration | mise/windows/vscode/settings.json | Copied; legacy removal waits for live link migration |

Total tracked files outside `mise/`: 222.

Git control data is an additional retained item.
In this checkout, `.git` is a worktree control file.
The cleanup does not move or delete it.

## Remaining inventory gates

- [ ] Record the remaining capability and settings decisions.
- [ ] Confirm the separate skills repository name, ownership, and visibility before repository creation.
- [ ] Audit ignored local files by name without recording their private contents.
- [ ] Refresh the live machine link audit before deletion.
- [ ] Convert the proposed dispositions into an explicit approved deletion manifest.
