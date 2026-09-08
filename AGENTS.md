# Agents instructions

## Simplified Technical English

Write ASD-STE100 in a code comment, in `AGENTS.md`, and in the documentation of this repo. One idea in one sentence. The simple present tense. The active voice.

## Comments

Let the code carry the what. Comment only where the code cannot: one short line on the why, on the gotcha, or on the constraint that is not obvious.

Do not repeat the name of the function in a comment above it. Do not explain why something is absent.

## Marker comments

A marker is uppercase, and a colon follows it: `TODO: ...`. Without the colon it is not a marker.

Use these four and no others:

- `TODO:` work that someone must do later.
- `FIXME:` a defect that you see in the code and do not fix now.
- `NOTE:` the why, or the gotcha, of the code below it.
- `WARNING:` what breaks if someone changes that code. Say what breaks.

Do not add a marker of your own.

Apply this to a marker that you write. Do not go and annotate the markers that are already there.

## Git

- Create a branch for changes. Keep `main` for merged work.
- Check the diff before each commit. Stage only files for the current task and use a clear commit message.
- Push branches and create pull requests when the user asks. Keep that permission for the current task.
- Use [the pull request template](.github/pull_request_template.md). Keep descriptions brief and remove sections that do not apply.
- After a squash merge, switch to `main`, pull with `--ff-only`, and delete the merged local and remote branches. Confirm the merge and preserve uncommitted work before cleanup.
- Get explicit permission before you merge, force-push, delete branches outside merge cleanup, or discard uncommitted work.
