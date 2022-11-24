FROM debian:bullseye AS docker_sdb_dev
RUN /bin/bash build-sdb.sh

CMD ["git", "version"]

