FROM debian:12-slim

ARG DEPS="wget ca-certificates net-tools"
ARG TMP="/tmp"

ENV HOME="/opt/ipfs"
ENV IPFS_PATH="/data/ipfs"

SHELL ["/bin/bash", "-c"]

WORKDIR ${IPFS_PATH}

RUN apt-get update >/dev/null && \
    apt-get install -y --no-install-recommends ${DEPS} &>/dev/null && \
    apt-get clean

WORKDIR ${TMP}

RUN wget https://dist.ipfs.tech/kubo/v0.24.0/kubo_v0.24.0_linux-amd64.tar.gz \
    && tar xvf kubo* -C /opt \
    && cd /opt/kubo \
    && chmod +x ipfs \
    && mv ipfs /usr/local/bin

WORKDIR ${HOME}

COPY . .

RUN chmod +x *.sh

EXPOSE 4001 5001 8080-8081

ENTRYPOINT [ "./entrypoint.sh" ]
