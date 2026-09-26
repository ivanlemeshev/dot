FROM archlinux:latest

RUN pacman -Syu --noconfirm --needed sudo \
  && useradd --create-home tester \
  && echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester \
  && chmod 0440 /etc/sudoers.d/tester \
  && pacman -Scc --noconfirm

COPY v2 /opt/v2

RUN chmod +x /opt/v2/bin/bootstrap /opt/v2/bin/test /opt/v2/packages/*.sh /opt/v2/test/run.sh

USER tester
WORKDIR /home/tester
