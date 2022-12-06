# 0 
FROM docker:git AS fresh-repo
# use cloned repoo
COPY . ./sdb

# 1
FROM fresh-repo AS building-git
RUN apk update \
    && apk add bash  \
    && apke updgrad

# 2
FROM building-git AS built-git
#copy empty folders for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/solana /sdb/solana 
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk 
# copy over up/-dates/-grades
COPY --chown=0:0 --from=1 . .
# pull the cloned dbs
WORKDIR /sdb
RUN git submodule update --init --recursive
# # TODO: create shortcuts on entry
# RUN ln -s /sdb/solana /sol && ln -s /sdb/yubico-net-sdk /yub

# 3
# TODO - MAKE IMAGE NAME DYNAMIC
FROM kindtek/solana-safedb-debian AS built-sol
EXPOSE 8899
#copy empty folders for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/solana /solana 
WORKDIR /solana
COPY --chown=0:0 --from=2 scripts/run.sh sdk/docker-solana/usr/bin/solana-run.sh
COPY --chown=0:0 --from=2 fetch-spl.sh sdk/docker-solana/usr/bin
RUN export PATH="/solana/sdk/docker-solana/usr"/bin:"$PATH"
RUN /bin/bash /fetch-spl.sh
# TODO: add symlinks and RUN ON ENTRY...

# 4
FROM kindtek/yubico-safedb-ubuntu AS built-yub

# 5
FROM alpine AS built-sdb
# build so that sdb interfaces seamlessly with yub and sol
COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=2 . .



