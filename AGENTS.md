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

## Workflow

Use these skills only when needed, in this order:

1. `/grilling`: clarify the next task with one question at a time.
2. `/tdd`: test script behavior before implementation. For simple config edits, check the result directly.
3. `/lem-review`: review the diff before a commit.

Use `/diagnosing-bugs` when something breaks.
Use `/prototype` to try an uncertain approach.

## Git

- Ask for explicit permission before you create a branch. Keep `main` for merged work.
- Check the diff before each commit. Stage only task files. Use a clear commit message.
- Push branches and create pull requests when the user asks. Permission applies to the current task.
- For pull requests, use [the template](.github/pull_request_template.md). Keep descriptions brief. Remove sections that do not apply.
- After a squash merge, confirm the merge and preserve uncommitted work. Then switch to `main`, pull with `--ff-only`, and delete the merged local and remote branches.
- Get explicit permission before you merge, force-push, delete branches outside merge cleanup, or discard uncommitted work.

## Personal skills

Keep Codex personal skill folders and names in the `lem-` namespace.

Keep Claude personal skills in the `lem` plugin namespace.

When you add, change, or remove a personal skill, update both packages.
