#!/usr/bin/env bash
# Docker test helper for dotfiles v2

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="dotfiles-v2-test"
CONTAINER_NAME="dotfiles-v2-test-container"

echo "================================================================================"
echo "                     Dotfiles v2 Docker Test                                "
echo "================================================================================"
echo ""

# Clean up any existing container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "[INFO] Removing existing container..."
  docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

# Build the Docker image
echo "[INFO] Building Docker image..."
echo ""
docker build -t "${IMAGE_NAME}" "${SCRIPT_DIR}"

echo ""
echo "================================================================================"
echo "                         Build Successful!                                  "
echo "================================================================================"
echo ""
echo "The dotfiles setup completed successfully in Docker."
echo ""
echo "Next steps:"
echo "  1. Run interactive shell:    docker run -it ${IMAGE_NAME}"
echo "  2. Inspect the container:    docker run --rm ${IMAGE_NAME} fish -c 'ls -la ~'"
echo "  3. Test a specific tool:     docker run --rm ${IMAGE_NAME} nvim --version"
echo ""
