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
    && apk upgrade
RUN apk add --no-cache git \
    && git submodule update --init --recursive /build
EXPOSE 8899
COPY . .

FROM build-sdb_dev AS installed-sdb_dev
RUN chmod +x build-sdb.sh \ 
    && sh build-sdb.sh
COPY /build .


CMD ["git", "version"]

