# Review method

Review the selected change deeply enough to find real defects while keeping every finding scoped, evidenced, and useful to the author.

## Resolve the target

Explicit user input wins. Normalize it to one of these targets:

- Pull request number or URL: read PR metadata and the diff with read-only `gh` commands.
- Branch or revision range: compare the requested revisions from their merge base unless the user explicitly requests two-dot semantics.
- Staged changes: inspect `git diff --cached`.
- Working tree: inspect staged and unstaged changes plus relevant untracked files.

Without an explicit target, use the working tree when it has changes. Otherwise, compare the current branch with a confidently detected default branch or upstream. Ask the user when more than one target is plausible or the base cannot be established safely. Never guess that the default branch is `main`.

Record the resolved target precisely enough that the user can reproduce the diff. Do not checkout a PR, fetch changes, switch branches, or otherwise mutate the repository unless the user separately authorizes that action.

## Establish intent and context

Before judging the implementation:

1. Read the user's request and available change metadata.
2. Read applicable repository instructions and conventions.
3. Read the complete changed files, not only isolated diff hunks.
4. Follow relevant callers, consumers, interfaces, configuration, tests, and error paths according to the change's blast radius.
5. Use clearly applicable requirements, design records, issue descriptions, or planning artifacts as evidence. Do not require a particular framework and do not guess that an unrelated artifact applies.

Focus on behavior introduced or exposed by the target. Do not report an unrelated pre-existing problem unless the change makes it reachable, more severe, or newly relevant.

## Analyze the change

Evaluate relevant dimensions rather than mechanically commenting on each one:

- Correctness and edge cases, including state transitions, boundary values, errors, and concurrency.
- Security and privacy, including trust boundaries, authorization, secrets, injection, and unsafe defaults.
- Compatibility of public APIs, persisted data, configuration, migrations, and downstream consumers.
- Reliability and observability, including retries, partial failure, cleanup, and actionable diagnostics.
- Performance when the changed path can materially affect resource usage or latency.
- Design and maintainability when structure creates a concrete operational or correctness risk.
- Tests and documentation when changed behavior needs coverage or user-facing explanation.

Generated files and large data blobs may be skimmed when their source is reviewed. Disclose that limitation.

## Gate findings on evidence

Report a finding only when all of these are established:

- The reviewed change introduces or exposes it.
- A specific condition triggers it.
- The resulting incorrect behavior or impact is concrete.
- Inspected code or an applicable contract supports it.
- One appropriate, executable remediation can be recommended.
- The finding can be anchored to the narrowest useful changed line.

Investigate plausible candidates before deciding. Drop candidates that remain speculative. Do not report subjective preferences, harmless differences, optional cleanup, or praise as findings. Do not turn raw tool output into a finding without confirming its relevance.

Assign exactly one severity:

- `critical`: security compromise, data loss or corruption, or broadly catastrophic failure.
- `major`: a real correctness, reliability, compatibility, or significant performance defect that normally blocks approval.
- `minor`: a localized defect worth fixing that does not normally block approval.

## Write copy-pasteable comments

Each finding has metadata followed by a self-contained two-sentence comment:

1. State the triggering condition, concrete defect, and resulting behavior in plain language.
2. Direct the author to perform one specific fix.

The comment must be understandable without the report summary and ready to paste into a pull request. Do not include internal reasoning, praise, hedging such as “might” or “consider,” labels such as `Issue` or `Fix`, a menu of alternatives, or more than one remediation.

Example:

```markdown
- `major` `src/auth/refresh.ts:42` — When two refresh requests run concurrently, both can exchange the same token before either transaction commits, allowing token reuse. Invalidate and exchange the token atomically in one transaction.
```

## Return the standardized report

Return only this report structure, with sections in the exact order shown:

```markdown
# Code Review

- **Target:** `<resolved target>`
- **Verdict:** `<Clean | Non-blocking findings | Changes required | Incomplete review>`
- **Findings:** `<critical count> critical, <major count> major, <minor count> minor`

## Summary

<One short paragraph describing the change and overall assessment.>

## Findings

- `<severity>` `<relative/path:line>` — <Concrete defect, triggering condition, and resulting behavior. One direct, executable fix.>

## Validation

- `<check>` — `<result>`

## Coverage limitations

None.
```

Order findings by severity. Use these exact empty states:

- No findings: `No actionable findings.`
- No validation: `- Not run: <reason>`
- No material coverage limitation: `None.`

Derive the verdict deterministically:

1. `Incomplete review` when material changed code or required context could not be inspected sufficiently, regardless of findings already identified.
2. `Changes required` when at least one `critical` or `major` finding exists.
3. `Non-blocking findings` when every finding is `minor`.
4. `Clean` when there are no actionable findings and no material limitation.

## Preserve read-only review behavior

Return the report in the agent session. Do not post comments, submit a review, approve, request changes, modify the PR, invoke an external review service, or write a report file unless the user separately asks for that mutation.
