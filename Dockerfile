FROM docker:rc-dind AS rc-dind-sdb_dev
COPY . ./build

FROM docker:git AS rc-dind-git-sdb_dev
COPY --from=rc-dind-sdb_dev . .

FROM rc-dind-git-sdb_dev AS installed-rc-dind-git-sdb_dev
WORKDIR /build
RUN git submodule update --init --recursive
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
VOLUME /var/run/docker.sock:/var/run/docker.sock
COPY . .


RUN apk update \
    && apk add openrc --no-cache
    # && sh /build/yubico-sdk-net/Yubico.NativeShims/build-ubuntu.sh  \
    # && sh /build/solana/sdk/docker-solana/build.sh

# RUN chmod +x ./build-sdb.sh \
#     && sh /build/build-sdb.sh
# RUN chmod +x ./build/solana/sdk/docker-solana/build.sh ./build/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899





CMD ["git", "version"]

