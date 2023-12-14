#!/bin/bash

bootstrap() {
    ipfs bootstrap rm --all \
        && ipfs bootstrap add /dns4/ipfs-bootstrap.request.network/tcp/4001/ipfs/QmaSrBXFBaupfeGMTuigswtKtsthbVaSonurjTV967Fdxx \
        && ipfs bootstrap add /dns4/ipfs-bootstrap-2.request.network/tcp/4001/ipfs/QmYdcSoVNU1axgSnkRAyHtwsKiSvFHXeVvRonGCAV9LVEj \
        && ipfs bootstrap add /dns4/ipfs-2.request.network/tcp/4001/ipfs/QmPBPgTDVjveRu6KjGVMYixkCSgGtVyV8aUe6wGQeLZFVd \
        && ipfs bootstrap add /dns4/ipfs-survival.request.network/tcp/4001/ipfs/Qmb6a5DH45k8JwLdLVZUhRhv1rnANpsbXjtsH41esGhNCh
}

config() {
    ipfs config Routing.Type dht \
        && ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001 \
        && ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080 \
        && ipfs config Discovery.MDNS.Enabled false --json \
        && ipfs config Swarm.DisableBandwidthMetrics true --json \
        && ipfs config Swarm.ConnMgr.LowWater 50 --json \
        && ipfs config Swarm.ConnMgr.HighWater 1000 --json \
        && ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin "[\"*\"]"
}

init() {
    ln -s $HOME/swarm.key $IPFS_PATH/swarm.key
    ipfs init \
        && config \
        && bootstrap
}

# main
echo path: $IPFS_PATH

[[ -f $IPFS_PATH/swarm.key ]] || init

export LIBP2P_FORCE_PNET=1 && ipfs daemon
