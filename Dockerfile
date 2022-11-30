# 0
FROM docker:git AS clone-git-sdb_dev
COPY . ./sdb
RUN cd /sdb && git submodule update --init --recursive

FROM teracy/ubuntu:18.04-dind-latest AS build-sdb_dev
RUN chmod +x /etc/apt/sources.list && head -n -2 \
    && /etc/apt/sources.list > tmp.txt \
    && mv tmp.txt /etc/apt/sources.list # fix for malformed list error \
    && apt-get update -y

# COPY --from=installed-rc-dind-git-sdb_dev ./sdb .
# 2
FROM build-sdb_dev AS built-sdb_dev
ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
EXPOSE 8899
RUN cd /
COPY --chown=0:0 --from=0 ./sdb /sdb
RUN cd /sdb/solana
WORKDIR /sdb/solana
# FIX FOR:
#   E: Malformed entry 52 in list file /etc/apt/sources.list ([option] no value)
#   E: The list of sources could not be read.
RUN chmod +x /etc/apt/sources.list && head -n -2 \
    && /etc/apt/sources.list > tmp.txt \
    && mv tmp.txt /etc/apt/sources.list # fix for malformed list error \
    && apt-get update -y 
RUN /bin/bash /install.sh && /bin/bash sdk/docker-solana/build.sh --CI=true 

# RUN ./install.sh && sh sdk/docker-solana/build.sh --CI=true 

# 3
FROM build-sdb_dev:18.04-dind-latest AS built-yub-sdb_dev
USER root
RUN cd /
COPY --chown=0:0 --from=0 ./sdb /sdb
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
RUN chmod +x /etc/apt/sources.list && head -n -2 \
    && /etc/apt/sources.list > tmp.txt \
    && mv tmp.txt /etc/apt/sources.list # fix for malformed list error \
    && apt-get update -y 
# RUN sh build-ubuntu.sh
RUN /bin/bash /install.sh && /bin/bash build-ubuntu.sh

#4
FROM build-sdb_dev AS built-sol-sdb_dev
USER root
EXPOSE 8899
# COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=0 ./sdb /sdb
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


