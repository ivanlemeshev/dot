---
name: review
description:
  Review a pull request. Use when the user asks to review a PR, review pull
  request changes, or run a code review on a GitHub pull request.
---

# Review a pull request

You are an expert code reviewer. Follow these steps.

## Gather context

1. If no PR number is provided in the args, run `gh pr list` to show open PRs
   and ask which one to review.
2. If a PR number is provided, run
   `gh pr view <number> --json title,body,author,baseRefName,headRefName,state,additions,deletions,changedFiles,labels`
   to get PR details.
3. Run `gh pr diff <number>` to get the diff.

## Scope

Review only the code changes that are relevant to the PR. Do not comment on
pre-existing code outside the diff, unrelated files, or lines the PR did not
touch.

## What to look for

Based on Google's engineering practices ("What to look for in a code review").
Evaluate the change across these dimensions:

- **Design**: Do the pieces of the change fit together well, and does this
  change belong in this codebase rather than a library or a different layer?
- **Functionality**: Does the code do what the author intended, handle edge
  cases, and avoid concurrency or error-handling bugs? Consider users, not just
  the happy path.
- **Complexity**: Is the code more complex than it needs to be? Flag
  over-engineering and speculative generality. Prefer solutions a future reader
  understands quickly.
- **Tests**: Are there appropriate unit, integration, or end-to-end tests, and
  are they correct, useful, and not overly brittle?
- **Naming**: Do names clearly communicate what a thing is or does without being
  overly long?
- **Comments**: Do comments explain _why_ the code exists, not _what_ it does?
  Redundant "what" comments should be removed or replaced by clearer code.
- **Style and consistency**: Does the change follow the project's style guide
  and stay consistent with surrounding code? Style guide is authoritative on
  formatting.
- **Documentation**: If behavior, build, test, or interaction steps changed, are
  the relevant docs (READMEs, references) updated?
- **Every line**: Review every line of human-written code in the diff. Skim only
  generated files or large data blobs, and say so.
- **Context**: Look at the change in the context of the whole file and system,
  not just the diff hunks. Does it improve overall code health?
- **Security, performance, correctness**: Flag security holes, performance
  regressions, and correctness bugs.
- **Good things**: Call out well-done work when you see it, briefly.

## The standard of review

From Google's "The Standard of Code Review":

- Recommend approval once the change definitely improves the overall code health
  of the system, even if it is not perfect. Do not block a change because you
  would have written it differently.
- There is no "perfect" code, only better code. Do not demand polish that does
  not affect code health.
- Facts and data (and the style guide) beat personal preference. If the author
  presents a valid alternative that is roughly equal, defer to their choice.
- Map severity to the importance levels below. Purely optional or cosmetic
  points map to `minor`; if a point is truly take-it-or-leave-it, drop it per
  the comment rules.

## Output format

Start with a one-paragraph overview of what the PR does.

Then list all issues as a bulleted list (not a table). For each issue:

- Start with an importance level: `critical`, `major`, or `minor`.
- Include the relative path to the file and the line number or line range,
  formatted as `path:line` or `path:start-end`.
- Write a clear, short comment: concise, focused on a single point, actionable,
  and giving the author guidance to address the concern.

### Comment rules

- Keep each comment to 1-2 sentences: state the problem, then the fix. Do not
  explain the reasoning chain or justify why it matters.
- Do not hedge or add caveats (e.g. "it's harmless, but..."). If an issue is
  harmless, either lower its importance or drop it.
- Reference code with `path:line` instead of describing what the code does.
- Give one concrete suggestion, not a menu of alternatives.
- Comment on the code, never on the author. No "you forgot"; write "missing
  error check".
- Prefer fixing unclear code over explaining it in the review. If a comment
  would be needed to understand the code, suggest the code change that removes
  the need for it.
- These concise-output rules override Google's "explain the why" guidance: state
  the problem and the fix, and let the importance level carry the priority
  instead of a `Nit:` / `Optional:` prefix.

### Example

- `critical` `internal/auth/token.go:42` — Token compared with `==`, vulnerable
  to timing attacks. Use `subtle.ConstantTimeCompare`.
- `major` `internal/api/handler.go:88-95` — Error from `json.Unmarshal` is
  ignored. Return it to the caller.
- `minor` `internal/store/user.go:17` — Unused variable `ctx`. Remove it.

PR number: $ARGUMENTS
