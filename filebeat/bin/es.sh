#!/bin/bash
#
# 2018/12/19

if [ $(docker ps -a -f "name=logs-es1" -f "status=running" -q |wc -l) -eq 1 ]; then
  echo '[I] status=running'
  docker ps -a -f "name=logs-es1"
  exit 0
elif [ $(docker ps -a -f "name=logs-es1" -f "status=created" -q |wc -l) -eq 1 ]; then
  echo '[I] status=created'
  docker rm -f logs-es1
  echo '[I] removed'
elif [ $(docker ps -a -f "name=logs-es1" -f "status=exited" -q |wc -l) -eq 1 ]; then
  echo '[I] status=exited'
  docker start logs-es1
  echo '[I] restarted'
  docker ps -a -f "name=logs-es1"
  exit 0
fi

sysctl -w vm.max_map_count=262144

mkdir -p /data/es1
chown -R 1000:1000 /data/es1

# es port: 9200
docker run -d \
  --name logs-es1 \
  --network logs-net \
  -v /etc/localtime:/etc/localtime \
  -v /data/es1:/usr/share/elasticsearch/data \
  -e "cluster.name=docker-logs-cluster" \
  -e "bootstrap.memory_lock=true" \
  -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
  -e "xpack.security.enabled=false" \
  --ulimit memlock=-1:-1 \
  opera443399/elasticsearch:6.5.0

sleep 1s
docker logs --tail 100 --since 5m -f logs-es1
