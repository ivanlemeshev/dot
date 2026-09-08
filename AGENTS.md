# Agents instructions

## Simplified Technical English

Use ASD-STE100 in code comments, `AGENTS.md`, and repo documentation. Write one idea per sentence. Use the simple present tense. Use the active voice.

## Comments

Use one short line to explain a reason, risk, or constraint that the code does not make clear.

Do not repeat the name of the function in a comment above it. Do not explain why something is absent.

### Markers

For new marker comments, use only these uppercase labels with a colon. Leave existing markers unchanged.

- `TODO:` work to do later.
- `FIXME:` a known defect that remains unfixed.
- `NOTE:` a reason or risk in the code below.
- `WARNING:` what breaks if someone changes the code below.

## Git

- Create a branch for changes. Keep `main` for merged work.
- Check the diff before each commit. Stage only task files. Use a clear commit message.
- Push branches and create pull requests when the user asks. Permission applies to the current task.
- For pull requests, use [the template](.github/pull_request_template.md). Keep descriptions brief. Remove sections that do not apply.
- After a squash merge, confirm the merge and preserve uncommitted work. Then switch to `main`, pull with `--ff-only`, and delete the merged local and remote branches.
- Get explicit permission before you merge, force-push, delete branches outside merge cleanup, or discard uncommitted work.

## Personal skills

When you add, change, or remove a personal skill, update both the Codex and Claude packages.
