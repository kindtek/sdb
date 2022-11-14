FROM docker/dev-environments-default:stable-1 AS docker_dev

RUN apt-get update -qq && apt-get install wget -yq
WORKDIR /com.docker.devenvironments.code
RUN git -C . clone -b sdb_dev https://github.com/kindtek/yubico-net-sdk.git yub --progress --depth 1 --single-branch 
RUN git -C . clone -b master https://github.com/kindtek/solana.git sol --progress --depth 1 --single-branch 

# RUN cd / && cd /com.docker.devenvironments.code && ls -al 
# RUN cd yub && ls -al
# RUN cd yub/Yubico.NativeShims && ls -al
# RUN cd docker && ls -al
# RUN cd Ubuntu && ls -al
# # add script for docker install
RUN apt-get update -qq
RUN apt-get install curl -yq
RUN apt-get install apt-utils -yq
RUN curl -sSL https://get.docker.com/ | /bin/bash
RUN apt-get install libssl-dev -yq
# RUN sysctl -w vm.max_map_count=262144
# RUN docker network create elastic
# RUN docker run --name es01 --net elastic -p 9200:9200 -p 9300:9300 -it docker.elastic.co/elasticsearch/elasticsearch:8.4.1

# RUN service systemctl start
# RUN docker run -e "ENROLLMENT_TOKEN=eyJ2ZXIiOiI4LjQuMSIsImFkciI6WyIxOTIuMTY4LjgwLjI6OTIwMCJdLCJmZ3IiOiJlZWM5ZjZhZTlmZGJiYjAxZmZjN2ViZTAzMzQwYzc1MzZjNjcxYzI5MDhhNmNiMGEyOTFiNTBlYmFjZmNmYTYyIiwia2V5IjoiNFhOMGRvUUJOUXJIczZOVGV6WnU6WjNDS2ItTE1UdW1TUnVoc21vQjhJZyJ9" docker.elastic.co/elasticsearch/elasticsearch:8.4.1
# RUN systemctl start docker
# RUN service sysctl start
# RUN sysctl start docker
RUN service docker start
# RUN service ssl start

WORKDIR /com.docker.devenvironments.code/yub/Yubico.NativeShims/
RUN ls -al
RUN cd .. && ls -al
RUN /bin/bash build-ubuntu.sh 

FROM docker/dev-environments-default:stable-1

COPY --from=docker_dev . .



WORKDIR /com.docker.devenvironments.code/sol/sdk/docker-solana/
RUN /bin/bash build.sh 
