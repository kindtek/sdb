FROM scratch AS docker_sdb_dev
RUN git submodule update --init --recursive
COPY --from=docker_sdb_dev . /com.devenvironments.code

