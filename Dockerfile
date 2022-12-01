# 0 
FROM docker:git AS clone-git-sdb_dev
USER root
COPY . ./sdb
# RUN /bin/bash install.sh
RUN cd /sdb && git submodule update --init --recursive

# 1
FROM kindtek/teracy-ubuntu-20-04-dind AS build-sol-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
COPY --chown=0:0 --from=0 ./sdb /sdb
WORKDIR /sdb/solana
# RUN /bin/bash /install.sh
# RUN /bin/bash sdk/docker-solana/build.sh
# RUN /bin/bash /sdb/solana/sdk/docker-solana/build.sh

# 2
FROM kindtek/teracy-ubuntu-20-04-dind AS build-yub-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
ARG init=true
COPY --chown=0:0 --from=0 ./sdb /sdb
# RUN /bin/bash /install.sh
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
# RUN /bin/bash build-ubuntu.sh

# 3
FROM alpine AS built-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ENV CI=true
ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
COPY . ./sdb

# 4
FROM built-sdb_dev AS built-yub-sdb_dev
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb/yubico-net-sdk /sdb/yubco-net-sdk

# 5
FROM built-sdb_dev AS built-sol-sdb_dev
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=2 ./sdb/solana /sdb/solana


