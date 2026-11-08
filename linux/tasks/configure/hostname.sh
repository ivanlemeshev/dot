#!/usr/bin/env bash
#MISE description="Set the machine hostname"

set -euo pipefail

machine_name="${MACHINE_NAME:-}"

if [[ -z "$machine_name" ]]; then
  exit 0
fi

machine_name="${machine_name,,}"

if [[ ! "$machine_name" =~ ^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$ ]]; then
  printf 'Invalid machine name: %s\n' "$MACHINE_NAME" >&2
  exit 1
fi

if [[ -e /.dockerenv || -e /run/.containerenv ]]; then
  printf 'Set the container hostname with the container runtime: %s\n' "$machine_name"
  exit 0
fi

if command -v hostnamectl >/dev/null 2>&1; then
  sudo hostnamectl set-hostname "$machine_name"
else
  sudo hostname "$machine_name"
  printf '%s\n' "$machine_name" | sudo tee /etc/hostname >/dev/null
fi
