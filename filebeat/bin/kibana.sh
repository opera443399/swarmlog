#!/bin/bash
#
# 2019/1/17

test $(docker ps -a -f name=logs-kibana -q |wc -l) -eq 0 || \
docker rm -f logs-kibana

ELASTICSEARCH_URL='http://10.200.3.101:5002'

# kibana port: 5601
docker run -d \
  --name logs-kibana \
  -p "127.0.0.1:5001:5001" \
  -v /etc/localtime:/etc/localtime \
  -e "SERVER_NAME=kibana" \
  -e "ELASTICSEARCH_URL=${ELASTICSEARCH_URL}" \
  -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
  -e "xpack.security.enabled=false" \
  opera443399/kibana:6.5.2

sleep 1s
docker logs --tail 100 --since 5m -f logs-kibana
