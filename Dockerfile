# 0 
# docker install instructions from https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
FROM ubuntu:focal AS clone-git-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ENV CHANNEL_OR_TAG=dev
ENV BRANCH=dev
ENV DOCKER_USERNAME=kindtek
ENV DOCKER_PASSWORD=dckr_pat_7w8fzmOcy5EbRQiofMHFPBSVfHc
USER root
# RUN apt-get remove docker docker-engine docker.io containerd runc
# RUN apt-get update -y
# RUN apt-get -y install \
#     ca-certificates \
#     curl \
#     coreutils \
#     fuse-overlayfs \
#     gnupg \
#     libssl-dev \
#     lsb-release
# RUN mkdir -p /etc/apt/keyrings
# RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# RUN docker login -u kindtek -p dckr_pat_7w8fzmOcy5EbRQiofMHFPBSVfHc
# RUN echo \
#     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#     $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
# RUN apt-get update -y
# RUN apt-get -y install \
#     docker-ce docker-ce-cli \
#     containerd.io \
#     docker-compose-plugin

COPY . ./sdb
RUN /bin/bash install.sh
RUN cd /sdb && git submodule update --init --recursive

# 1
FROM ubuntu:focal AS built-sol-sdb_dev
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
COPY --chown=0:0 --from=0 ./ /
WORKDIR /
# WORKDIR /sdb/solana/sdk/docker-solana
# RUN /bin/bash sdk/docker-solana/build.sh
# RUN update-alternatives --set iptables /usr/sbin/iptables-legacy \
#     && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
# RUN /bin/bash /sdb/solana/sdk/docker-solana/build.sh

# 2
FROM ubuntu:focal AS built-yub-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ARG privileged=true
ARG rm=true

# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
# ARG init=true
COPY --chown=0:0 --from=0 ./ /
RUN cd /
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
# RUN /bin/bash build-ubuntu.sh

# 3
FROM ubuntu:focal AS built-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ENV CI=true
ARG privileged=true
ARG rm=true

# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
# COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=0 ./sdb /sdb
# COPY --chown=0:0 --from=1 ./sdb /sdb
# COPY --chown=0:0 --from=2 ./sdb /sdb
# RUN cd /sdb/solana
# WORKDIR /sdb/solana/sdk/docker-solana

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


