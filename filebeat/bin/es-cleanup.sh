#!/bin/bash
#
# 0 3 * * * sh -xe /usr/local/bin/es-cleanup.sh >/dev/null 2>&1 &

dest_dt=$(date -d "2 days ago" +"%Y.%m.%d")
indices="
.monitoring-*-${dest_dt}
appName-*-${dest_dt}
"

echo -e '\n------[BEFORE] es cleanup------'
docker exec -it logs-es1 curl 'localhost:9200/_cat/indices?v&s=index:desc'

echo -e '\n------[DO] es cleanup------'
for i in ${indices}; do
  echo -e "\n[DELETE] $i"
  docker exec -it logs-es1 curl -X DELETE "localhost:9200/$i"
done

echo -e '\n\n------[AFTER] es cleanup------'
docker exec -it logs-es1 curl 'localhost:9200/_cat/indices?v&s=index:desc'
