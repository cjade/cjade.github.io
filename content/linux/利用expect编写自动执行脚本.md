+++
title = "利用expect编写自动执行脚本"
featured_image = "Linux/Linux.jpg"
description = "使用SSH登录远程服务器机需要手动输入用户名、IP、密码非常麻烦，因此可以用expect编写脚本利用脚本自动登入。"
tags = [
    "linux",
    "ssh",
]
date = "2019-12-08"
categories = [
    "Linux",
]
+++

使用SSH登录远程服务器机需要手动输入用户名、IP、密码非常麻烦，因此可以用expect编写脚本利用脚本自动登入。

## 安装expect
### Mac下安装
```
brew install expect
```
### Ubuntu下安装
```
apt install expect
```
## expect命令

### send 用于向进程发送字符串
`send`命令接收一个字符串参数，并将该参数发送到进程。
### expect 从进程接收字符串
`expect`命令和`send`命令相反，expect通常用来等待一个进程的反馈，我们根据进程的反馈，再发送对应的交互命令。
### spawn 启动新的进程
`spawn`命令用来启动新的进程，`spawn`后的`send`和`expect`命令都是和使用spawn打开的进程进行交互。
### interact 允许用户交互
`interact`命令用的其实不是很多，一般情况下使用`spawn`、`send`和`expect`命令就可以很好的完成我们的任务；但在一些特殊场合下还是需要使用`interact`命令的，`interact`命令主要用于退出自动化，进入人工交互。比如我们使用s`pawn`、`send`和`expect`命令完成了`ftp`登陆主机，执行下载文件任务，但是我们希望在文件下载结束以后，仍然可以停留在`ftp`命令行状态，以便手动的执行后续命令，此时使用`interact`命令就可以很好的完成这个任务。

## 编写脚本
```
vim autologin.sh
```
添加
```

#expect的安装路径
#!/usr/bin/expect -f
#设置超时时间 
set timeout 3
#私人密码
set password yourpassword
#传递交互指令
spawn ssh root@ip
#根据输出传递数据
expect {
    -re "password" {send "$password\r"}
    -re "yes/no" {send "yes\n";exp_continue} # 有的时候输入几次密码来确认,exp_continue
}
#保持在远端  
interact
#expect eof
```
注意：若登陆后便退出远程终端，则写`expect eof`即可。

chmod +x ./autologin.sh  #使脚本具有执行权限

执行./autologin.sh即可完成登录。

