# Ubuntu 24.04 LTS test environment for dotfiles v2
FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  sudo \
  curl \
  wget \
  git \
  ca-certificates \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*

# Create a test user with sudo privileges
RUN useradd -m -s /bin/bash testuser && \
  echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

COPY --chown=testuser:testuser . /home/testuser/dotfiles

WORKDIR /home/testuser/dotfiles

RUN ./setup

# Verify installations
RUN fish --version && \
  nvim --version && \
  tmux -V && \
  starship --version && \
  git --version && \
  batcat --version

# Verify symlinks exist
RUN test -L /home/testuser/.config/fish/config.fish && \
  test -L /home/testuser/.config/nvim && \
  test -L /home/testuser/.tmux.conf && \
  test -L /home/testuser/.config/starship.toml && \
  test -L /home/testuser/.vimrc

CMD ["fish"]
