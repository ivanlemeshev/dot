# Agent instructions

- Complete authorized work and relevant verification. Make routine decisions independently; ask when missing information materially changes the outcome.
- Follow the user's instructions over repository and skill guidance, within system and developer constraints. If a skill blocks progress, identify the file and rule.
- Keep changes focused and preserve unrelated work.
- Use ASD-STE100 Simplified Technical English for replies and documentation. Keep code identifiers, commands, and file paths unchanged. Report the changes, the checks, and any remaining limitations.
- Keep Markdown paragraphs and list items on single source lines. Do not hard-wrap prose at 80 characters or another fixed width.
- Run checks appropriate to the change. Add tests for meaningful behavior and avoid redundant verification.
- Test installers and file-linking behavior in temporary or disposable environments. Preserve existing user files and verify repeated runs.
- Keep credentials and machine-specific values out of tracked files and tool output.

## Git

- Create a branch for changes. Keep `main` for merged work.
- Check the diff before each commit. Stage only files for the current task and use a clear commit message.
- Push branches and create pull requests when the user asks. Keep that permission for the current task.
- Write pull request descriptions with the purpose, changes, and check results.
- Get explicit permission before you merge, force-push, delete remote branches, or discard uncommitted work.
