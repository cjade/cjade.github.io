+++
title = "ubuntu当使用命令sudo apt install sysv-rc-conf安装不上时，提示“ E: 无法定位软件包问题"
featured_image = ""
description = "ubuntu当使用命令sudo apt install sysv-rc-conf安装不上时，提示“ E: 无法定位软件包问题"
keywords = [
    "linux",
    "sysv-rc-conf",
    "无法定位软件包问题",
    "ubuntu"
]
tags = [
    "linux",
    "ubuntu"
]
date = "2019-12-06"
categories = [
    "Linux",
]
+++

1、进入 `/etc/apt`

2、 使用`vim sources.list`命令  在里面`sources.list` 添加镜像源   `deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse`

3、然后 sudo apt-get update  

 

4、 sudo apt install sysv-rc-conf 接着安装就可以了
