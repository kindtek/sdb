FROM docker:rc-dind AS installed-sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
VOLUME /var/run/docker.sock:/var/run/docker.sock
WORKDIR /build
COPY . .
RUN apk update \
    && apk add --no-cache git \
    && git submodule update --init --recursive /build \
    && apk add openrc --no-cache
RUN chmod +x ./build-sdb.sh \
    && sh /build/build-sdb.sh 
RUN chmod +x ./build/solana/sdk/docker-solana/build.sh \
    sh /build/solana/sdk/docker-solana/build.sh
RUN chmod +x ./build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh \ 
    && sh /build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899



CMD ["git", "version"]

