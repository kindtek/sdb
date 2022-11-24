FROM docker:20.10.21-dind-rootless AS build-dev_sdb
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
WORKDIR /build_sdb
USER root
VOLUME /var/run/docker.sock:/var/run/docker.sock
RUN apk update \
    && apk upgrade \
    && apk add bash \
    && apk add --no-cache git \
    && dockerd \
    && containerd \
    && git clone --branch dev --recurse-submodules -j8 https://github.com/kindtek/sdb.git /build_sdb \
    && solana/sdk/docker-solana/build.sh \
    && yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899
COPY . .

CMD ["git", "version"]

