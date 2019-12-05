+++
title = "实现VMware运行Ubuntu与宿主机互相复制粘贴"
featured_image = "Linux/Linux.jpg"
description = ""
tags = [
    "linux",
    "Vmware",
    "Ubuntu",
]
date = "2019-12-05"
categories = [
    "Linux",
]
+++


使用Vmware虚拟机中，发现宿主机与虚拟机里面的内容无法互相复制粘贴。造成交互内容麻烦，尝试需要使用管理员权限打开虚拟机，这样就可以正常复制粘贴宿主机中的内容到虚拟机中了。

在Vmware虚拟机中执行下列命令

```bash

$ sudo apt-get autoremove open-vm-tools 
$ sudo apt-get install open-vm-tools-desktop 
$ reboot
```
