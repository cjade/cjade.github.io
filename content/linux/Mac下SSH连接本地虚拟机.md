+++
title = "Mac下SSH连接本地虚拟机"
featured_image = "Linux/Linux.jpg"
description = ""
tags = [
    "linux",
    "Vmware",
    "Ubuntu",
    "ssh"
]
date = "2019-12-05"
categories = [
    "Linux",
]
+++

1、连接拒绝
```
$ ssh jade@172.16.50.129
```
结果
```
ssh: connect to host 172.16.50.129 port 22: Connection refused
```
2、检查虚拟机的SSH服务是否开启
```
$ ps -e | grep ssh
```
结果
```
 1419 ?        00:00:00 ssh-agent
```
只出现ssh-agent则没有开启ssh

3、开启SSH服务
```
$ sudo service ssh start
```
结果
```
Failed to start ssh.service: Unit ssh.service not found.
```
没有ssh服务

4、安装openssh-server
```
$ sudo apt-get install openssh-server
```
安装完毕再次执行`sudo service ssh start`启动ssh服务

5、开启成功

![image](/images/Linux/seesshopen.png)

6、再次连接虚拟机

![image](/images/Linux/sshconnection.png)

成功、结束。
