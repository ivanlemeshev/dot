#!/usr/bin/env bats

setup() {
  TEST_ROOT="$(mktemp -d)"
  ENGINE_LOG="$TEST_ROOT/engine.log"
  MOCK_ENGINE="$TEST_ROOT/container-engine"
  export ENGINE_LOG

  printf '%s\n' \
    '#!/usr/bin/env bash' \
    'printf "%s\\n" "$*" >>"$ENGINE_LOG"' >"$MOCK_ENGINE"
  chmod +x "$MOCK_ENGINE"
}

@test "interactive mode checks and opens the selected container" {
  run env CONTAINER_ENGINE="$MOCK_ENGINE" "$BATS_TEST_DIRNAME/../bin/test" --interactive ubuntu

  [ "$status" -eq 0 ]
  [ "$(wc -l <"$ENGINE_LOG")" -eq 2 ]
  [[ "$(sed -n '1p' "$ENGINE_LOG")" == build\ --tag\ dot-v2-test-ubuntu\ --file\ *v2/test/ubuntu/Dockerfile\ * ]]
  [ "$(sed -n '2p' "$ENGINE_LOG")" = "run --rm --interactive --tty dot-v2-test-ubuntu /opt/v2/test/interactive.sh" ]
}

teardown() {
  rm -rf "$TEST_ROOT"
}
