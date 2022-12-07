# 0 
FROM docker:git AS fresh-repo
# use cloned repoo
COPY . ./sdb

# 1
FROM fresh-repo AS building-git
RUN apk update && \
    apk upgrade && \
    apk --no-cache add bash && \
    apk --no-cache add curl && \
    apk --no-cache add wget


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
COPY --chown=0:0 --from=0 ./sdb/solana /sdb/solana 
RUN /bin/bash solana/fetch-spl.sh

# WORKDIR /sdb/solana
# COPY /sdb/solana/scripts/run.sh /sdb/solana/sdk/docker-solana/usr/bin/solana-run.sh
# COPY /sdb/solana/fetch-spl.sh /sdb/solana/sdk/docker-solana/usr/bin
# RUN export PATH="/solana/sdk/docker-solana/usr"/bin:"$PATH"
# RUN /bin/bash fetch-spl.sh

# 3
# TODO - MAKE IMAGE NAME DYNAMIC
FROM kindtek/solana-safedb-debian AS built-sol
#copy empty folders for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/solana /solana 
# COPY --chown=0:0 --from=2 ./sdb/solana /solana
RUN ln -s /solana /sol
WORKDIR /sol
EXPOSE 8899

# 4
FROM kindtek/yubico-safedb-ubuntu AS built-yub
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /yubico-net-sdk
RUN ln -s /yubico-net-sdk /yub
WORKDIR /yub

# 5
FROM alpine AS built-sdb
# build so that sdb interfaces seamlessly with yub and sol
COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=1 . .
COPY --chown=0:0 --from=2 . .
RUN ln -s /sdb/solana /sol && ln -s /sdb/yubico-net-sdk /yub





