# Dotfiles v2 work plan

Status: Planning. No v2 implementation has started.

## Working method

- Keep requirements and open decisions in [requirements.md](requirements.md).
- Use this file as the local work tracker. Add issue and pull request links when they exist.
- Select one small task, state its acceptance checks, implement it on a branch, and record the result.
- Update task status and relevant documentation in the same change as the implementation.
- Complete independent tasks while decisions are open. Do not implement behavior that depends on an unresolved decision.
- Mark a task complete only when its checks pass. Record unavailable platform checks as limitations.

## Phases

### 1. Inventory and scope

- Status: Next
- Work: Inspect current installers, packages, configuration, links, and tests. Resolve supported targets and classify features.
- Completion check: Feature inventory and support matrix exist; each retained feature has a target.

### 2. Setup prototype

- Status: Pending
- Work: Evaluate the entry point and configuration manager with a small Git and Neovim configuration example.
- Completion check: Demonstrate first setup, a repeated run, and an existing-file conflict on each agreed target in disposable environments. Record D1 and D2 outcomes.

### 3. Common configuration

- Status: Pending
- Work: Implement common files, local overrides, preview, and conflict handling.
- Completion check: Verify file contents, existing-file preservation, repeated runs, and recovery after an interrupted operation.

### 4. Platform packages

- Status: Pending
- Work: Add Fedora, Ubuntu, macOS, and Windows package setup as separate tasks.
- Completion check: Each target handles missing and installed packages, reports installation failures, and passes repeated-run checks.

### 5. Desktop settings

- Status: Pending
- Work: Add KDE Plasma and other agreed desktop settings as separate tasks.
- Completion check: Verify settings in a disposable desktop session, preserve unrelated settings, and document logout or restart needs.

### 6. Migration

- Status: Pending
- Work: Move retained v1 features to v2 and document adoption and recovery.
- Completion check: Test with a disposable home containing representative v1 links and existing user files. Verify documented restoration.

### 7. Release

- Status: Pending
- Work: Complete the support matrix, usage guide, automated checks, and remaining manual checks.
- Completion check: Every required target passes recorded checks; migration instructions are complete before v1 is retired.

## Task record

Use this format when a phase is split into implementation tasks:

```markdown
### V2-001: Task title

Status: Ready | In progress | Blocked | Done
Requirement: Requirement or decision reference
Depends on: Task IDs or none
Scope: The behavior this task delivers
Acceptance checks: Observable results required for completion
Verification: Commands or manual procedure, environment, and results
Limitations: Missing checks or known restrictions
Pull request: Link when available
```

## Skill use

- `grilling`: Resolve requirements and open decisions in a focused discussion.
- `domain-modeling`: Define shared terms and document significant design decisions.
- `codebase-design`: Design boundaries between configuration, packages, and platform settings.
- `prototype`: Test the entry point and configuration manager before full implementation.
- `tdd`: Test meaningful installer behavior, including conflicts, failures, and repeated runs.
- `lem-review-pr`: Review each completed change against its requirements and checks.

## Next task

Create the v1 feature inventory without running installers. Map each feature to its source files and target systems. Use the inventory to resolve scope before selecting the v2 implementation.
