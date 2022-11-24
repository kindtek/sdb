FROM docker:20.10.21-git AS build-dev_sdb
ARG privileged=true
ARG rm=true
WORKDIR /build_sdb
RUN apt-get update -q \
    && apt-get install git -y \
    && apt-get install curl \
    && curl -sSL https://get.docker.com/ | sh \
    && dockerd -H unix:///var/run/docker.sock \
    && git clone --branch dev --recurse-submodules -j8 https://github.com/kindtek/sdb.git /build_sdb \
    && solana/sdk/docker-solana/build.sh \
    && yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh
EXPOSE 8899
COPY . .

CMD ["git", "version"]

