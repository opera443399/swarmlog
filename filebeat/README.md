# log-pilot-filebeat 使用介绍
2018/12/17

下面以 filebeat 为例，描述部署一个简易的日志服务的基本步骤。
```
docker-container ==> log-pilot(filebeat) ==> elasticsearch
                                   \_ kibana

```

##### 初始化 elasticsearch + kibana
```bash
# sh es.sh
# sh kibana.sh
# sh caddy.sh

```

##### 日志 agent 在每个 docker node 上运行
```bash
# sh agent.sh

```


##### 运行示例 demo1
```bash
# docker stack deploy --with-registry-auth -c demo1.yml demo1

```


##### 自动生成的 filebeat 配置结构如下
```bash
/etc/filebeat # ls
fields.yml     kibana         modules.d
filebeat.yml   module         prospectors.d
/etc/filebeat # cat filebeat.yml
path.config: /etc/filebeat
path.logs: /var/log/filebeat
path.data: /var/lib/filebeat/data
filebeat.registry_file: /var/lib/filebeat/registry
filebeat.shutdown_timeout: 0
logging.level: info
logging.metrics.enabled: false
logging.files.rotateeverybytes: 104857600
logging.files.keepfiles: 10
logging.files.permissions: 0600

setup.template.name: "filebeat"
setup.template.pattern: "filebeat-*"
filebeat.config:
    prospectors:
        enabled: true
        path: ${path.config}/prospectors.d/*.yml
        reload.enabled: true
        reload.period: 10s

output.elasticsearch:
    hosts: ["10.50.200.101:9200"]
    index: filebeat-%{+yyyy.MM.dd}

    username: admin
    password: admin



/etc/filebeat # ls prospectors.d/
0a9b30562ef0968eaaa1e8be30c91ac7beb3ea11b0155d495d65cdab1e1069ac.yml
0df3ccba51e90f34013cde0a8b80fd140f4d2c5911254dfc723e4c9dfd07d99d.yml
2014fa165b03f8a7e8dd7eba37c37fbc83ba0548231988aa331414fc972ee2a3.yml
23c5b2975991c2db243e46beeddddc59fcee5c55653d63c0557fadfafeae0a91.yml
4684b96623b0dc6dd59c030f3cd4e07def369b98463742b1e88aae1854359104.yml
544c1901cefd565cded1b30e67067f7ba6613f0f7f2d131916d63085c5e4cd30.yml
8ce77aedc0240b06465d30a766f857fccb9a6eb62fb44ec4de8b50a9df9526d8.yml
97a071db4b5c88660681d8bf22d6ecd005fd650113856a51a6c2e60bff9f0bd7.yml
cada274727e0c7bc19abc8a0f4cf91aae295bef869449e22f17813787b71a36a.yml
e3e0c0ef7cb78f14b772809f6b865ba59ac619ff06eb54aff26bf4f0a03e51b3.yml
f2322e03dc61a839872936cba3c24341921f4fad1f7d047b35dfb6c963076211.yml

/etc/filebeat # cat prospectors.d/cada274727e0c7bc19abc8a0f4cf91aae295bef869449e
22f17813787b71a36a.yml

- type: log
  enabled: true
  paths:
      - /host/data/docker/volumes/demo1_logs/_data/*.log
  scan_frequency: 10s
  fields_under_root: true


  fields:

      index: demo1-file

      topic: demo1-file


      docker_app: demo1

      docker_container: demo1_svc1.1.p32u36pmhnw0si56dc257dfvi

      docker_service: demo1_svc1

  tail_files: false
  close_inactive: 2h
  close_eof: false
  close_removed: true
  clean_removed: true
  close_renamed: false


- type: log
  enabled: true
  paths:
      - /host/data/docker/containers/cada274727e0c7bc19abc8a0f4cf91aae295bef869449e22f17813787b71a36a/cada274727e0c7bc19abc8a0f4cf91aae295bef869449e22f17813787b71a36a-json.log*
  scan_frequency: 10s
  fields_under_root: true

  docker-json: true


  fields:

      index: demo1-stdout

      topic: demo1-stdout


      docker_app: demo1

      docker_container: demo1_svc1.1.p32u36pmhnw0si56dc257dfvi

      docker_service: demo1_svc1

  tail_files: false
  close_inactive: 2h
  close_eof: false
  close_removed: true
  clean_removed: true
  close_renamed: false

/etc/filebeat #
```
