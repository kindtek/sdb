# 0 
FROM docker:git AS fresh-repo

COPY . ./sdb

# 1
FROM fresh-repo AS built-git
RUN apk update \
    && apk add bash
# pull the cloned dbs
RUN cd /sdb && git submodule update --init --recursive
# create shortcuts
RUN ln -s /sdb/solana /sol && ln -s /sdb/yubico-net-sdk /yub
RUN /bin/bash solana-version-get

# 2
# TODO - MAKE IMAGE NAME DYNAMIC
ARG CHANNEL=latest 
ARG CI=true 
ARG SOLANA_BUILD=$SOLANA_CHANNEL_OR_TAG
ARG SOLANA_BUILD_ENV=debian
ARG SOLANA_BUILD_ENV_VERSION=bullseye
ARG SOLANA_BUILD_ENV_NAME=bullseye
ARG SOL_DOCKER_IMG=SDB_SOL_DOCKER_IMG
ARG SOL_DOCKER_TAG=$SDB_SOL_DOCKER_TAG
ARG SOL_DOCKER_TAG=$SDB_SOL_DOCKER_TAG
ARG SOL_DOCKER=$SDB_SOL_DOCKER
ARG SOL_PATH=$SDB_SOL_PATH
ARG "kindtek/solana-safedb-debian" AS built-sol
# want sol to have own isolated dev space
EXPOSE 8899
# copy empty directory
COPY --chown=0:0 --from=0 /sdb/solana.* /sdb/
WORKDIR /sdb/solana
# clear sdb  dev space
RUN rm -rf /yub && rm -rf /sdb/yubico-net-sdk && rm -rf /sdb
# replace with clean files
COPY --chown=0:0 --from=1 /sdb/solana.* /sdb/
# add symlinks
RUN ln -s /sdb/solana /sol && cd /sol/sdk/docker-solana
# solana copy pasta
RUN export PATH="/sdb/solana/sdk/docker-solana/usr"/bin:"$PATH"
# COPY /sdb/solana/sdk/scripts/run.sh usr/bin/solana-run.sh
# COPY /sdb/solana/sdk/fetch-spl.sh usr/bin
RUN cd usr/bin && /bin/bash /fetch-spl.sh

# 3
# TODO - MAKE IMAGE NAME DYNAMIC
ARG YUB_BUILD=$YUBICO_BUILD
ARG YUB_BUILD_ENV=$YUBICO_BUILD_ENV
ARG YUB_BUILD_ENV_VERSION=$YUBICO_BUILD_ENV_VERSION
ARG YUB_BUILD_ENV_NAME=$YUBICO_BUILD_ENV_NAME
ARG YUB_DOCKER_IMG=$SDB_YUB_DOCKER_IMG
ARG YUB_DOCKER_TAG=$SDB_YUB_DOCKER_TAG
ARG YUB_DOCKER_TAG_ARM64=$SDB_YUB_DOCKER_TAG_ARM64
ARG YUB_DOCKER_TAG_X64=$SDB_YUB_DOCKER_TAG_X64
ARG YUB_DOCKER_TAG_X86=$SDB_YUB_DOCKER_TAG_X86
ARG YUB_DOCKER=$SDB_YUB_DOCKER
ARG USER_ID=1000 
ARG GROUP_ID=1000
ARG ARTIFACT_DIR=$YUBICO_BUILD_ENV-x64
FROM kindtek/yubico-safedb-ubuntu AS built-yub
# want yub to have own isolated dev space
# copy empty directory
COPY --chown=0:0 --from=0 /sdb/yubico-net-sdk ./sdb/yubico-net-sdk
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
# clear sdb  dev space
RUN rm -rf /sol && rm -rf /sdb/solana && rm -rf /sdb
# replace with clean files
COPY --chown=0:0 --from=1 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk
RUN ln -s /sdb/yubico-net-sdk /yub


# 4
FROM alpine AS built-sdb
# build so that sdb interfaces seamlessly with yub and sol
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb/
COPY --chown=0:0 --from=3 ./usr/bin/usr* /usr/bin/
COPY --chown=0:0 --from=3 /sdb/solana/sdk/docker-solana/usr.* /sdb/solana/sdk/docker-solana/
COPY --chown=0:0 --from=2 ./usr/bin* /usr/bin/
RUN rm -rf /sdb/solana && rm -rf yubico-net-sdk



