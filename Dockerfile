FROM docker/dev-environments-default:stable-1 AS docker_dev

RUN apt-get update -qq && apt-get install -yq wget
RUN git -C . clone -b sdb_dev https://github.com/kindtek/yubico-net-sdk.git /yub
RUN git -C . clone -b master https://github.com/kindtek/solana.git /sol

COPY . .

RUN /bin/bash yubico-sdk-net/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh
RUN /bin/bash solana/sdk/docker-solana/build.sh


