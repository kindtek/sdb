# 0 
FROM docker:git AS fresh-repo
# use cloned repoo
COPY . ./sdb

# 1
FROM fresh-repo AS building-git
RUN apk update \
    && apk add bash  \
    && apke updgrade

# # 2
# FROM building-git AS cloning-git
# # clone the submodule repos
# RUN cd /sdb && git submodule update --init --recursive


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

# TODO: add symlinks on entry
# RUN ln -s /solana /sol
# solana copy pasta
RUN export PATH="/sdb/solana/sdk/docker-solana/usr"/bin:"$PATH"
COPY /sdb/solana/sdk/scripts/run.sh usr/bin/solana-run.sh
COPY /sdb/solana/sdk/fetch-spl.sh usr/bin
# TODO: also RUN ON ENTRY...
# RUN cd usr/bin && /bin/bash /fetch-spl.sh

# 3
FROM kindtek/yubico-safedb-ubuntu AS built-yub
# want yub to have own isolated dev space
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /yubico-net-sdk 



# 4
FROM alpine AS built-sdb
# build so that sdb interfaces seamlessly with yub and sol
COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=2 . .



