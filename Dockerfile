FROM docker:git AS submods-init-sdb_dev
WORKDIR /build
RUN git submodule update --init --recursive

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
COPY --from=submods-init-sdb_dev . .

RUN apk update \
    && apk add --no-cache bash \
    && apk add --no-cache git \
    && apk add openrc --no-cache
    # && sh /build/yubico-sdk-net/Yubico.NativeShims/build-ubuntu.sh  \
    # && sh /build/solana/sdk/docker-solana/build.sh

# RUN chmod +x ./build-sdb.sh \
#     && sh /build/build-sdb.sh
# RUN chmod +x ./build/solana/sdk/docker-solana/build.sh ./build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899



CMD ["git", "version"]

