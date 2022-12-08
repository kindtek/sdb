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
RUN apk update && \
    apk upgrade && \
    apk --no-cache add bash && \
    apk --no-cache add curl && \
    apk --no-cache add wget && \
    apk --no-cache add bzip2 && \
    apk --no-cache add libressl-dev
# RUN /bin/bash sol/fetch-spl.sh

# 3
FROM building-workbench AS built-workbench
# pull the cloned dbs
COPY --chown=0:0 --from=0 ./sdb/sol /sdb/sol
WORKDIR /sdb/sol
EXPOSE 8899
RUN install -D scripts/run.sh sdk/docker-solana/usr/bin/solana-run.sh && \
    install -D fetch-spl.sh sdk/docker-solana/usr/bin && \
    export PATH=/sdb/sol/sdk/docker-solana/usr/bin:$PATH
RUN /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh 
# RUN /bin/bash sdk/docker-solana/usr/bin/solana-run.sh

# 4
FROM cloned-repo AS built-git
WORKDIR /sdb
# WORKDIR /sdb/sol
# COPY /sdb/sol/scripts/run.sh /sdb/sol/sdk/docker-solana/usr/bin/solana-run.sh
# COPY /sdb/sol/fetch-spl.sh /sdb/sol/sdk/docker-solana/usr/bin
# RUN export PATH="/sol/sdk/docker-solana/usr"/bin:"$PATH"

# 5
# TODO - MAKE IMAGE NAME DYNAMIC
FROM debian:bullseye AS built-sol
EXPOSE 8899
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/sol /sol
WORKDIR /sol
RUN export PATH=/sol/sdk/docker-solana/usr/bin:$PATH
# RUN /bin/bash scripts/run.sh

# 6
FROM ubuntu:bionic AS built-yub
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/yub /yub
WORKDIR /yub

# 7
FROM built-workbench AS building-sdb
# build so that sdb interfaces seamlessly with yub and sol
WORKDIR /sdb/sol
RUN export PATH=/sdb/sol/sdk/docker-solana/usr/bin:$PATH
RUN /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh 
# RUN /bin/bash sdk/docker-solana/usr/bin/solana-run.sh

FROM building-workbench AS built-sdb
# RUN export PATH=/sdb/sol/sdk/docker-solana/usr/bin:$PATH
COPY --chown=0:0 --from=7 ./sdb /sdb
WORKDIR /sdb






