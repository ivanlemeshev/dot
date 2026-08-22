---
name: review-pr
description: Review GitHub pull requests, branches, revision ranges, staged changes, or working-tree changes and return an evidence-based local report. Use for code review requests; do not use to post review comments unless separately requested.
argument-hint: "[PR number or URL | branch or range | staged | local changes]"
---

# Review changes

Read [references/review-method.md](references/review-method.md) completely and follow it for every review. Read [references/examples.md](references/examples.md) when target interpretation or report formatting would benefit from an example.

Treat `$ARGUMENTS` as explicit target input when it is non-empty; otherwise infer the target according to the shared method. Keep the review read-only and return the standardized report in the conversation.
