FROM docker/dev-environments-default:stable-1 AS docker_sdb_dev
RUN git submodule update --init --recursive
COPY --from=docker_sdb_dev . .

