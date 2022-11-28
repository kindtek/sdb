#!/bin/sh
export DOCKER_BUILDKIT=1

apt-get update

service start docker

CI=true ./sdb/solana/sdk/docker-solana/build.sh
./sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
# systemctl enable docker.service
# systemctl enable containerd.service
# systemctl start docker