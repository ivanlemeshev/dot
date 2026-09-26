#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
platforms=(ubuntu fedora-kde)
interactive=false

usage() {
  echo "Usage: $0 [--interactive PLATFORM]" >&2
  echo "Platforms: ubuntu, fedora-kde" >&2
}

if [[ "${1:-}" == "--interactive" ]]; then
  interactive=true
  shift

  if [[ "$#" -ne 1 ]]; then
    usage
    exit 2
  fi

  platforms=("$1")
elif [[ "$#" -ne 0 ]]; then
  usage
  exit 2
fi

for platform in "${platforms[@]}"; do
  case "$platform" in
    ubuntu | fedora-kde) ;;
    *)
      echo "Unsupported platform: $platform" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -n "${CONTAINER_ENGINE:-}" ]]; then
  engine="$CONTAINER_ENGINE"
elif command -v docker >/dev/null 2>&1; then
  engine="docker"
elif command -v podman >/dev/null 2>&1; then
  engine="podman"
else
  echo "Docker or Podman is required." >&2
  exit 2
fi

if ! command -v "$engine" >/dev/null 2>&1; then
  echo "Container engine is not available: $engine" >&2
  exit 2
fi

for platform in "${platforms[@]}"; do
  image="dotfiles-install-test-$platform"
  cache_args=()
  environment=(
    --env GIT_DEFAULT_BRANCH=main
    --env GIT_USER_EMAIL=container@example.com
    --env GIT_USER_NAME="Container Test"
    --env TIMEZONE=UTC
  )

  if [[ "$platform" == "fedora-kde" ]]; then
    environment+=(
      --env MACHINE_NAME=dotfiles-test
      --env KDE_TERMINAL_FONT="JetBrainsMonoNL Nerd Font Mono,11,-1,5,50,0,0,0,0,0"
    )
  fi

  if [[ "${CONTAINER_INSTALL_CACHE:-1}" == "1" ]]; then
    installs_volume="dotfiles-mise-installs-$platform"
    downloads_volume="dotfiles-mise-downloads-$platform"
    "$engine" volume inspect "$installs_volume" >/dev/null 2>&1 \
      || "$engine" volume create "$installs_volume" >/dev/null
    "$engine" volume inspect "$downloads_volume" >/dev/null 2>&1 \
      || "$engine" volume create "$downloads_volume" >/dev/null
    cache_args=(
      --volume "$installs_volume:/home/tester/.local/share/mise"
      --volume "$downloads_volume:/home/tester/.cache/mise"
    )
  fi

  "$engine" build \
    --file "$SCRIPT_DIR/Dockerfile.$platform" \
    --tag "$image" \
    "$PROJECT_ROOT"

  if [[ "$interactive" == true ]]; then
    "$engine" run --rm --interactive --tty \
      "${environment[@]}" \
      "${cache_args[@]}" \
      "$image" \
      /opt/dotfiles/tests/container/interactive.sh "$platform"
  else
    "$engine" run --rm \
      "${environment[@]}" \
      "${cache_args[@]}" \
      "$image" \
      /opt/dotfiles/tests/container/verify-installation.sh "$platform"
  fi
done
