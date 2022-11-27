FROM docker:dind AS build-sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
WORKDIR /build
USER root
VOLUME /var/run/docker.sock:/var/run/docker.sock
COPY . .
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git \
    && git submodule update --init --recursive \
    && chmod +x build-sdb.sh
EXPOSE 8899


CMD ["git", "version"]

