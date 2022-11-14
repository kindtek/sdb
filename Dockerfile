FROM docker/dev-environments-default:stable-1 AS docker_dev



RUN apt-get update -qq && apt-get install -yq wget
RUN mkdir /com.docker.devenvironments.code && cd /com.docker.devenvironments.code 
WORKDIR /
RUN git -C . clone -b sdb_dev https://github.com/kindtek/yubico-net-sdk.git /yub --progress --depth 1
RUN git -C . clone -b master https://github.com/kindtek/solana.git /sol --progress --depth 1
RUN ls -al
RUN cd yub && ls -al

WORKDIR /yub

RUN ls -al
COPY . /com.docker.devenvironments.code/yub
RUN ls -al
RUN cd .. && ls -al

WORKDIR /sol
COPY . /com.docker.devenvironments.code/sol

RUN /bin/bash /yub/yubico-sdk-net/Yubico.NativeShims/docker/Ubuntu/build-ubuntu.sh
RUN /bin/bash /sol/solana/sdk/docker-solana/build.sh


