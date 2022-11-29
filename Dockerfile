# 0
FROM docker:git AS clone-git-sdb_dev
COPY . ./sdb
RUN cd /sdb && git submodule update --init --recursive

# # xxxx1xxx
# FROM teracy/dev:dev_latest AS building-sdb_dev
# USER root
# COPY --chown=0:0 --from=installing-sdb_dev ./sdb /sdb
# RUN apt-get update -y 
# # \
#     && apt-key list \
#     && grep "expired: " \
#     &&  sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' \
#     && xargs -n1 sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
# COPY --chown=0:0 --from=installing-sdb_dev ./urs/lib/bash /usr/lib/bash


# COPY --from=installed-rc-dind-git-sdb_dev ./sdb .
# 1
FROM teracy/ubuntu:18.04-dind-latest AS build-sol-sdb_dev
ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
EXPOSE 8899
RUN cd /
COPY --chown=0:0 --from=0 ./sdb/solana /sdb/solana
RUN cd /sdb/solana
WORKDIR /sdb/solana
# RUN ./install.sh && sh sdk/docker-solana/build.sh --CI=true 

# 2
FROM teracy/ubuntu:18.04-dind-latest AS build-yub-sdb_dev
USER root
RUN cd /
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk
RUN ./install.sh && cd /sdb/yubico-net-sdk

WORKDIR /sdb/yubico-net-sdk
# RUN ./install.sh && Yubico.NativeShims/build-ubuntu.sh

#3
FROM teracy/ubuntu:18.04-dind-latest AS build-sdb_dev
USER root
EXPOSE 8899
# COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=1 ./sdb/solana /sdb/solana
COPY --chown=0:0 --from=2 ./sdb/yubico-net-sdk  /sdb/yubico-net-sdk
WORKDIR /sdb

CMD ["git", "version"]
# COPY --chown=0:0 --from=built-sol-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-sol-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-sol-sdb_dev ./lib/apk/db /lib/apk/db
# COPY --chown=0:0 --from=built-sol-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./etc /etc



# COPY --chown=0:0 --from=built-yub-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-yub-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-yub-sdb_dev ./lib/apk/db /lib/apk/db
# # COPY --chown=0:0 --from=built-yub-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-yub-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-yub-sdb_dev ./etc /etc

# RUN chmod +x ./build-sdb.sh \
#     && sh /sdb/build-sdb.sh
# RUN chmod +x ./sdb/solana/sdk/docker-solana/build.sh ./sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh

# FROM building-sdb_dev AS built-sdb_dev
# COPY --chown=0:0 --from=built-sol-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-sol-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-sol-sdb_dev ./lib/apk/db /lib/apk/db
# COPY --chown=0:0 --from=built-sol-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./etc /etc

# COPY --chown=0:0 --from=built-yub-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-sol-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-sol-sdb_dev ./lib/apk/db /lib/apk/db
# COPY --chown=0:0 --from=built-sol-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./etc /etc


