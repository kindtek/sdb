# FROM docker/dev-environments-default:stable-1 AS docker_sdb_dev

# WORKDIR /tmp/sdb_dev
# RUN docker build . solana -f solana/sdk/Dockerfile 
# RUN docker build . https://github.com/kindtek/yubico-net-sdk.git


# FROM scratch AS build_install

# WORKDIR /app
# COPY --from=docker_dev_sdb /tmp/sdb_dev /app

