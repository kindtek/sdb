# 0 
FROM alpinelinux/build-base AS shallow-repo
# use shallow (not recursively) cloned repo
COPY . ./sdb

# 1
FROM shallow-repo AS deep-repo
WORKDIR /sdb
# fetch the submodules
RUN cd /sdb && git submodule update --init --recursive

# 2 - directories only
FROM scratch AS skinny-repo
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb
# RUN /bin/bash sol/fetch-spl.sh


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

# 3
FROM scratch AS building-sol


# 4
FROM scratch AS building-yub

# 3
FROM alpine:latest AS solana-sdb
ARG _SOL='sol'
ARG _SOLANA='sol'
WORKDIR /$_SOL
COPY --chown=0:0 --from=3 ./sdb/sol /tmp/$_SOLANA
# make sure folder remains empty
RUN rm /${_SOLANA}    
# copy single empty folder to solana-sdb for future volume mount point
COPY --chown=0:0 --from=0 ./sdb/sol /$_SOLANA

# TODO - MAKE IMAGE NAME DYNAMIC
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

# 4
FROM alpine:latest AS yubico-sdb
ARG _YUB='yub'
ARG _YUBICO='yub'
# add $_YUB/ICO = /yub variable to environment
# RUN "_YUB='yub' \
#     _YUBICO='yub' \
#     cat >> /etc/environment << EOF \
#     _YUB=$_YUB \
#     _YUBICO=$_YUBICO \
#     EOF"
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=4 ./sdb/yub /$_YUBICO
WORKDIR /yub



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



FROM docker:git AS devspace
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb
RUN addgroup -S devspace && adduser -SD dev -h /home/dev -s /bin/ash -u 1000 -G devspace
WORKDIR  /home/dev

FROM docker:git AS sdbspace
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb
RUN addgroup -S sdbspace && adduser -S sdb -h /home/sdb -s /bin/ash -u 1000 -G sdbspace
WORKDIR /home/sdb

FROM docker:git AS userpace
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb
RUN addgroup -S userspace && adduser -S user -h /home/sdb -s /bin/ash -u 1000 -G userspace
WORKDIR /home/sdb

