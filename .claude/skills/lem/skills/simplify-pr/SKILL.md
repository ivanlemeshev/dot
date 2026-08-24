---
name: simplify-pr
description: Analyze ready pull requests or local diffs for behavior-preserving code simplifications, and apply narrowly scoped refactors when explicitly requested. Do not use for general correctness reviews without a simplification goal.
argument-hint: "[PR number or URL | branch or range | staged | local changes]"
---

# Simplify a ready PR

Analyze a completed or review-ready change for unnecessary complexity. The desired result is a smaller, clearer implementation with the same observable behavior—not a style rewrite or an architecture change.

## Resolve the change

Treat `$ARGUMENTS` as explicit target input when it is non-empty; otherwise infer the target from the working tree or branch without guessing a base. For a GitHub PR, use read-only metadata and diff commands and review the base recorded by the PR. Do not fetch, checkout, post comments, approve, or otherwise mutate the PR unless the user separately asks.

Before proposing a simplification, inspect the complete changed files and the relevant callers, interfaces, configuration, tests, error paths, and repository instructions. Treat generated code as an output: inspect its source when available instead of rewriting generated files.

## Find worthwhile simplifications

Look for complexity introduced or exposed by the change, such as duplicated branches, unnecessary wrappers or abstractions, repeated state transformations, conditionals that can be expressed directly, redundant conversions or validation, dead paths, and data structures that are more elaborate than their contract requires.

Recommend a candidate only when all of these are true:

- The candidate is in scope of the requested change.
- The current code and the proposed form have an explainable behavior equivalence.
- The simplification improves comprehension, duplication, failure surface, or maintenance cost.
- It does not silently alter API behavior, validation, error handling, ordering, performance characteristics, logging, or security boundaries.

Do not report preferences, formatting-only changes, speculative abstractions, or “shorter” code that is harder to understand. Preserve deliberate defensive checks and explicit code at important trust or failure boundaries. If a simplification depends on an unstated product or performance decision, mark it as requiring author confirmation rather than presenting it as safe.

## Separate analysis from editing

When the user asks for analysis, keep the work read-only and return candidates. When the user asks to simplify the code, implement only the selected or clearly safe candidates, keep the diff minimal, and run the most relevant available tests or checks. Never broaden the PR into unrelated cleanup. If tests cannot establish equivalence, say what remains unverified.

After edits, inspect the final diff and confirm that behavior-sensitive code, public contracts, and tests still align. A failed or unavailable check is a limitation, not evidence that the refactor is safe.

## Report

Use this compact structure:

```markdown
# PR Simplification Review

- **Target:** `<resolved target>`
- **Mode:** `<analysis | changes applied>`

## Summary

<One short paragraph describing the change and the overall simplification assessment.>

## Candidates

- `<relative/path:line>` — <what is unnecessarily complex, the concrete simpler form, why behavior is preserved, and any risk or confirmation needed>

## Validation

- `<check>` — `<result>`

## Limitations

<None, or the specific context/equivalence that could not be verified.>
```

If there are no worthwhile opportunities, say `No worthwhile simplifications identified.` Do not invent a candidate to fill the section.
