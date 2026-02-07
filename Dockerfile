FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# No need to pin versions of packages here, as this image is meant to be used
# as a base for development and testing.
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  locales \
  && locale-gen en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

# Set the locale environment variables to ensure that the container uses UTF-8
# encoding.
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8


# Create a non-root user with sudo privileges. It allows us to run commands as
# a regular user while still having the ability to use sudo when necessary.
ARG USERNAME=sbx
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /home/$USERNAME

USER $USERNAME

CMD ["bash"]
