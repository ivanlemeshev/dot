FROM ubuntu:26.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends sudo \
  && useradd --create-home tester \
  && echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester \
  && chmod 0440 /etc/sudoers.d/tester \
  && rm -rf /var/lib/apt/lists/*

COPY v2 /opt/v2

RUN chmod +x /opt/v2/bin/bootstrap /opt/v2/bin/test /opt/v2/packages/*.sh /opt/v2/test/run.sh

USER tester
WORKDIR /home/tester
