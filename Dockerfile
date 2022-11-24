FROM docker:20.10.21-git AS build-dev_sdb
ARG privileged=true
ARG rm=true
WORKDIR /build_sdb
RUN apk update \
    && apk upgrade \
    && apk add bash \
    && git clone --branch dev --recurse-submodules -j8 https://github.com/kindtek/sdb.git /build_sdb \
    && solana/sdk/docker-solana/build.sh \
    && yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899
COPY . .

CMD ["git", "version"]

