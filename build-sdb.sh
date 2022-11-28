#!/bin/sh
export DOCKER_BUILDKIT=1

apk update
apk add openrc --no-cache

rc-update add docker
rc-update add containerd
rc-service docker start

sh /sdb/solana/sdk/docker-solana/build.sh
sh /sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
# systemctl enable docker.service
# systemctl enable containerd.service
# systemctl start docker