# 0 
FROM alpinelinux/build-base AS shallow-repo
# use shallow (not recursively) cloned repo
COPY . ./sdb

# 1
FROM shallow-repo AS deep-repo
WORKDIR /sdb
# fetch the submodules
RUN git config --global --add safe.directory /sdb \
cd /sdb && git submodule update --init --recursive

# 2 - directories only
FROM scratch AS skinny-repo
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb
# RUN /bin/bash sol/fetch-spl.sh

# 3
FROM scratch AS building-sol
# FROM debian:bullseye AS building-sol

# 4
FROM scratch AS building-yub
# FROM ubuntu:latest AS building-yub

# 5
FROM scratch AS solana-sdb
ARG _SOL='sol'
ARG _SOLANA='sol'
COPY --chown=0:0 --from=3 . .
# might copy some contents over from tmp/sol later not but might not need them
COPY --chown=0:0 --from=2 ./sdb/sol ./tmp/sol
COPY --chown=0:0 --from=alpine:latest . .
# make sure folder remains empty
RUN rm -rf /solana /sol 
# copy single empty folder to solana-sdb for future volume mount point
COPY --chown=0:0 --from=0 ./sdb/sol /${_SOLANA:-'sol'}
WORKDIR /$_SOLANA
# TODO - MAKE IMAGE NAME DYNAMIC
# add $_SOL/ANA variable to environment
# RUN "_SOL='sol' \
#     _SOLANA='sol' \
#     cat >> /etc/environment << EOF \
#     _SOL=$_SOL \
#     _SOLANA=$_SOLANA \
#     EOF"
RUN export PATH=/$sol/sdk/docker-solana/usr/bin:$PATH
# RUN /bin/bash scripts/run.sh

# 6
FROM scratch AS yubico-sdb
ARG _YUB='yub'
ARG _YUBICO='yub'
COPY --chown=0:0 --from=4 . .
COPY --chown=0:0 --from=alpine:latest . .
# make sure folder remains empty
RUN rm -rf /yubico-net-sdk /yub 
# copy single empty folder to solana-sdb for future volume mount point
COPY --chown=0:0 --from=0 ./sdb/yub /${_YUBICO:-'yub'}
WORKDIR $YUBICO


FROM skinny-repo AS sdb
RUN addgroup -S devspace && adduser -SD dev -h /home/dev -s /bin/ash -u 1000 -G devspace
RUN addgroup -S sdbspace && adduser -S sdb -h /home/sdb -s /bin/ash -u 1001 -G sdbspace
RUN addgroup -S userspace && adduser -S user -h /home/user -s /bin/ash -u 1002 -G userspace
WORKDIR  /home

# RUN install -D scripts/run.sh sdk/docker-solana/usr/bin/solana-run.sh && \
#     install -D fetch-spl.sh sdk/docker-solana/usr/bin && \
#     export PATH=/$_SOLANA/sdk/docker-solana/usr/bin:$PATH && \
#     cargo build --all && \
#     /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh
# RUN /bin/bash sdk/docker-solana/usr/bin/solana-run.sh


# WORKDIR /sdb/sol
# COPY /sdb/sol/scripts/run.sh /sdb/sol/sdk/docker-solana/usr/bin/solana-run.sh
# COPY /sdb/sol/fetch-spl.sh /sdb/sol/sdk/docker-solana/usr/bin
# RUN export PATH="/sol/sdk/docker-solana/usr"/bin:"$PATH"

# add $_YUB/ICO = /yub variable to environment
# RUN "_YUB='yub' \
#     _YUBICO='yub' \
#     cat >> /etc/environment << EOF \
#     _YUB=$_YUB \
#     _YUBICO=$_YUBICO \
#     EOF"
#copy empty folder for mounting volumes



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

