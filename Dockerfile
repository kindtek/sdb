FROM mono:latest AS build-dev_sdb
WORKDIR /build_sdb
RUN apt-get update -q \
    && apt-get install git -y \
    && git clone --branch dev --recurse-submodules -j8 https://github.com/kindtek/sdb.git /build_sdb \
    && solana/sdk/docker-solana/build.sh \
    && yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899
COPY . .

CMD ["git", "version"]

