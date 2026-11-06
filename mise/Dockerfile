FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV PATH="/home/tester/.local/bin:${PATH}"

RUN apt-get update \
  && apt-get install --yes --no-install-recommends ca-certificates sudo \
  && useradd --create-home --shell /bin/bash --uid 10001 tester \
  && echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester \
  && chmod 0440 /etc/sudoers.d/tester \
  && rm -rf /var/lib/apt/lists/*

COPY --chown=10001:10001 mise/ /opt/mise/

USER 10001
WORKDIR /opt/mise

CMD ["bash"]
