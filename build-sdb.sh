#!/bin/bash
export DOCKER_BUILDKIT=1
systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker

git clone --branch dev --recurse-submodules -j8 https://github.com/kindtek/sdb.git /build
/build/solana/sdk/docker-solana/build.sh
/build/yubico-net-sdk/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh