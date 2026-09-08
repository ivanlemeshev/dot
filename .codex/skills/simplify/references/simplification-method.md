# Simplification method

Find simplifications that preserve observable behavior. Prefer a smaller and clearer implementation. Do not make a style rewrite or an architecture change.

## Resolve the target

Use explicit user input as the target. Support a pull request number or URL, a branch or revision range, staged changes, or the working tree.

For a GitHub pull request, read metadata and the diff. Review the base that the pull request records. Do not fetch, check out, post comments, approve, or change the pull request unless the user asks.

Without an explicit target, inspect the working tree when it has changes. Otherwise, compare the current branch with a confidently detected default branch or upstream. Ask the user when more than one target is plausible or the base is not clear.

Record the resolved target so the user can reproduce the diff.

## Establish context

Read the complete changed files. Read repository instructions. Follow relevant callers, interfaces, configuration, tests, and error paths.

Inspect the source of generated code when it is available. Treat generated files as output.

Focus on complexity that the selected change introduces or exposes. Do not report unrelated existing complexity.

## Select candidates

Look for duplicated branches, unnecessary wrappers, repeated state transformations, direct conditionals, redundant conversions or validation, dead paths, and data structures beyond their contract.

Report a candidate only when all conditions are true:

- It is in scope of the selected change.
- Its behavior equivalence is explainable.
- It improves comprehension, duplication, failure surface, or maintenance cost.
- It preserves API behavior, validation, errors, ordering, performance, logging, and security boundaries.

Keep deliberate defensive checks. Keep explicit code at trust and failure boundaries. Mark a candidate as requiring author confirmation when an unstated product or performance decision affects its safety.

## Apply changes

For analysis requests, keep the work read-only. Return the candidates.

For implementation requests, change only selected or clearly safe candidates. Keep the diff minimal. Run the most relevant available checks.

Inspect the final diff after edits. Confirm that behavior-sensitive code, public contracts, and tests still align. Report a failed or unavailable check as a limitation.

## Return the report

Return this report structure:

```markdown
# Simplification Review

- **Target:** `<resolved target>`
- **Mode:** `<analysis | changes applied>`

## Summary

<One short paragraph that describes the change and the assessment.>

## Candidates

- `<relative/path:line>` — <Complex code, simpler form, preserved behavior, and risk or required confirmation.>

## Validation

- `<check>` — `<result>`

## Limitations

None.
```

Use `No worthwhile simplifications identified.` when there are no candidates. Do not invent a candidate.
