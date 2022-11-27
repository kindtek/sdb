#!/bin/sh
export DOCKER_BUILDKIT=1
systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker

git submodule update --init --recursive
sh /build/solana/sdk/docker-solana/build.sh
sh /build/yubico-net-sdk/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh