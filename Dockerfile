FROM docker:dind AS build-sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
WORKDIR /build
USER root
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git
VOLUME /var/run/docker.sock:/var/run/docker.sock


FROM build-sdb_dev AS installed-sdb_dev
RUN git submodule update --init --recursive /build \
    && chmod +x build-sdb.sh \ 
    && sh build-sdb.sh
EXPOSE 8899

COPY . .


CMD ["git", "version"]

