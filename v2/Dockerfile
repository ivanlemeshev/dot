# Ubuntu 24.04 LTS test environment for dotfiles v2
FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies needed for setup
RUN apt-get update && apt-get install -y \
  sudo \
  curl \
  wget \
  git \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Create a test user with sudo privileges
RUN useradd -m -s /bin/bash testuser && \
  echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy v2 dotfiles into container
COPY --chown=testuser:testuser . /home/testuser/dotfiles

# Set working directory to dotfiles
WORKDIR /home/testuser/dotfiles

# Run setup script
RUN ./setup

# Verify installations
RUN fish --version && \
  nvim --version && \
  tmux -V && \
  starship --version && \
  git --version && \
  bat --version

# Verify symlinks exist
RUN test -L /home/testuser/.config/fish/config.fish && \
  test -L /home/testuser/.config/nvim && \
  test -L /home/testuser/.tmux.conf && \
  test -L /home/testuser/.config/starship.toml && \
  test -L /home/testuser/.vimrc

# Default command: start fish shell
CMD ["fish"]
