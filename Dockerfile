# 0 
FROM docker:git AS fresh-repo
COPY . ./sdb

# 1
FROM fresh-repo AS clone-sub-repos
RUN cd /sdb && git submodule update --init --recursive

# 2
FROM kindtek/sdb_dev-sol:sdb-solana AS build-sol
COPY --chown=0:0 --from=0 ./sdb/solana /sdb/solana
WORKDIR /sdb/solana


# 3
FROM kindtek/teracy-ubuntu-20-04-dind AS build-yub
EXPOSE 8899
ARG init=true
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
# RUN /bin/bash /install.sh
# RUN /bin/bash /sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh

# 4
FROM alpine AS building
EXPOSE 8899
COPY --chown=0:0 --from=0 ./sdb /sdb
RUN ln -s /sdb/solana /sol && ln -s /sdb/yubico-net-sdk /yub

# 5
FROM build-sol AS built-sol
RUN rm -rf /yub && rm -rf /sdb/yubico-net-sdk && rm -rf /sdb
COPY --chown=0:0 --from=1 ./sdb/solana /sdb/solana

# 6
FROM building AS built-yub
RUN rm -rf /sol && rm -rf /sdb/solana && rm -rf /sdb
COPY --chown=0:0 --from=1 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk

# 7
FROM building AS built-sdb
COPY --chown=0:0 --from=0 ./sdb /sdb/
COPY --chown=0:0 --from=1 ./sdb /sdb/
RUN rm -rf /sdb/solana && rm -rf yubico-net-sdk



