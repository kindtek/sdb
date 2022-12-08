# 0 
FROM docker:git AS fresh-repo
# use cloned repoo
COPY . ./sdb

# 1
FROM fresh-repo AS cloned-repo
WORKDIR /sdb
RUN git submodule update --init --recursive

# 2 - use later
FROM cloned-repo AS building-workbench
WORKDIR /
RUN apk --no-cache update && \
    apk --no-cache add \
    bash \
    curl \
    wget \
    bzip2 \
    libressl-dev \
    cargo \
    eudev-dev \
    libc6-compat \
    gcompat \
    eudev-libs \
    libgcc \
    bzip2 \
    libressl-dev \
    # <debug
    apk -UvX http://dl-4.alpinelinux.org/alpine/edge/main add -u nodejs && \
    apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    # /debug>
    linux-headers \
    musl \
    musl-dev \
    musl-utils \
    musl-libintl && \
    apk --no-cache upgrade musl && \
    apk --no-cache upgrade

# RUN /bin/bash sol/fetch-spl.sh

# 3
ARG _SOL='sol'
ARG _SOLANA='sdb/sol'
FROM building-workbench AS built-workbench
# pull the cloned dbs
COPY --chown=0:0 --from=0 ./sdb/sol /sdb/sol
WORKDIR /sdb/sol
EXPOSE 8899
RUN install -D scripts/run.sh sdk/docker-solana/usr/bin/solana-run.sh && \
    install -D fetch-spl.sh sdk/docker-solana/usr/bin && \
    export PATH=/$_SOLANA/sdk/docker-solana/usr/bin:$PATH && \
    cargo build --all && \
    /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh
# RUN /bin/bash sdk/docker-solana/usr/bin/solana-run.sh

# 4
FROM cloned-repo AS built-git
WORKDIR /sdb
# WORKDIR /sdb/sol
# COPY /sdb/sol/scripts/run.sh /sdb/sol/sdk/docker-solana/usr/bin/solana-run.sh
# COPY /sdb/sol/fetch-spl.sh /sdb/sol/sdk/docker-solana/usr/bin
# RUN export PATH="/sol/sdk/docker-solana/usr"/bin:"$PATH"

# 5
ARG _SOL='sol'
ARG _SOLANA='sol'
# TODO - MAKE IMAGE NAME DYNAMIC
FROM kindtek/solana-safedb-alpine:latest AS built-sol
# add $_SOL/ANA variable to environment
# RUN "_SOL='sol' \
#     _SOLANA='sol' \
#     cat >> /etc/environment << EOF \
#     _SOL=$_SOL \
#     _SOLANA=$_SOLANA \
#     EOF"
WORKDIR /$_SOLANA
RUN export PATH=/$sol/sdk/docker-solana/usr/bin:$PATH
# RUN /bin/bash scripts/run.sh

# 6
ARG _YUB='yub'
ARG _YUBICO='yub'
FROM kindtek/yubico-safedb-alpine:latest AS built-yub
# add $_YUB/ICO = /yub variable to environment
# RUN "_YUB='yub' \
#     _YUBICO='yub' \
#     cat >> /etc/environment << EOF \
#     _YUB=$_YUB \
#     _YUBICO=$_YUBICO \
#     EOF"
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/yub /$_YUB
WORKDIR /yub

# 7
ARG _SOL='sol'
ARG _SOLANA='sdb/sol'
FROM built-workbench AS building-sdb
# add $_SOL/ANA = /sol variable to environment
# add $_SOL/ANA variable to environment
# RUN "_SOL='sol' \
#     _SOLANA='sol' \
#     cat >> /etc/environment << EOF \
#     _SOL=$_SOL \
#     _SOLANA=$_SOLANA \
#     EOF"
WORKDIR /$_SOLANA
RUN /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh 
# RUN /bin/bash sdk/docker-solana/usr/bin/solana-sdb-run.sh
# add $_SOL/ANA variable to environment


# Final
ARG _SOL='sol'
ARG _SOLANA='sdb/sol'
FROM building-workbench AS built-sdb
# RUN export PATH=/sdb/sol/sdk/docker-solana/usr/bin:$PATH
COPY --chown=0:0 --from=3 ./sdb /sdb
# COPY --chown=0:0 --from=3 ./usr/bin/solana* /usr/bin

# COPY --chown=0:0 --from=3 ./sdb/sdk/docker-solana /$_SOLANA/sdk/docker-solana

RUN export PATH=/$_SOLANA/sdk/docker-solana/usr/bin:$PATH
WORKDIR /sdb
EXPOSE 8899
RUN install -D $_SOL/scripts/run.sh sdk/docker-solana/usr/bin/solana-run.sh && \
    install -D $_SOL/fetch-spl.sh sdk/docker-solana/usr/bin && \
    export PATH=/$_SOL/sdk/docker-solana/usr/bin:$PATH && \
    /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh
# add $_YUB/ICO = /yub variable to environment
# add $_SOL/ANA = /sol variable to environment
# RUN "_SOL='sol' \
#     _SOLANA='sol' \
#     cat >> /etc/environment << EOF \
#     _SOL=$_SOL \
#     _SOLANA=$_SOLANA \
#     EOF"
# RUN "_YUB='yub' \
#     _YUBICO='yub' \
#     cat >> /etc/environment << EOF \
#     _YUB=$_YUB \
#     _YUBICO=$_YUBICO \
#     EOF"






