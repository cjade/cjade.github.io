+++
title = "Linux下设置php-fpm开机自动启动"
featured_image = "Linux/Linux.jpg"
description = ""
tags = [
    "linux",
    "php-fpm"
]
date = "2019-12-07"
categories = [
    "Linux",
]
+++

1、创建php-fpm文件
```
vim /etc/init.d/php-fpm
```
然后加入下面的脚本：
```bash
#!/bin/bash
#
# Startup script for the PHP-FPM server.
#
# chkconfig: 345 85 15
# description: PHP is an HTML-embedded scripting language
# processname: php-fpm
# config: /usr/local/php/etc/php.ini
 
# Source function library.
#用which php-fpm找到你文件的位置

PHP_PATH=/usr/local   
DESC="php-fpm daemon"
NAME=php-fpm
# php-fpm路径
DAEMON=$PHP_PATH/php/sbin/$NAME
# 配置文件路径
CONFIGFILE=$PHP_PATH/php/etc/php-fpm.conf
# PID文件路径(在php-fpm.conf设置)
PIDFILE=$PHP_PATH/php/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
 
# Gracefully exit if the package has been removed.
test -x $DAEMON || exit 0
 
rh_start() {
  $DAEMON -y $CONFIGFILE || echo -n " already running"
}
 
rh_stop() {
  kill -QUIT `cat $PIDFILE` || echo -n " not running"
}
 
rh_reload() {
  kill -HUP `cat $PIDFILE` || echo -n " can't reload"
}
 
case "$1" in
  start)
        echo -n "Starting $DESC: $NAME"
        rh_start
        echo "."
        ;;
  stop)
        echo -n "Stopping $DESC: $NAME"
        rh_stop
        echo "."
        ;;
  reload)
        echo -n "Reloading $DESC configuration..."
        rh_reload
        echo "reloaded."
  ;;
  restart)
        echo -n "Restarting $DESC: $NAME"
        rh_stop
        sleep 1
        rh_start
        echo "."
        ;;
  *)
         echo "Usage: $SCRIPTNAME {start|stop|restart|reload}" >&2
         exit 3
        ;;
esac
exit 0
```
保存并退出

3、更改权限
```
sudo chmod +x /etc/init.d/php-fpm
```
4、加入服务

```

update-rc.d php-fpm defaults
 
// 添加
update-rc.d ServiceName defaults
 
// 删除
 
update-rc.d ServiceName remove
```
5、加入到开机启动项

使用chkconfig 命令添加、删除和查看系统开机自启动服务
```
chkconfig --list 显示开机可以自动启动的服务 

chkconfig --add php-fpm 添加开机自动启动php-fpm服务 

chkconfig php-fpm on 来设置开机启动

chkconfig --del php-fpm 删除开机自动启动php-fpm服务
```

[Ubuntu下的sysv-rc-conf完美“替代”CentOS下的chkconfig](https://mcoo.me/en/linux/ubuntu%E4%B8%8B%E7%9A%84sysv-rc-conf%E5%AE%8C%E7%BE%8E%E6%9B%BF%E4%BB%A3centos%E4%B8%8B%E7%9A%84chkconfig/)

6、php-fpm命令
```

service php-fpm start
service php-fpm stop
service php-fpm restart
service php-fpm reload
service php-fpm start

/etc/init.d/php-fpm start
/etc/init.d/php-fpm stop
/etc/init.d/php-fpm restart
/etc/init.d/php-fpm reload
/etc/init.d/php-fpm start
```
