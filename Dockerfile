FROM docker:dind AS installed-sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
WORKDIR /build
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git \
    && git submodule update --init --recursive \
    && chmod +x build-sdb.sh \ 
    && sh build-sdb.sh
EXPOSE 8899

COPY . .


CMD ["git", "version"]

