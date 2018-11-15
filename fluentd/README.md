# log-pilot-fluentd 使用介绍
2018/11/15

下面以 fluentd 为例，描述部署一个简易的日志服务的基本步骤。
```
docker-container ==> log-pilot(fluentd) ==> graylog
                                        \_ elasticsearch
                                        \_ mongodb
```

##### 初始化graylog+elasticsearch+mongodb
注意 graylog 在容器中运行时，可以注入环境变量，变量名称的小技巧是：
参考 `graylog配置文件` 中定义的变量，变成大写字符，加上前缀： `GRAYLOG_`

```bash
# sh es.sh
# sh mongodb.sh
# sh graylog.sh

```

##### 日志 agent 在每个 docker node 上运行
```bash
$ sh log-pilot.sh

```



##### ZYXW、参考
1. [graylog-image](https://hub.docker.com/r/graylog/graylog/)
2. [graylog配置文件](https://github.com/Graylog2/graylog-docker/blob/2.4/config/graylog.conf)
