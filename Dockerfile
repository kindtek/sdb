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
    export PATH=/sdb/sol/sdk/docker-solana/usr/bin:$PATH && \
    /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh
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
FROM kindtek/solana-safedb-alpine:latest AS built-sol
# add $_SOL/ANA = /sol variable to environment
RUN _SOL=/sol \
    _SOLANA=$_SOL \
    cat >> /etc/environment << EOF \
    _SOLANA=$_SOL \
    _SOL=$_SOL \
    EOF
EXPOSE 8899
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/sol $_SOL
COPY --chown=0:0 --from=2 ./sdb/sol $_SOL
COPY --chown=0:0 --from=3 ./sdb/sol $_SOL
WORKDIR $_SOL
RUN export PATH=/sol/sdk/docker-solana/usr/bin:$PATH
# RUN /bin/bash scripts/run.sh

# 6
FROM kindtek/yubico-safedb-ubuntu:latest AS built-yub
# add $_YUB/ICO = /yub variable to environment
RUN _YUB=/yub \
    _YUBICO=$_YUB \
    cat >> /etc/environment << EOF \
    _YUBICO=$_YUB \
    _YUB=$_YUB \
    EOF
#copy empty folder for mounting volumes
COPY --chown=0:0 --from=0 ./sdb/yub /yub
WORKDIR /yub

# 7
FROM built-workbench AS building-sdb
# add $_SOL/ANA = /sol variable to environment
RUN _SOL=/sdb/sol \
    _SOLANA=$_SOL \
    cat >> /etc/environment << EOF \
    _SOLANA=$_SOL \
    _SOL=$_SOL \
    EOF
WORKDIR $_SOL
RUN export PATH=$_SOL/sdk/docker-solana/usr/bin:$PATH
RUN /bin/bash sdk/docker-solana/usr/bin/fetch-spl.sh 
# RUN /bin/bash sdk/docker-solana/usr/bin/solana-sdb-run.sh
# add $_SOL/ANA variable to environment


# Final
FROM building-workbench AS built-sdb
# RUN export PATH=/sdb/sol/sdk/docker-solana/usr/bin:$PATH
COPY --chown=0:0 --from=7 ./sdb /sdb
WORKDIR /sdb
# add $_YUB/ICO = /yub variable to environment
# add $_SOL/ANA = /sol variable to environment
RUN _SOL=/sdb/sol \
    _SOLANA=$_SOL \
    cat >> /etc/environment << EOF \
    _SOLANA=$_SOL \
    _SOL=$_SOL \
    _YUB=/yub \
    _YUBICO=$_YUB \
    cat >> /etc/environment << EOF \
    _YUBICO=$_YUB \
    _YUB=$_YUB \
    EOF






