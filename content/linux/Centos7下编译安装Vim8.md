+++
title = "Centos7下编译安装Vim8"
featured_image = "Linux/Linux.jpg"
description = ""
tags = [
    "linux",
    "vim",
    "Centos"
]
date = "2019-12-18"
categories = [
    "Linux",
]
+++

## 安装依赖插件

为了使vim支持ruby、lua、perl、python2、python3编写的插件，在正式编译安装vim之前需要在系统中安装好相关插件，否则编译vim会出错。

    sudo yum install ruby ruby-devel lua lua-devel luajit \
    luajit-devel ctags git python python-devel \
    python36 python36-devel tcl-devel \
    perl perl-devel perl-Extutils-ParseXS \
    perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
    perl-ExtUtils-Embed libX* ncurses-devel gtk2-devel

## 卸载已有vim

    yum -y remove vim

## 下载vim的项目源码

    git clone https://github.com/vim/vim.git

由于国内下载GitHub项目实在是太慢了，这里分享一个加速方法，就是把GitHub的项目克隆到[**码云](https://gitee.com/)**
然后再下载

## 配置、编译、安装

进入到vim目录

- 配置

        ./configure --with-features=huge \
        --enable-gui=gtk2 \
        --with-x \
        --enable-fontset \
        --enable-cscope \
        --enable-multibyte \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib64/python2.7/config \
        --enable-python3interp \
        --with-python3-config-dir=/usr/lib64/python3.6/config \
        --enable-luainterp \
        --enable-rubyinterp \
        --enable-perlinterp \
        --enable-multibyte \
        --prefix=/usr/local/vim \
        --with-compiledby="jade"

    - 参数说明：

        –with-features=huge：             支持最大特性

        –enable-rubyinterp：                启用Vim对ruby编写的插件的支持

        –enable-pythoninterp：            启用Vim对python编写的插件的支持

        -enable-python3interp：         启用对python3编写的插件的支持

        –enable-luainterp：                  启用Vim对lua编写的插件的支持

        –enable-perlinterp：                 启用Vim对perl编写的插件的支持

        –enable-multibyte：                 多字节支持 可以在Vim中输入中文

        --enable-fontset：                    支持字体设置

        –enable-cscope：                      Vim对cscope支持 ，cscope是一款优秀的代码浏览工具

        –enable-gui=gtk2：                   gtk2支持,也可以使用gnome，表示生成gvim

        -–with-python-config-dir：       指定 python配置 路径

        --with-python3-config-dir：     指定python3配置路径

        –-prefix：                                     编译安装路径

        --with-compiledby：                  编译者

    - 编译

            make

        如果编译错误则可能是缺少相关插件，回过头去查看上面那些插件是否都已安装上。

    - 安装

            make install

## 设置环境变量

设置系统环境变量，把vim的bin目录添加到path中，在/etc/profile末尾添加

source  /etc/profile或者重新打开一个终端就可以使用vim和gvim来打开文件了。下图是我安装好之后执行vim的输出截图

    # 注意/usr/local换成你的vim安装路径
    export PATH=/usr/local/vim/bin:$PATH

![vim8](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/57c5a68b-d83b-43c1-b79c-dd58af311ac0/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAT73L2G45CMBPGW75%2F20191218%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20191218T090556Z&X-Amz-Expires=86400&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEEgaCXVzLXdlc3QtMiJGMEQCIHMfpMJB6zs3uuicp%2FaUWQncpelMi%2F%2FMZDAn%2FSU%2BhkjdAiAWygZaUZuZA0h5%2BBnC3vZruVPPRyfWD3viFml6xcAiXSrcAgih%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAAaDDI3NDU2NzE0OTM3MCIMuP0npoH5fYIJOFPUKrACRJaBaODEn3viqioWCs1IphDbHzLqQ%2BnAwUN5DqQHonddjQcXAIZTdZPfxJxWhAeUFpFJxc6unoEvjSDdoMEfVI51wACsDKXTvGmtT7hOQixzFsYSIPtoVOdy%2Bkr4fRciIcEH%2BXx6kkaT7uOFkeiFIp%2FfbpCQzvEtou1Q1Wqk%2Fyddd0wvjylsKtze9kl77ejAc8W7XtI4%2FEkb1hbu%2FDc6kkgMTrgxJ%2BAFy6c0l0yIxuKlLe5D%2FKSREGik76Ow%2FvH5YqIaQqBRskEXaZ%2FFsrGvJuibYANrlTSLTq8IgrpzLXivjiYYpYbnhHDv1AupGze1xzIm%2FKVtH7QFHw7jG%2FEhtRB0crDtf7iw%2FDWObGUPq8JHlNTYCpBXO7XK5XX%2BhP7jKS8%2BBVJh12Z1K%2FhRvnG7mDC%2BuOfvBTrNAlPjhdP2bFLNwAKGSq4tFyA4Gp73rgDOmfx0lDfaMl%2Bj4omyOS%2FcUsAH9LLt%2BqSooTSdKXMCyy2QfjFqpRzvUVVpeHT2Xi75PZHGwX2g%2BXUuLzYCJjzz%2Fjhjv4DunMsDSbxZNiZynvkywWJwlj7cWxeLqDCzghF2pSWPB9YFo6Ohfp4s7T4SlWi7sNyxSu4cHRQ%2FQYkA1e2Udv0kP%2FQeHqorxeDMefldY%2FrD%2FGcdZ3zEo3PO8u1uxzxZ6A2TobCrRuYXVj0PrHfhZlFMveX4YdLtLTzKZmAY0h1tM2gp4Fp1Oj7FPeTxnmv2SYTXJb%2F5X3rEiCzq6qG%2FlLYjgDDJZW4Bp9aSo8ymw%2FJHghBJ%2FiICDpNZ07I4wYpfBbAE9o18rjRE1ZqnZCWH%2BcH12xBWlL71PNmEjHbuNkC34m3pGGoIW8qzqZnJtkfzUKIJuA%3D%3D&X-Amz-Signature=8e4498107666fb1107a2d631455135f9d68709c34ae97688e037734e3a628a2b&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)