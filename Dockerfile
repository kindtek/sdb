# 0 
FROM docker:git AS clone-git-sdb_dev
USER root
COPY . ./sdb
# RUN /bin/bash install.sh
RUN cd /sdb && git submodule update --init --recursive

# 1
FROM kindtek/teracy-ubuntu-20-04-dind AS built-sol-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
COPY --chown=0:0 --from=0 . ./
WORKDIR /sdb/solana
# RUN /bin/bash /install.sh
# RUN /bin/bash sdk/docker-solana/build.sh
# RUN /bin/bash /sdb/solana/sdk/docker-solana/build.sh

# 2
FROM kindtek/teracy-ubuntu-20-04-dind AS built-yub-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
ARG init=true
COPY --chown=0:0 --from=0 . ./
# RUN /bin/bash /install.sh
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
# RUN /bin/bash build-ubuntu.sh

# 3
FROM ubuntu:focal AS built-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ENV CI=true
ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
COPY --chown=0:0 --from=0 ./sdb /sdb
# RUN /bin/bash /install.sh
# RUN cd /sdb/solana
# WORKDIR /sdb/solana/sdk/docker-solana

CMD ["git", "version"]
# COPY --chown=0:0 --from=built-sol-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-sol-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-sol-sdb_dev ./lib/apk/db /lib/apk/db
# COPY --chown=0:0 --from=built-sol-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./etc /etc



# COPY --chown=0:0 --from=built-yub-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-yub-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-yub-sdb_dev ./lib/apk/db /lib/apk/db
# # COPY --chown=0:0 --from=built-yub-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-yub-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-yub-sdb_dev ./etc /etc

# RUN chmod +x ./build-sdb.sh \
#     && sh /sdb/build-sdb.sh
# RUN chmod +x ./sdb/solana/sdk/docker-solana/build.sh ./sdb/yubico-net-sdk/Yubico.NativeShims/build-ubuntu.sh

# FROM building-sdb_dev AS built-sdb_dev
# COPY --chown=0:0 --from=built-sol-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-sol-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-sol-sdb_dev ./lib/apk/db /lib/apk/db
# COPY --chown=0:0 --from=built-sol-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./etc /etc

# COPY --chown=0:0 --from=built-yub-sdb_dev ./run/docker.sock /run/docker.sock
# COPY --chown=0:0 --from=built-sol-sdb_dev ./var/cache/apk /var/cache/apk
# COPY --chown=0:0 --from=built-sol-sdb_dev ./lib/apk/db /lib/apk/db
# COPY --chown=0:0 --from=built-sol-sdb_dev ./bin/bash /bin/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./usr/lib/bash /usr/lib/bash
# COPY --chown=0:0 --from=built-sol-sdb_dev ./etc /etc


