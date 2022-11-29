# 0
FROM docker:git AS installing-sdb_dev
COPY . .
WORKDIR /sdb
RUN git submodule update --init --recursive

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
FROM teracy/dev:dev_latest AS built-sol-sdb_dev
ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
EXPOSE 8899
WORKDIR /solana
COPY --chown=0:0 --from=0 . .
# RUN cd /sdb/solana/sdk/docker-solana \
    # && chmod +x build.sh 
    # \
    # && sh build.sh --CI=true 

# 2
FROM teracy/dev:dev_latest AS built-yub-sdb_dev
USER root
WORKDIR /yubico-net-sdk
COPY --chown=0:0 --from=0 . .
# RUN cd /sdb/yubico-net-sdk/Yubico.NativeShims \
    # && chmod +x build-ubuntu.sh \
    # && sh build-ubuntu.sh

#3
FROM teracy/dev:dev_latest AS built-sdb_dev
USER root
# COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=1 ./solana /sdb/solana
COPY --chown=0:0 --from=2 ./yubico-net-sdk  /sdb/yubico-net-sdk

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


