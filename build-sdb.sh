#!/bin/sh
export DOCKER_BUILDKIT=1

apt-get update

systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker

sh /sdb/solana/sdk/docker-solana/build.sh --CI=true
sh /sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
# systemctl enable docker.service
# systemctl enable containerd.service
# systemctl start docker