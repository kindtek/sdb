FROM docker/dev-environments-default:stable-1 AS docker_dev

RUN apt-get update -qq && apt-get install -yq wget
WORKDIR /com.docker.devenvironments.code
RUN git -C . clone -b sdb_dev https://github.com/kindtek/yubico-net-sdk.git yub --progress --depth 1 --single-branch --no-cache
RUN git -C . clone -b master https://github.com/kindtek/solana.git sol --progress --depth 1 --single-branch --no-cache

RUN cd / && cd /com.docker.devenvironments.code && ls -al 
RUN cd yub && ls -al
RUN cd Yubico.NativeShims && ls -al
RUN cd docker && ls -al
RUN cd Ubuntu && ls -al

FROM docker/docker/dev-environments-default:stable-1

COPY --from=docker_dev /com.docker.devenvironments.code /com.docker.devenvironments.code

RUN /bin/bash /com.docker.devenvironments.code/yub/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh --no-cache
RUN /bin/bash /com.docker.devenvironments.code/sol/sdk/docker-solana/build.sh --no-cache
