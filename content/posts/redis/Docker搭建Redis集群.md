+++
title = "Docker搭建Redis集群"
description = "Docker搭建Redis集群"
featured_image = "/images/redis/redis.jpeg"
date =  2021-03-22T20:25:20+08:00
draft = false
keywords =  [
    "Redis",
    "Redis集群",
    "Docker",
]
tags =  [
    "Redis",
    "Docker",
]

categories = [
    "Redis"
]
+++

[**官方文档**](http://redisdoc.com/topic/cluster-tutorial.html)

**环境Mac + Docker + Redis6.0**

redis集群至少需要6个节点（3个master,3个slave）

redis主从节点是算法分配的，无需指定，所以我们的服务名称都叫redis-master；

# 1. 拉取镜像

```bash
docker  pull  redis:6.0
```

# 2. 配置文件

去下载配置文件  [https://github.com/antirez/redis/blob/6.0/redis.conf](https://github.com/antirez/redis/blob/6.0/redis.conf)

1. 将redis.conf复制6份，分别命名为nodes-7001.conf,nodes-7002.conf....
2. 修改配置，以下是一个包含了最少选项的集群配置文件示例

```bash

# 允许所有ip访问
#bind 127.0.0.1

# 关闭保护模式
protected-mode no

# 设置运行端口
port 7001

# 开启集群功能
cluster-enabled yes

# 设定了保存节点配置文件的路径， 默认值为 nodes.conf
cluster-config-file nodes-7001.conf

# 设置节点超时时间，单位毫秒
cluster-node-timeout 5000

# 外网ip
cluster-announce-ip 192.168.3.40
# 节点映射端口
cluster-announce-port 7001
# 节点总线端
cluster-announce-bus-port 17001

#启动AOF文件 数据持久化
appendonly yes

#如果要设置密码需要增加如下配置：
#设置redis访问密码
requirepass redis-pw

#设置集群节点间访问密码，跟上面一致
masterauth redis-pw
```

# 3. 创建容器

```bash
docker run -d --restart=always -p 7001:7001 -p 17001:17001 --name redis-7001 -v $PWD/nodes-7001.conf:/usr/local/cluster-redis/nodes-7001.conf redis:6.0   redis-server /usr/local/cluster-redis/nodes-7001.conf

docker run -d --restart=always -p 7002:7002 -p 17002:17002 --name redis-7002 -v $PWD/nodes-7002.conf:/usr/local/cluster-redis/nodes-7002.conf redis:6.0   redis-server /usr/local/cluster-redis/nodes-7002.conf

docker run -d --restart=always -p 7003:7003 -p 17003:17003 --name redis-7003 -v $PWD/nodes-7003.conf:/usr/local/cluster-redis/nodes-7003.conf redis:6.0   redis-server /usr/local/cluster-redis/nodes-7003.conf

docker run -d --restart=always -p 7004:7004 -p 17004:17004 --name redis-7004 -v $PWD/nodes-7004.conf:/usr/local/cluster-redis/nodes-7004.conf redis:6.0   redis-server /usr/local/cluster-redis/nodes-7004.conf

docker run -d --restart=always -p 7005:7005 -p 17005:17005 --name redis-7005 -v $PWD/nodes-7005.conf:/usr/local/cluster-redis/nodes-7005.conf redis:6.0   redis-server /usr/local/cluster-redis/nodes-7005.conf

docker run -d --restart=always -p 7006:7006 -p 17006:17006 --name redis-7006 -v $PWD/nodes-7006.conf:/usr/local/cluster-redis/nodes-7006.conf redis:6.0   redis-server /usr/local/cluster-redis/nodes-7006.conf
```

# 4. 创建集群

随便进入一个容器

```bash
docker exec -it redis-7001 bash
```

用redis-cli工具启动集群

 --cluster-replicas 1 说明对于主从节点比例要求，如果设置为1，则最少需要6个节点,3主3从。 -a参数指定密码为123456,如果没有开启密码，则不需要加此参数，开启密码校验的节点，密码必须相同。

```bash
redis-cli --cluster create  192.168.3.40:7001  192.168.3.40:7002  192.168.3.40:7003  192.168.3.40:7004  192.168.3.40:7005  192.168.3.40:7006 --cluster-replicas 1
```

![a](/images/redis/redis-2021-03-22-01.png)

ok，此时集群搭建完了。

查看集群状态

![b](/images/redis/redis-2021-03-22-02.png)

# 测试集群

使用 redis-cli -c 命令连接到集群结点，然后 set 值，set 值之后会自动重定向到  7002端口地址，然后通过 get 获取一下，获取成功证明集群有效。

![c](/images/redis/redis-2021-03-22-03.png)
Done。