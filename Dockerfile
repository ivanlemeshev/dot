FROM ubuntu:24.04

RUN apt-get update && \
  apt-get install -y sudo software-properties-common && \
  rm -rf /var/lib/apt/lists/* && \
  useradd -m -s /bin/bash test && \
  echo "test:test" | chpasswd && \
  echo "test ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER test
