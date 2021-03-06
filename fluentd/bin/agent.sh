#!/bin/bash
#
# 2018/11/15

test $(docker ps -a -f name=logs-agent -q |wc -l) -eq 0 || \
docker rm -f logs-agent

docker run -d --rm -it \
    --name logs-agent \
    -v /etc/localtime:/etc/localtime \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /:/host \
    --privileged \
    -e PILOT_TYPE="fluentd" \
    -e FLUENTD_OUTPUT="graylog" \
    -e GRAYLOG_HOST="10.50.200.101" \
    -e GRAYLOG_PORT="12201" \
    registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.6-fluentd

docker logs --tail 100 --since 5m -f logs-agent
