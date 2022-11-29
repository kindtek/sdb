# 0
FROM docker:git AS installing-sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
WORKDIR /sdb
COPY . .
RUN git submodule update --init --recursive
COPY . .

# 1
FROM teracy/dev:dev_latest AS building-sdb_dev
USER root
RUN apt-get update -y 
# \
#     && apt-key list \
#     && grep "expired: " \
#     &&  sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' \
#     && xargs -n1 sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
COPY --chown=0:0 --from=0 . .
# COPY --chown=0:0 --from=installing-sdb_dev ./urs/lib/bash /usr/lib/bash


# COPY --from=installed-rc-dind-git-sdb_dev ./sdb .
# 2
FROM building-sdb_dev AS built-sol-sdb_dev
WORKDIR /sdb/solana/sdk/docker-solana
RUN ls / -al \
    && cd /sdb/solana/sdk/docker-solana \
    && ls -al \
    && chmod +x build.sh \
    && sh build.sh --CI=true 
WORKDIR /
COPY . .

# 3
FROM building-sdb_dev AS built-yub-sdb_dev
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
RUN ls / -al \
    && cd /sdb/yubico-net-sdk/Yubico.NativeShims \
    && ls -al \
    && chmod +x build-ubuntu.sh \
    && sh build-ubuntu.sh
WORKDIR /
COPY . .

#4
FROM building-sdb_dev AS built-sdb_dev
COPY --chown=0:0 --from=2 . .
COPY --chown=0:0 --from=3 . .

EXPOSE 8899
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


