FROM docker:20.10.21-dind-rootless AS build-dev_sdb
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
WORKDIR /build_sdb
USER root
VOLUME /var/run/docker.sock:/var/run/docker.sock
RUN addgroup -g 2999 docker \
    && apk update \
    && apk upgrade \
    && apk add bash \
    && apk add --no-cache git \
    && apk add dpkg \
    # && apk add iptables arptables ebtables \
    # && update-alternatives --set iptables /usr/sbin/iptables-legacy \
    # && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy \
    && dockerd --iptables=false\
    && containerd \
    && docker service start \
    && git clone --branch dev --recurse-submodules -j8 https://github.com/kindtek/sdb.git /build_sdb \
    && solana/sdk/docker-solana/build.sh \
    && yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899
COPY . .

CMD ["git", "version"]

