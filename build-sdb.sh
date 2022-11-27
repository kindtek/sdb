#!/bin/sh
export DOCKER_BUILDKIT=1
systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker


sh /build/solana/sdk/docker-solana/build.sh
sh /build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh