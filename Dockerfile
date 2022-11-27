FROM docker:dind-rootless AS build-dev_sdb
ARG privileged=true
ARG rm=true
ARG cap-add=NET_ADMIN
ARG cap-add=NET_RAW
ARG init=true
ENV DOCKER_TLS_CERTDIR=/certs
WORKDIR /build
USER rootless:Rootless
VOLUME /var/run/docker.sock:/var/run/docker.sock
RUN apk update \
    && apk upgrade \
    && ./build-sdb.sh
EXPOSE 8899
COPY . .

CMD ["git", "version"]

