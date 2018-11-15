# 容器日志收集方案探索之log-pilot
2018/11/15

> log-pilot: 阿里云开源的日志采集器

具有如下特性：

* 一个单独的 log 进程收集机器上所有容器的日志。不需要为每个容器启动一个 log 进程。
* 支持文件日志和 stdout。docker log dirver 亦或 logspout 只能处理 stdout，log-pilot 不仅支持收集 stdout 日志，还可以收集文件日志。
* 声明式配置。当您的容器有日志要收集，只要通过 label 声明要收集的日志文件的路径，无需改动其他任何配置，log-pilot 就会自动收集新容器的日志。
* 支持多种日志存储方式。无论是强大的阿里云日志服务，还是比较流行的 elasticsearch 组合，甚至是 graylog，log-pilot 都能把日志投递到正确的地点。
* 开源。log-pilot 完全开源，您可以从 这里 下载代码。如果现有的功能不能满足您的需要，欢迎提 issue。





##### ZYXW、参考
1. [Docker 日志收集新方案：log-pilot](https://help.aliyun.com/document_detail/50441.html)
2. [log-pilot](https://github.com/AliyunContainerService/log-pilot/releases)
