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

# 2
FROM kindtek/sdb_dev-sol:sdb-solana AS built-sol
# want sol to have own isolated dev space
EXPOSE 8899
# copy empty directory
COPY --chown=0:0 --from=0 ./sdb/solana /sdb/solana
WORKDIR /sdb/solana
# clear sdb  dev space
RUN rm -rf /yub && rm -rf /sdb/yubico-net-sdk && rm -rf /sdb
# replace with clean files
COPY --chown=0:0 --from=1 ./sdb/solana /sdb/solana

# 3
FROM kindtek/yubico-nativeshims-ubuntu:alpine AS built-yub
# want yub to have own isolated dev space
# copy empty directory
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
# clear sdb  dev space
RUN rm -rf /sol && rm -rf /sdb/solana && rm -rf /sdb
# replace with clean files
COPY --chown=0:0 --from=1 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk

# 4
FROM alpine AS built-sdb
EXPOSE 8899
# build so that sdb interfaces seamlessly with yub and sol
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb/
COPY --chown=0:0 --from=1 ./usr/bin/solana /usr/bin/solana/

RUN rm -rf /sdb/solana && rm -rf yubico-net-sdk



