#!/bin/sh
export DOCKER_BUILDKIT=1
apk update
apk add --no-cache bash
apk add --no-cache git
apk add openrc --no-cache
rc-update add docker
rc-update add containerd
rc-service docker start

git submodule update --init --recursive /build


# systemctl enable docker.service
# systemctl enable containerd.service
# systemctl start docker