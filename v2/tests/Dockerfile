# Ubuntu 24.04 LTS test environment for dotfiles v2
FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# DL3008: pin versions, DL3015: no-install-recommends
# hadolint ignore=DL3008,DL3015
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

CMD ["fish"]
