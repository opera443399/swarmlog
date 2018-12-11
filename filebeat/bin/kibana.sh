#!/bin/bash
#
# 2018/12/11

test $(docker ps -a -f name=logs-kibana -q |wc -l) -eq 0 || \
docker rm -f logs-kibana

ELASTICSEARCH_URL='http://logs-es1:9200'

# kibana port: 5601
docker run -d \
  --name logs-kibana \
  --network logs-net \
  -v /etc/localtime:/etc/localtime \
  -e "SERVER_NAME=kibana" \
  -e "ELASTICSEARCH_URL=${ELASTICSEARCH_URL}" \
  -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
  -e "xpack.security.enabled=false" \
  docker.elastic.co/kibana/kibana:6.5.0

sleep 1s
docker logs --tail 100 --since 5m -f logs-kibana
