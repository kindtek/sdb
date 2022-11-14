FROM docker/dev-environments-default:stable-1 AS docker_dev_sol

WORKDIR /com.docker.devenvironments.code/sol
RUN docker build . https://github.com/kindtek/yubico-net-sdk.git#sdb_dev:apk -f Dockerfile 


FROM docker/dev-environments-default:stable-1 AS docker_dev_yub

WORKDIR /com.docker.devenvironments.code/yub
RUN docker build . https://github.com/kindtek/solana.git#sdb_dev:Yubico.NativeShims -f Dockerfile 


FROM scratch AS build_install

WORKDIR /com.docker.devenvironments.code
COPY --from=docker_dev_sol ./sol ./sol
COPY --from=docker_dev_yub ./yub ./yub

