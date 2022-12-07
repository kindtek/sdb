# 0 
FROM docker:git AS fresh-repo
# use cloned repoo
COPY . ./sdb

# 1
FROM fresh-repo AS cloned-repo
RUN cd /sdb && git submodule update --init --recursive

# 2
FROM cloned-repo as building-workbench
RUN apk update && \
    apk upgrade && \
    apk --no-cache add bash && \
    apk --no-cache add curl && \
    apk --no-cache add wget
# RUN /bin/bash sol/fetch-spl.sh

# FROM building-workbench as built-workbench


# 3
FROM building-workbench AS built-git
# pull the cloned dbs
WORKDIR /sdb

# WORKDIR /sdb/sol
# COPY /sdb/sol/scripts/run.sh /sdb/sol/sdk/docker-solana/usr/bin/solana-run.sh
# COPY /sdb/sol/fetch-spl.sh /sdb/sol/sdk/docker-solana/usr/bin
# RUN export PATH="/sol/sdk/docker-solana/usr"/bin:"$PATH"

# 3
# TODO - MAKE IMAGE NAME DYNAMIC
FROM kindtek/solana-safedb-debian AS built-sol
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=fresh-repo ./sdb/sol /sol
WORKDIR /sol
RUN apt-get update -qq && \
    apt-get install -yq wget curl
RUN cp scripts/run.sh sdk/docker-solana/usr/bin/solana-run.sh && \
    cp fetch-spl.sh sdk/docker-solana/usr/bin && \
    export PATH=/sol/sdk/docker-solana/usr/bin:$PATH
RUN /bin/bash fetch-spl.sh

WORKDIR /sol
EXPOSE 8899

# 4
FROM kindtek/yubico-safedb-ubuntu AS built-yub
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=fresh-repo ./sdb/yub /yub
WORKDIR /yub

# 5
FROM alpine AS built-sdb
# build so that sdb interfaces seamlessly with yub and sol
COPY --chown=0:0 --from=fresh-repo . .
COPY --chown=0:0 --from=cloned-repo . .
COPY --chown=0:0 --from=building-workbench ./sdb/sol/sdb.env /sol-sdb.env
COPY --chown=0:0 --from=building-workbench ./sdb/yub/sdb.env /yub-sdb.env
COPY --chown=0:0 --from=building-workbench ./sdb/sdb.env /
COPY --chown=0:0 --from=built-sol . .
WORKDIR /sdb






