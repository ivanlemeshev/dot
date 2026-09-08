---
name: simplify
description: Analyze a ready pull request or local diff for behavior-preserving simplifications.
disable-model-invocation: true
argument-hint: "[PR number or URL | branch or range | staged | local changes]"
---

# Simplify changes

Read and follow [references/simplification-method.md](references/simplification-method.md) for every request. Use `$ARGUMENTS` as the target when it is set. Otherwise, use the target rules in the shared method. Return the standard report in the conversation.
