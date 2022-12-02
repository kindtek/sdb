# 0 
FROM docker:git AS fresh-repo
COPY . ./sdb

# 1
FROM fresh-repo AS built-git
RUN apk update && \
    apk add bash && \
    apk upgrade
# pull the cloned dbs
RUN cd /sdb && git submodule update --init --recursive
# create shortcuts
# RUN ln -s /sdb/solana /sol && ln -s /sdb/yubico-net-sdk /yub

# 2
FROM kindtek/solana-safedb-alpine AS built-sol
EXPOSE 8899
#debug
RUN apk -UvX http://dl-4.alpinelinux.org/alpine/edge/main add -u nodejs
RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
# want sol to have own isolated dev space
# clear sdb  dev space
RUN rm -rf /sdb
# copy solana directory only
COPY --chown=0:0 --from=1 /sdb/solana ./sdb/solana
# add symlinks
RUN ln -s /sdb/solana /sol
WORKDIR /sdb/sol

# solana copy pasta
# RUN export PATH="/sol/sdk/docker-solana/usr/bin":"$PATH"
# COPY /sdb/solana/sdk/scripts/run.sh usr/bin/solana-run.sh
# COPY /sdb/solana/sdk/fetch-spl.sh usr/bin/fetch-spl.sh
# RUN cd usr/bin && /bin/bash /fetch-spl.sh

# 3
FROM kindtek/yubico-safedb-alpine AS built-yub
# want yub to have own isolated dev space
# clear sdb  dev space
RUN rm -rf /sdb
# copy yubico directory only
COPY --chown=0:0 --from=1 /sdb/yubico-net-sdk ./sdb/yubico-net-sdk
# add symlinks
# RUN ln -s /sdb/yubico-net-sdk /yub
WORKDIR /yub/Yubico.NativeShims



# 4
FROM alpine AS built-sdb
# build so that sdb interfaces seamlessly with yub and sol

# clear sdb  dev space
RUN rm -rf /sdb/.gitmodules 
# copy empty directory
COPY --chown=0:0 --from=0 /sdb ./sdb
# and gitmodules
COPY --chown=0:0 --from=1 /sdb/.gitmodules ./sdb/.gitmodules
# wipe solana and yubico-net-sdk directories
RUN rm -rf /sdb/solana && rm -rf /sdb/yubico-net-sdk
COPY --chown=0:0 --from=2 /usr/bin ./usr/bin
# COPY --chown=0:0 --from=3 /sdb/solana/sdk/docker-solana/usr.* /sdb/solana/sdk/docker-solana/
COPY --chown=0:0 --from=3 /usr/bin ./usr/bin



