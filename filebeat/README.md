# log-pilot-filebeat 使用介绍
2018/11/15

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


#### 运行示例 demo1
```bash
# docker stack deploy -c bin/demo1.yml demo1

```
