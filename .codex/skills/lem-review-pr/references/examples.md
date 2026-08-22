# Review examples

Use these examples to interpret targets and format results. They illustrate the contract; they are not extra findings to copy mechanically.

## Target examples

- `review PR 42` or a GitHub PR URL: review that PR against the base recorded in its metadata using read-only access.
- `review feature/auth against release`: review the merge-base diff between those revisions.
- `review HEAD~3..HEAD`: honor the explicit two-dot revision range.
- `review staged changes`: review only the index.
- `review local changes`: review staged and unstaged changes plus relevant untracked files.
- No target with a dirty repository: review the working tree and state that choice.
- No target with a clean repository and no confidently detected base: ask which target to review.

## Finding report

```markdown
# Code Review

- **Target:** `feature/auth...origin/main`
- **Verdict:** `Changes required`
- **Findings:** `0 critical, 1 major, 0 minor`

## Summary

The change adds refresh-token rotation, but concurrent exchanges can still reuse a token.

## Findings

- `major` `src/auth/refresh.ts:42` — When two refresh requests run concurrently, both can exchange the same token before either transaction commits, allowing token reuse. Invalidate and exchange the token atomically in one transaction.

## Validation

- `npm test` — passed

## Coverage limitations

None.
```

## Clean report without formal project artifacts

```markdown
# Code Review

- **Target:** `working tree (staged and unstaged changes)`
- **Verdict:** `Clean`
- **Findings:** `0 critical, 0 major, 0 minor`

## Summary

The change updates input normalization and covers the affected boundary cases without introducing an actionable defect.

## Findings

No actionable findings.

## Validation

- `make test` — passed

## Coverage limitations

None.
```

## Incomplete report

```markdown
# Code Review

- **Target:** `PR 42 → main`
- **Verdict:** `Incomplete review`
- **Findings:** `0 critical, 0 major, 0 minor`

## Summary

The available patch changes generated client code, but its source schema could not be inspected.

## Findings

No actionable findings.

## Validation

- Not run: the required generator is unavailable in this environment

## Coverage limitations

- The source schema and regeneration output could not be verified.
```
