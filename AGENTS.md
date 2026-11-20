# Agents instructions

## Simplified Technical English

Use ASD-STE100 Simplified Technical English in code comments and all repository text, including Markdown files. Write one idea per sentence. Use the simple present tense. Use the active voice.

## Line endings

Use LF line endings for all repository text files.

## Markdown

Keep each Markdown prose paragraph on one source line. Preserve structural line breaks in lists, tables, and code blocks.

Format Markdown tables with aligned columns, consistent cell padding, and a header separator row.

## Documentation scope

- Document only information that the user needs to install, use, or maintain the setup.
- Keep the README brief. Put tool-specific details in the relevant guide.
- Update existing text when behavior changes. Add a paragraph only when existing text cannot cover the change.
- Do not add a summary of implementation work to documentation.
- Use short, natural sentences. Do not split related actions into repetitive sentences.

## User-directed changes

- Read all applicable `AGENTS.md` files before each task.
- For requests that may change files or system state, first inspect the relevant state.
- For repository changes, inspect the worktree before editing.
- Present a short analysis, plan, or set of options before making changes.
- Make changes only after the user names or selects an action.
- Treat questions and requests for analysis as read-only instructions.
- Keep approval within the stated action and scope.
- Update `README.md` when you change a command, a flag, or a `mise` task.
- Review the final diff against the applicable instructions before finishing.

## Required checks

- After edits, run `mise run format`. Then run `mise run check`.
- When the work is complete and the required checks pass, run `git diff HEAD`. Also inspect untracked files from `git status --short`.
- Include one commit title that covers all changes in the final response.

## Comments

Use one short line to explain a reason, risk, or constraint that the code does not make clear.

Do not repeat the name of the function in a comment above it. Do not explain why something is absent.

### Markers

For new marker comments, use only these uppercase labels with a colon. Leave existing markers unchanged.

- `TODO:` work to do later.
- `FIXME:` a known defect that remains unfixed.
- `NOTE:` a reason or risk in the code below.
- `WARNING:` what breaks if someone changes the code below.

## Dotfiles design

- Evolve the existing setup in place. Keep one implementation.
- Use the `.sh` extension for all Bash scripts.
- Support Ubuntu 26.04, Fedora KDE Plasma, macOS, and Windows.
- Start bootstrap with Bash or PowerShell and network access. Install Git when it is absent.
- Deploy repository configuration through symlinks. Keep machine data in ignored local files. Do not generate managed configuration from machine data.
- Install each required capability on every supported platform. Keep Caps Lock remapping in the core. Keep optional and desktop-specific behavior in platform extensions.
- Use a native package when available. Verify every adapter installation.
- Run a real-machine smoke check on each affected platform. Verify bootstrap idempotence and reversible link changes.

## Color themes

- Use terminal ANSI colors 0–15 in terminal applications. Prefer colors 0–7 for normal content. Use color 8 for comments and muted borders.
- Use black text on blue for selection. Use blue for active borders. Keep status bars black with white text and yellow active labels.
- Keep application color roles independent of terminal palette RGB values.
- Use the same custom palette in Windows Terminal, Ghostty, Konsole, iTerm2, and the VS Code terminal.
- Maintain native terminal palette files directly.
- Keep installer symlinks in sync with palette file paths.
- Check terminal palette consistency in each terminal.

## Git

- Use `git` and `gh` only for read-only operations. Apply this rule to aliases, scripts, and `gh api` requests.
- For pull requests, use [the template](.github/pull_request_template.md). Keep descriptions brief. Remove sections that do not apply.
