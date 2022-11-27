FROM docker:dind AS installed-sdb_dev
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
USER root
WORKDIR /build
COPY . .
RUN apk update \
    && apk add --no-cache git \
    && git submodule update --init --recursive /build
RUN chmod +x ./build-sdb.sh
    
EXPOSE 8899



CMD ["git", "version"]

