ARG IPFS_VERSION=latest

FROM alpine as packages
RUN apk add --no-cache jq su-exec util-linux

FROM ipfs/go-ipfs:${IPFS_VERSION}
WORKDIR '/data/ipfs-config'
COPY --from=packages /usr/bin/jq /usr/bin/jq
RUN echo `ls /usr/bin`
#RUN echo /usr/bin
#COPY --from=packages /usr/bin/su-exec /usr/bin/su-exec
COPY . .

ENV LIBP2P_FORCE_PNET 1
ENV SWARM_PORT 4001

ENTRYPOINT ["/bin/sh", "/data/ipfs-config/init_ipfs"]
CMD ["daemon", "--migrate=true"]
