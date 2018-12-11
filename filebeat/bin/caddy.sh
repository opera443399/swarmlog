#!/bin/bash
#
# 2018/12/11

test $(docker ps -a -f name=logs-caddy -q |wc -l) -eq 0 || \
docker rm -f logs-caddy

docker run -d -p "5601:5601" -p "9200:9200" \
  --name logs-caddy \
  --network logs-net \
  -v /etc/localtime:/etc/localtime \
  -v "$(pwd)/Caddyfile":/etc/caddy/Caddyfile \
  -e "ADMIN_USER=admin" \
  -e "ADMIN_PASSWORD=admin" \
  stefanprodan/caddy

sleep 1s
docker logs --tail 100 --since 5m -f logs-caddy
