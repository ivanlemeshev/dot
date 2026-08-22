#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="${BATS_TEST_DIRNAME}/.."
  CODEX_SKILL="$PROJECT_ROOT/.codex/skills/lem-review-pr"
  CANONICAL="$CODEX_SKILL/references"
  CLAUDE_PLUGIN="$PROJECT_ROOT/.claude/skills/lem"
}

@test "Codex and Claude expose the requested personal names" {
  grep -q '^name: lem-review-pr$' "$CODEX_SKILL/SKILL.md"
  grep -q '^  default_prompt: "Use \$lem-review-pr ' "$CODEX_SKILL/agents/openai.yaml"
  grep -q '^  "name": "lem"' "$CLAUDE_PLUGIN/.claude-plugin/plugin.json"
  grep -q '^name: review-pr$' "$CLAUDE_PLUGIN/skills/review-pr/SKILL.md"
}

@test "Claude links directly to the canonical Codex review references" {
  [ -d "$CANONICAL" ]
  [ ! -L "$CANONICAL" ]
  [ -L "$CLAUDE_PLUGIN/skills/review-pr/references" ]
  [ "$(readlink "$CLAUDE_PLUGIN/skills/review-pr/references")" = '../../../../../.codex/skills/lem-review-pr/references' ]

  cmp "$CANONICAL/examples.md" "$CLAUDE_PLUGIN/skills/review-pr/references/examples.md"
}

@test "review method supports every target and the standardized report" {
  for expected in 'Pull request number or URL' 'Branch or revision range' 'Staged changes' 'Working tree'; do
    grep -q "$expected" "$CANONICAL/review-method.md"
  done

  previous_line=0
  for heading in '# Code Review' '## Summary' '## Findings' '## Validation' '## Coverage limitations'; do
    current_line="$(grep -n -m1 "^${heading}$" "$CANONICAL/review-method.md" | cut -d: -f1)"
    [ -n "$current_line" ]
    [ "$current_line" -gt "$previous_line" ]
    previous_line="$current_line"
  done

  grep -q 'No actionable findings\.' "$CANONICAL/review-method.md"
  grep -q 'Incomplete review' "$CANONICAL/review-method.md"
}

@test "review method is read-only by default" {
  grep -q 'Do not post comments' "$CANONICAL/review-method.md"
  ! grep -Eq 'gh pr (comment|review|merge|close)' "$CANONICAL/review-method.md"
}

@test "examples cover evidence with and without formal artifacts" {
  grep -q 'without formal project artifacts' "$CANONICAL/examples.md"
  grep -q 'allowing token reuse' "$CANONICAL/examples.md"
  grep -q 'No target with a clean repository' "$CANONICAL/examples.md"
}

@test "supported installers expose personal skill directories" {
  for platform in fedora macos ubuntu; do
    grep -q 'link_directory.*Codex skills' "$PROJECT_ROOT/install/$platform/codex.sh"
  done

  for platform in macos ubuntu; do
    grep -q 'link_directory.*Claude Code skills' "$PROJECT_ROOT/install/$platform/claude-code.sh"
  done
}

@test "legacy personal review entrypoints are absent" {
  [ ! -e "$PROJECT_ROOT/.codex/skills/review-pr" ]
  [ ! -e "$PROJECT_ROOT/.claude/skills/review" ]
}
