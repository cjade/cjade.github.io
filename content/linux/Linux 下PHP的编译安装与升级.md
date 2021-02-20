+++
title = "Linux 下PHP的编译安装与升级到PHP7.4"
featured_image = "Linux/Linux.jpg"
description = ""
tags = [
    "linux",
    "Ubuntu",
    "PHP"
]
date = "2019-12-06"
categories = [
    "Linux",
    "PHP"
]
+++





## PHP的编译安装
### 官网下载
https://www.php.net/downloads.php

> 以[php-7.3.12.tar.bz2 (sig)](https://www.php.net/distributions/php-7.3.12.tar.bz2) 为例

### 下载
```
cd /usr/local/src

wget https://www.php.net/distributions/php-7.3.12.tar.bz2
```

### 解压
```

tar -xjvf php-7.4.0.tar.bz2
cd php-7.4.0
```
### 安装依赖
安装一些编译PHP所需要的依赖
```

sudo apt update
sudo apt install gcc
sudo apt install make
sudo apt install openssl
sudo apt install curl
sudo apt install libbz2-dev
sudo apt install libxml2-dev
sudo apt install libjpeg-dev
sudo apt install libpng-dev
sudo apt install libfreetype6-dev
sudo apt install libzip-dev
```
### 配置PHP
查看以前编译php所使用的编译参数
>php -i | grep configure
```
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm
```
--prefix 安装路径
--with-config-file-path 配置文件路径
### 编译并安装

编译
```
make 
```
安装
```
sudo make install
```

### 复制php.ini配置文件
php.ini放在`--with-config-file-path`地址
```bash
sudo cp php.ini-development /usr/local/php/etc/php.ini #生成环境复制php.ini-production或者都复制php.ini-production
```

### 将 /usr/local/php/bin 添加到系统环境变量中，方便使用php和phpize等命令

```
vim /etc/profile  #注：该配置对所有用户生效
```
在最后一行添加
```
export PATH=$PATH:/usr/local/php/bin
```
保存退出
```

source /etc/profile

php -v
```

### 配置php-fpm
#### 创建并设置php-fpm运行账号
```bash

groupadd www-data

useradd -M -g www-data -s /sbin/nologin www-data
```

#### 设置php-fpm 配置
```

cd /usr/local/php/etc

sudo cp php-fpm.conf.default php-fpm.conf

cd php-fpm.d/

sudo cp www.conf.default www.conf

vim www.conf
```
搜索`user`设置运行账号：
```

user = www-data
group = www-data
```
去掉`;pid = run/php-fpm.pid`前的分号
```
pid = run/php-fpm.pid
```
保存退出

#### PHP-FPM启动脚本设置
[Linux下设置php-fpm开机自动启动](/linux/linux%E4%B8%8B%E8%AE%BE%E7%BD%AEphp-fpm%E5%BC%80%E6%9C%BA%E8%87%AA%E5%8A%A8%E5%90%AF%E5%8A%A8/)

#### 启动PHP-FPM
```
sudo service php-fpm start
```

## 升级安装 PHP 至 7.4.0

### 备份配置文件
**注意**:
一定要备份好配置文件
```
sudo mv /usr/local/php /usr/local/php-7.3.12
```

### 下载
```

cd /usr/local/src

wget https://www.php.net/distributions/php-7.4.0.tar.bz2
```

### 解压
```

tar -xjvf php-7.4.0.tar.bz2
cd php-7.4.0
```

### 停止php-fpm
```
sudo service php-fpm stop 
```

### 配置PHP
查看以前编译php所使用的编译参数
>php -i | grep configure
```
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm
```
### 编译并安装

编译
```
sudo make 
```
安装
```
sudo make install
```
### 复制默认配置文件（从 /usr/local/php-7.3.12 目录拷贝就行）

```

cp /usr/local/php-7.3.12/etc/php.ini  /usr/local/php/etc/php.ini

cp /usr/local/php-7.3.12/etc/php-fpm.conf  /usr/local/php/etc/php-fpm.conf

cp /usr/local/php-7.3.12/etc/php-fpm.d/www.conf  /usr/local/php/etc/php-fpm.d/www.conf

```

### 启动php-fpm
```
sudo service php-fpm start
```
完成。




