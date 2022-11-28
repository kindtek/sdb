FROM docker:git AS submods-init-sdb_dev
WORKDIR /build
COPY . .
RUN git submodule update --init --recursive

FROM docker:rc-dind AS installed-sdb_dev
ONBUILD ARG privileged=true
ONBUILD ARG rm=true
ONBUILD ARG cap-add=NET_ADMIN
ONBUILD ARG cap-add=NET_RAW
ONBUILD ARG init=true
ONBUILD ENV DOCKER_TLS_CERTDIR=/certs
ONBUILD USER root:docker
ONBUILD VOLUME /var/run/docker.sock:/var/run/docker.sock
ONBUILD COPY --from=submods-init-sdb_dev . .

ONBUILD RUN apk update \
    && apk add --no-cache bash \
    && apk add --no-cache git \
    && apk add openrc --no-cache
    # && sh /build/yubico-sdk-net/Yubico.NativeShims/build-ubuntu.sh  \
    # && sh /build/solana/sdk/docker-solana/build.sh

# RUN chmod +x ./build-sdb.sh \
#     && sh /build/build-sdb.sh
# RUN chmod +x ./build/solana/sdk/docker-solana/build.sh ./build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
ONBUILD EXPOSE 8899





CMD ["git", "version"]

