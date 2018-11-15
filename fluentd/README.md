# fluentd插件使用介绍
2018/11/15

下面以 graylog 为例，描述部署一个简易的日志服务的基本步骤。
```
docker-container ==> log-pilot ==> graylog
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


##### 收集容器日志的方式1：指定 `--log-driver`
```bash
docker run -d --rm -it \
    --name t001 \
    -p 10001:80 \
    --log-driver=gelf \
    --log-opt gelf-address=udp://10.50.200.101:12201 \
    --log-opt tag="log-t001" \
    opera443399/whoami:0.9

```

##### 收集容器日志的方式2：指定 `--label`
```bash
docker run -d --rm -it \
    --name t002 \
    -p 10002:80 \
    --label aliyun.logs.t002=stdout \
    opera443399/whoami:0.9

```


##### 收集容器日志的方式3：在 docker swarm service 模式下指定 `--container-label-add`
```bash
docker service update --with-registry-auth --container-label-add "aliyun.logs.t003=stdout" t003

# 批量给一组 service 增加 --container-label 来激活 log-pilot
for h in $(docker service ls |grep 'dev-' |awk '{print $2}'); do
  echo "[+] 更新 $h 的标签"
  docker service update --with-registry-auth --container-label-add "aliyun.logs.test=stdout" $h
done

# 批量查看一组 service 的 Labels
for h in $(docker service ls |grep 'dev-' |awk '{print $2}'); do
  echo "[+] 查看 $h 的标签"
  docker service inspect -f "{{.Spec.TaskTemplate.ContainerSpec.Labels}}" $h
done

```



##### ZYXW、参考
1. [graylog-image](https://hub.docker.com/r/graylog/graylog/)
2. [graylog配置文件](https://github.com/Graylog2/graylog-docker/blob/2.4/config/graylog.conf)
