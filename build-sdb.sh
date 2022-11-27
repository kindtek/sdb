#!/bin/sh
export DOCKER_BUILDKIT=1
apk update
apk add --non-cache bash
apk add --no-cache git
apk add openrc --no-cache
rc-update add docker
rc-update add containerd
rc-service docker start
chmod +x /build/solana/sdk/docker-solana/build.sh
chmod +x /build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
git submodule update --init --recursive /build
sh /build/solana/sdk/docker-solana/build.sh
sh /build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh

# systemctl enable docker.service
# systemctl enable containerd.service
# systemctl start docker