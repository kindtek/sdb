# 0
FROM kindtek/teracy-ubuntu-20-04-dind AS clone-git-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
ENV DOCKER_USERNAME=kindtek
ENV DOCKER_PASSWORD=dckr_pat_7w8fzmOcy5EbRQiofMHFPBSVfHc
COPY . ./sdb
RUN cd /sdb && \
    && apt-get update -y 
RUN git submodule update --init --recursive
# RUN docker login -u kindtek -p dckr_pat_7w8fzmOcy5EbRQiofMHFPBSVfHc



# 1
FROM kindtek/teracy-ubuntu-20-04-dind AS built-sol-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CI=true
ENV CHANNEL=sdb_dev

ARG privileged=true
# ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG cap-add=SYS_RESOURCE
ARG init=true
USER root
EXPOSE 8899
COPY --chown=0:0 --from=0 ./ /

RUN cd /sdb/solana 
WORKDIR /sdb/solana
RUN /bin/bash sdk/docker-solana/build.sh

# RUN /bin/bash /sdb/solana/sdk/docker-solana/build.sh

# 2
FROM kindtek/teracy-ubuntu-20-04-dind AS built-yub-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
# ARG init=true
ENV CHANNEL=sdb_dev
USER root
COPY --chown=0:0 --from=0 ./sdb /sdb

RUN cd /
WORKDIR /sdb/yubico-net-sdk/Yubico.NativeShims
# RUN apt-get update -y
# RUN /bin/bash build-ubuntu.sh

# 3
FROM kindtek/teracy-ubuntu-20-04-dind AS built-sdb_dev
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CHANNEL=sdb_dev
USER root
EXPOSE 8899
# COPY --chown=0:0 --from=0 . .
COPY --chown=0:0 --from=0 ./sdb /sdb
COPY --chown=0:0 --from=1 ./sdb /sdb
COPY --chown=0:0 --from=2 ./sdb /sdb
RUN cd /sdb/solana
WORKDIR /sdb/solana

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


