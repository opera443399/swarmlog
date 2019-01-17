#!/bin/bash
#
# 0 3 * * * sh /usr/local/bin/es-cleanup.sh >/dev/null 2>&1 &

ELASTICSEARCH_URL='http://10.200.3.101:5002'
dest_dt=$(date -d "2 days ago" +"%Y.%m.%d")
indices="
.monitoring-*-${dest_dt}
app1-${dest_dt}
app2-${dest_dt}
app3-*-${dest_dt}
"

echo -e '\n------[BEFORE] es cleanup------'
curl -s "${ELASTICSEARCH_URL}/_cat/indices?v&s=index:desc"

echo -e '\n------[DO] es cleanup------'
for i in ${indices}; do
  echo -e "\n[DELETE] $i"
  curl -s -X DELETE "${ELASTICSEARCH_URL}/$i"
done

echo -e '\n\n------[AFTER] es cleanup------'
curl -s "${ELASTICSEARCH_URL}/_cat/indices?v&s=index:desc"
