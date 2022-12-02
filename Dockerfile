# 0 
FROM docker:git AS fresh-repo
COPY . ./sdb

# 1
FROM fresh-repo AS clone-sub-repos
RUN cd /sdb && git submodule update --init --recursive

# 2
FROM kindtek/sdb_dev-sol:sdb-solana AS built-sol
EXPOSE 8899
COPY --chown=0:0 --from=0 ./sdb/solana /sdb/solana
WORKDIR /sdb/solana
RUN rm -rf /yub && rm -rf /sdb/yubico-net-sdk && rm -rf /sdb
COPY --chown=0:0 --from=1 ./sdb/solana /sdb/solana

# 3
FROM kindtek/teracy-ubuntu-20-04-dind AS built-yub
ARG init=true
COPY --chown=0:0 --from=0 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
RUN rm -rf /sol && rm -rf /sdb/solana && rm -rf /sdb
COPY --chown=0:0 --from=1 ./sdb/yubico-net-sdk /sdb/yubico-net-sdk

# 4
FROM alpine AS built-sdb
EXPOSE 8899
COPY --chown=0:0 --from=0 ./sdb /sdb
RUN ln -s /sdb/solana /sol && ln -s /sdb/yubico-net-sdk /yub
COPY --chown=0:0 --from=0 ./sdb /sdb/
COPY --chown=0:0 --from=1 ./sdb /sdb/
RUN rm -rf /sdb/solana && rm -rf yubico-net-sdk



