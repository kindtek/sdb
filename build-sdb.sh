#!/bin/sh
export DOCKER_BUILDKIT=1

apt-get update

systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker

sh CI=true /sdb/solana/sdk/docker-solana/build.sh
sh /sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
# systemctl enable docker.service
# systemctl enable containerd.service
# systemctl start docker