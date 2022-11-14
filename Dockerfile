FROM docker/dev-environments-default:stable-1 AS docker_dev

RUN apt-get update -qq && apt-get install -yq wget --no-cache
WORKDIR /com.docker.devenevironments.code
RUN git -C . clone -b sdb_dev https://github.com/kindtek/yubico-net-sdk.git yub --progress --depth 1 --single-branch --no-cache
RUN git -C . clone -b master https://github.com/kindtek/solana.git sol --progress --depth 1 --single-branch --no-cache

RUN cd / && cd /com.docker.devenevironments.code && ls -al --no-cache
RUN cd yub && ls -al --no-cache
RUN cd Yubico.NativeShims && ls -al --no-cache
RUN cd docker && ls -al --no-cache
RUN cd Ubuntu && ls -al --no-cache

RUN /bin/bash /com.docker.devenevironments.code/yub/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh --no-cache
RUN /bin/bash /com.docker.devenevironments.code/sol/sdk/docker-solana/build.sh --no-cache


