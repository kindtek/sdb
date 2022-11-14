FROM docker/dev-environments-default:stable-1 AS docker_dev

RUN apt-get update -qq && apt-get install -yq wget
WORKDIR /com.docker.devenevironments.code
RUN git -C . clone -b sdb_dev https://github.com/kindtek/yubico-net-sdk.git yub --progress --depth 1
RUN git -C . clone -b master https://github.com/kindtek/solana.git sol --progress --depth 1

RUN /bin/bash /com.docker.devenevironments.code/yub/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh
RUN /bin/bash /com.docker.devenevironments.code/sol/sdk/docker-solana/build.sh


