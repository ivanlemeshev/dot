# Agents instructions

## Text style

- Use ASD-STE100 Simplified Technical English in code comments and all repository text, including Markdown files. Write one idea per sentence. Use the simple present tense. Use the active voice.
- Keep each Markdown prose paragraph on one source line. Preserve structural line breaks in lists, tables, and code blocks.
- Format Markdown tables with aligned columns, consistent cell padding, and a header separator row.

## Line endings

Use LF line endings for all repository text files.

## Documentation scope

- Document only information that the user needs to install, use, or maintain the setup.
- Keep the README brief. Put tool-specific details in the relevant guide.
- Update existing text when behavior changes. Add a paragraph only when existing text cannot cover the change.
- Do not add a summary of implementation work to documentation.
- Use short, natural sentences. Do not split related actions into repetitive sentences.

## User-directed changes

- Read all applicable `AGENTS.md` files before each task.
- Before changes, inspect the affected files or system state. Check `git status --short` for repository changes.
- Present a short analysis, plan, or set of options before making changes.
- Make changes only after the user names or selects an action.
- Treat questions and requests for analysis as read-only instructions.
- Keep approval within the stated action and scope.

## Required checks

- After edits, run `mise run format`. Then run `mise run check`.
- After checks pass, review `git diff HEAD` against these instructions. Inspect untracked files from `git status --short`.
- Include one commit title that covers all changes in the final response.

## Comments

- Use one short line to explain a reason, risk, or constraint that the code does not make clear.
- Do not repeat the name of the function in a comment above it. Do not explain why something is absent.
- For new marker comments, use only `TODO:`, `FIXME:`, `NOTE:`, or `WARNING:`. Leave existing markers unchanged.

## Dotfiles design

- Evolve the existing setup in place. Keep one implementation.
- Use the `.sh` extension for all Bash scripts.
- Support Ubuntu 26.04, Fedora KDE Plasma, macOS, and Windows.
- Start bootstrap with Bash or PowerShell and network access. Install Git when it is absent.
- Deploy repository configuration through symlinks. Keep machine data in ignored local files. Do not generate managed configuration from machine data.
- Install each required capability on every supported platform. Keep Caps Lock remapping in the core. Keep optional and desktop-specific behavior in platform extensions.
- Use a native package when available. Verify every adapter installation.
- For bootstrap or package changes, run a real-machine smoke check on each affected platform. Verify bootstrap idempotence.
- For link changes, verify that you can apply and reverse the links on each affected platform.

## Color themes

- Use terminal ANSI colors 0–15 in terminal applications. Prefer colors 0–7 for normal content. Use color 8 for comments and muted borders.
- Use a solid neutral fill with readable text for editor and picker selections. Use blue for active borders and markers. Use black and white for status bars. Underline the active label with the bar colors.
- Keep application color roles independent of terminal palette RGB values.
- Use the same custom palette in Windows Terminal, Ghostty, Konsole, and iTerm2.
- Use default colors in VS Code, including its integrated terminal.
- Maintain native terminal palette files directly.
- Keep installer symlinks in sync with palette file paths.
- Check terminal palette consistency in each terminal.

## Git

- Use `git` and `gh` only for read-only operations.
- Do not run Git or GitHub write operations through aliases, scripts, subprocesses, API requests, or other tools.
- Do not edit `.git` files directly to bypass this rule.
- The user manages `main` as the only branch for future work. Do not create, switch, rename, or delete branches.
