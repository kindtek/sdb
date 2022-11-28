FROM docker:git AS installed-git-sdb_dev
WORKDIR /sdb
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
VOLUME /var/run/docker.sock:/var/run/docker.sock
EXPOSE 8899
COPY . .
RUN git submodule update --init --recursive

FROM teracy/ubuntu:18.04-dind-latest AS building-dind-git-sdb_dev
RUN rm -Rf /var/lib/docker/buildkit/containerd-stargz/cachemounts/
COPY . .

FROM docker/dev-environments-default:stable-1 AS building-sdb_dev
RUN rm -Rf /var/lib/docker/buildkit/containerd-stargz/cachemounts/
COPY --from=building-dind-git-sdb_dev . .
# COPY --from=installed-rc-dind-git-sdb_dev ./sdb .
WORKDIR /sdb
RUN sh build-sdb.sh
# RUN chmod +x ./build-sdb.sh \
#     && sh /sdb/build-sdb.sh
# RUN chmod +x ./sdb/solana/sdk/docker-solana/build.sh ./sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh

FROM building-sdb_dev AS built-sdb_dev
COPY --from=building-sdb_dev ./ ../


CMD ["git", "version"]

