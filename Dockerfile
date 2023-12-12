ARG IPFS_VERSION=latest

FROM alpine as packages
RUN apk add --no-cache jq su-exec

#RUN find / -name su-exec -type f -exec dirname "{}" ";"

FROM ipfs/go-ipfs:${IPFS_VERSION}
WORKDIR '/data/ipfs-config'
COPY --from=packages /usr/bin/jq /usr/bin/jq
COPY --from=packages /sbin/su-exec /usr/sbin/su-exec
COPY . .

ENV LIBP2P_FORCE_PNET 1
ENV SWARM_PORT 4001

ENTRYPOINT ["/bin/sh", "/data/ipfs-config/init_ipfs"]
CMD ["daemon", "--migrate=true"]
