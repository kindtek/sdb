FROM docker:git AS installing-sdb_dev
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

FROM teracy/dev:dev_latest AS building-sdb_dev
COPY --from=installing-sdb_dev . .
# COPY --from=installed-rc-dind-git-sdb_dev ./sdb .

FROM building-sdb_dev AS built-sol-sdb_dev
WORKDIR /sdb/solana/sdk/docker-solana
RUN sh build.sh --CI=true 
WORKDIR /
COPY . .

FROM building-sdb_dev AS built-yub-sdb_dev
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims/
RUN sh build-ubuntu.sh
WORKDIR /
COPY . .



# RUN chmod +x ./build-sdb.sh \
#     && sh /sdb/build-sdb.sh
# RUN chmod +x ./sdb/solana/sdk/docker-solana/build.sh ./sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh

FROM building-sdb_dev AS built-sdb_dev
COPY --from=built-sol-sdb_dev . .
COPY --from=built-yub-sdb_dev . .


CMD ["git", "version"]

