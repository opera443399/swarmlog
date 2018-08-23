#!/bin/bash
#
# 2018/8/23

if [ $(docker ps -a -f "name=logs-mongodb" -f "status=running" -q |wc -l) -eq 1 ]; then
  echo '[I] status=running'
  docker ps -a -f "name=logs-mongodb"
  exit 0
elif [ $(docker ps -a -f "name=logs-mongodb" -f "status=created" -q |wc -l) -eq 1 ]; then
  echo '[I] status=created'
  docker rm -f logs-mongodb
  echo '[I] removed'
elif [ $(docker ps -a -f "name=logs-mongodb" -f "status=exited" -q |wc -l) -eq 1 ]; then
  echo '[I] status=exited'
  docker start logs-mongodb
  echo '[I] restarted'
  docker ps -a -f "name=logs-mongodb"
  exit 0
fi

# ports: 27017[mongodb]
docker run -d -p "27017:27017" \
    --name logs-mongodb \
    -v /etc/localtime:/etc/localtime \
    -v /etc/timezone:/etc/timezone \
    -v /data/server/swarmlog/mongodb:/data/db \
    mongo:3
