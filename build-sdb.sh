#!/bin/bash
git clone --branch dev --recurse-submodules -j8 https://github.com/kindtek/sdb.git /build
/build/solana/sdk/docker-solana/build.sh
/build/yubico-net-sdk/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh