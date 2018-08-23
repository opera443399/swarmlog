#!/bin/bash
#
# 2018/8/23

if [ $(docker ps -a -f "name=logs-elasticsearch" -f "status=running" -q |wc -l) -eq 1 ]; then
  echo '[I] status=running'
  docker ps -a -f "name=logs-elasticsearch"
  exit 0
elif [ $(docker ps -a -f "name=logs-elasticsearch" -f "status=created" -q |wc -l) -eq 1 ]; then
  echo '[I] status=created'
  docker rm -f logs-elasticsearch
  echo '[I] removed'
elif [ $(docker ps -a -f "name=logs-elasticsearch" -f "status=exited" -q |wc -l) -eq 1 ]; then
  echo '[I] status=exited'
  docker start logs-elasticsearch
  echo '[I] restarted'
  docker ps -a -f "name=logs-elasticsearch"
  exit 0
fi

sysctl -w vm.max_map_count=262144

# ports: 9200[elasticsearch]
docker run -d -p "9200:9200" \
    --ulimit memlock=-1:-1 \
    --name logs-elasticsearch \
    -v /etc/localtime:/etc/localtime \
    -v /etc/timezone:/etc/timezone \
    -v /data/server/swarmlog/es:/usr/share/elasticsearch/data \
    -e "cluster.name=docker-logs-cluster" \
    -e "bootstrap.memory_lock=true" \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
    -e "http.host=0.0.0.0" \
    -e "transport.host=0.0.0.0" \
    -e "network.host=0.0.0.0" \
    -e "xpack.security.enabled=false" \
    elasticsearch:5.6.10
