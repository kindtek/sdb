# 0 
FROM alpinelinux/build-base AS shallow-repo
# use shallow (not recursively) cloned repo
COPY . ./sdb

# 1
FROM shallow-repo AS deep-repo
WORKDIR /sdb
# fetch the submodules
RUN git config --global --add safe.directory /sdb && \
cd /sdb && git submodule update --init --recursive

# 2 - repo directory only
FROM scratch AS skinny-repo
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb
# RUN /bin/bash solana/fetch-spl.sh

# 3
FROM kindtek/solana-sdb-debian AS building-sol
# WORKDIR /solana
# FROM debian:bullseye AS building-sol

# 4
FROM kindtek/yubico-sdb-ubuntu as building-yub
# WORKDIR /yubico-net-sdk
# FROM ubuntu:latest AS building-yub

# 5
FROM alpine:latest AS solana-sdb
ARG _SOL='solana'
ARG _SOLANA='solana'
COPY --chown=0:0 --from=3 ./usr /usr
# COPY --chown=0:0 --from=3 ./var /var
# COPY --chown=0:0 --from=3 ./sdb/solana /tmp/solana
# might copy some contents over from tmp/sol later not but might not need them
COPY --chown=0:0 --from=2 ./sdb/solana /tmp/solana
COPY --chown=0:0 --from=alpine:latest . .
# make sure folder remains empty
RUN rm -rf /solana /solana
# copy single empty folder to solana-sdb for future volume mount point
COPY --chown=0:0 --from=0 ./sdb/solana /${_SOLANA:-'solana'}
WORKDIR /${_SOLANA}
RUN export "PATH=/${sol}/sdk/docker-solana/usr/bin:${PATH}"


# 6
FROM scratch AS yubico-sdb
ARG _YUB='yubico-net-sdk'
ARG _YUBICO='yubico-net-sdk'
COPY --chown=0:0 --from=4 . .
COPY --chown=0:0 --from=alpine:latest . .
# make sure folder remains empty
RUN rm -rf /yubico-net-sdk
# copy single empty folder to solana-sdb for future volume mount point
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /${_YUBICO:-'yubico-net-sdk'}
WORKDIR /$YUBICO


FROM skinny-repo AS sdb
RUN addgroup -S devspace && adduser -SD dev -h /home/dev -s /bin/ash -u 1000 -G devspace
RUN addgroup -S sdbspace && adduser -S sdb -h /home/sdb -s /bin/ash -u 1001 -G sdbspace
RUN addgroup -S userspace && adduser -S user -h /home/user -s /bin/ash -u 1002 -G userspace
WORKDIR  /home
