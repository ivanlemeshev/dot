FROM ubuntu:24.04

# Any subsequent commands that install packages run non-interactively.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt upgrade -y \
    && apt install -y sudo \
    && apt autoremove -y \
    && apt autoclean -y

COPY ./workspace/entry.sh /entry.sh

ENTRYPOINT ["sh", "/entry.sh"]
