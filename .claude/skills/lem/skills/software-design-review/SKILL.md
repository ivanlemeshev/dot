---
name: software-design-review
description: Review code design for change amplification, cognitive load, unknown unknowns, and dependencies and obscurity.
disable-model-invocation: true
argument-hint: "[code area or review target]"
---

# Review software design

Review the requested code for design problems that increase overall complexity. Focus on these factors:

- **Change Amplification:** One behavior change requires edits in many places.
- **Cognitive Load:** A reader must hold too many rules or states in mind to understand the code.
- **Unknown Unknowns:** Important behavior, constraints, or side effects are hard to discover before a change.
- **Dependencies and Obscurity:** Hidden coupling, indirect control flow, or unclear ownership makes behavior hard to trace.

## Inspect the code

1. Use `$ARGUMENTS` as the target when it is set. Otherwise, use the code named in the user's request.
2. Read applicable repository instructions and nearby design notes.
3. Trace callers, data flow, state changes, configuration, and external dependencies that affect the code.
4. Check whether each suspected problem occurs in more than one path or requires more context than expected.
5. Report only problems supported by specific code or repository evidence.

Do not report style preferences or abstract risks. Explain the concrete cost that a maintainer pays, such as duplicated edits, hidden side effects, surprising state, or difficult impact analysis.

## Recommend improvements

For each problem, name one change that reduces overall complexity. Prefer a smaller number of clear concepts, explicit dependencies, local rules, and predictable data flow. Do not recommend a redesign when a small boundary or ownership change solves the problem.

Do not make code changes. Do not run tests unless the user asks for verification.

## Return the review

Start with a short assessment of the design. Then list actionable findings in order of impact. Include the factor, file and line, concrete example, resulting maintenance cost, and one improvement for each finding.

Use this format:

```markdown
# Software Design Review

<Short assessment.>

## Findings

- **<Factor>** — `<path>:<line>`: <Concrete design problem and its maintenance cost.> <One improvement that reduces overall complexity.>

## Strengths

- <A concrete design choice that keeps change local or behavior easy to understand.>
```

Use `No actionable design problems found.` when the review finds no actionable problem. Use `None.` when no concrete strength stands out.
