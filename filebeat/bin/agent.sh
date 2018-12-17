#!/bin/bash
#
# 2018/12/17

ELASTICSEARCH_HOST='10.50.200.101'
ELASTICSEARCH_PORT='9200'
ELASTICSEARCH_USER='admin'
ELASTICSEARCH_PASSWORD='admin'

test $(docker ps -a -f name=logs-agent -q |wc -l) -eq 0 || \
docker rm -f logs-agent
docker volume inspect logs-agent-var >/dev/null 2>&1 || docker volume create logs-agent-var

docker run -d --restart always \
    --name logs-agent \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/localtime:/etc/localtime \
    -v logs-agent-var:/var/lib/filebeat \
    -v /:/host \
    --cap-add SYS_ADMIN \
    --cpus "0.5" \
    --memory "256m" \
    -e LOGGING_OUTPUT=elasticsearch \
    -e ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST} \
    -e ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT} \
    -e ELASTICSEARCH_USER=${ELASTICSEARCH_USER} \
    -e ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD} \
    registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.6-filebeat

docker logs --tail 100 --since 5m -f logs-agent
