# 容器日志收集方案探索之log-pilot
2018/11/15

> log-pilot: 阿里云开源的日志采集器

具有如下特性：

* 一个单独的 log 进程收集机器上所有容器的日志。不需要为每个容器启动一个 log 进程。
* 支持文件日志和 stdout。docker log dirver 亦或 logspout 只能处理 stdout，log-pilot 不仅支持收集 stdout 日志，还可以收集文件日志。
* 声明式配置。当您的容器有日志要收集，只要通过 label 声明要收集的日志文件的路径，无需改动其他任何配置，log-pilot 就会自动收集新容器的日志。
* 支持多种日志存储方式。无论是强大的阿里云日志服务，还是比较流行的 elasticsearch 组合，甚至是 graylog，log-pilot 都能把日志投递到正确的地点。
* 开源。log-pilot 完全开源，您可以从 这里 下载代码。如果现有的功能不能满足您的需要，欢迎提 issue。


> 当前最新版本
Image
registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.6-filebeat
registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.6-fluentd

*建议* 优先选择 filebeat 这个版本，因为 fluentd 最近几个版本都有遇到解析日志异常的情况，当然了，如果你要配合 graylog 来使用，则只能选择 fluentd 来作为方案。


### 开始收集日志
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
    --label aliyun.logs.t002-stdout=stdout \
    --label aliyun.logs.t002-file=/var/log/t002/*.log \
    opera443399/whoami:0.9

```


##### 收集容器日志的方式3：在 docker swarm service 模式下指定 `--container-label-add`
```bash
docker service update --with-registry-auth \
  --container-label-add "aliyun.logs.demo1-stdout=stdout" \
  --container-label-add "aliyun.logs.demo1-file=/var/log/demo1/*.log" t003

# 批量给一组 service 增加 --container-label 来激活 log-pilot
for h in $(docker service ls |grep 'demo1-' |awk '{print $2}'); do
  echo "[+] 更新 $h 的标签"
  docker service update --with-registry-auth  \
    --container-label-add "aliyun.logs.demo1-stdout=stdout" \
    --container-label-add "aliyun.logs.demo1-file=/var/log/demo1/*.log" $h
done

# 批量查看一组 service 的 Labels
for h in $(docker service ls |grep 'demo1-' |awk '{print $2}'); do
  echo "[+] 查看 $h 的标签"
  docker service inspect -f "{{.Spec.TaskTemplate.ContainerSpec.Labels}}" $h
done

```


### FAQ
**在 swarm mode 中挂载的数据卷的目录中存在软链接目录时遇到的问题**
---
在容器中，访问挂载卷中的路径，出现如下异常的场景：
```bash
##### 创建 service 的指令：
docker service create \
    --name demo1 \
    --with-registry-auth \
    --detach=true \
    --mount type=bind,src="/data/logs",dst="/var/log/demo1" \
    ...

##### 在容器中访问日志路径时：
~]# docker exec -it logs-agent ls /host/data/logs/
ls: /host/data/logs/: No such file or directory

##### 在容器中检查发现，上述路径在 host 上其实是一个软链接，挂载到容器中是无法访问的
~]# docker exec -it logs-agent ls -l /data/ |grep logs
lrwxrwxrwx  1 demo1  demo1    11 Jul 30 10:43 logs -> /data1/logs
```

解决方案：
请注意检查挂载的数据卷中是否存在软链接，可替换为完整的真实路径。


##### ZYXW、参考
1. [Docker 日志收集新方案：log-pilot](https://help.aliyun.com/document_detail/50441.html)
2. [log-pilot](https://github.com/AliyunContainerService/log-pilot/releases)
