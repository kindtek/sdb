#!/bin/bash
export DOCKER_BUILDKIT=1
systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker


/build/solana/sdk/docker-solana/build.sh
/build/yubico-net-sdk/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh