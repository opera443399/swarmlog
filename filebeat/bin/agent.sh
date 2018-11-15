#!/bin/bash
#
# 2018/11/15

ELASTICSEARCH_HOST='10.50.200.101'
ELASTICSEARCH_PORT='9200'
ELASTICSEARCH_USER='admin'
ELASTICSEARCH_PASSWORD='admin'

test $(docker ps -a -f name=logs-agent -q |wc -l) -eq 0 || \
docker rm -f logs-agent

docker run -d --rm -it \
    --name logs-agent \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/localtime:/etc/localtime \
    -v /:/host \
    --cap-add SYS_ADMIN \
    -e LOGGING_OUTPUT=elasticsearch \
    -e ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST} \
    -e ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT} \
    -e ELASTICSEARCH_USER=${ELASTICSEARCH_USER} \
    -e ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD} \
    registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.6-filebeat

docker logs --tail 100 --since 5m -f logs-agent
