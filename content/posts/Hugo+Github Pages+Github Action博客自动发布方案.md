+++
title = "Hugo+Github Pages+Github Action博客自动发布方案"
date = 2022-11-23T22:46:09+08:00
image = "images/whoami/avatar.jpg"
description = "Hugo+Github Pages+Github Action博客自动发布方案"
draft = false
keywords = [
    "Hugo",
    "Github Pages",
    "Github Action",
]
tags = [
    "hugo"
]

categories = [
    ""
]
+++

<!-- 图片显示 -->
{{< featuredImage >}}

本篇文章，默认为已经配置好本地的Hugo环境。

## 为什么要配置Github Action
我的博客全部代码放在自己的github pages(xxx/xxx.github.io)仓库管理，public 文件由pages分支单独管理。仓库设置里就可以指定GitHub Pages分支为pages。

没有配置Github Action 之前我们要发布一篇文章，要经过以下步骤：

1. 在本地写好md文章
2. 用hugo构建文章到public目录下
3. 把本地仓库推送到github
4. 把public 推送到github

配置Github Action 后，我们就只需要把写好的md文章，提交到github，然后坐等网站跟新就可以了。

## 配置Github Action
在博客根目录下，创建Github Action配置文件
<mark style="background: #FF5582A6;">.github/workflows/pages.yml</mark>
```yml
name: GitHub Pages❤
on:
  push:
    branches:
      - main
jobs:
  build-deploy:
    runs-on: ubuntu-20.04
    steps:
      - name: Check out source
        uses: actions/checkout@v3
        with:
          submodules: recursive 
          fetch-depth: 0
     
          
      - uses: actions/cache@v2
        with:
          path: /tmp/hugo_cache
          key: ${{ runner.os }}-hugomod-${{ hashFiles('**/go.sum') }}
          restore-keys: |
            ${{ runner.os }}-hugomod-
            
      - name: Setup hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: "0.101.0" #
          # extended: true # 设置是否需要 extended 版本
          
      - name: Build
        run: hugo --theme=zzo --baseUrl="https://week8.fun/" #hugo 构建时选择模版设置URL

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          personal_token: ${{ secrets.PERSONAL_TOKEN }} 
          external_repository: xxx/xxx.github.io 
          publish_dir: ./public
#          keep_files: false
          publish_branch: pages
          cname: week8.fun
```

## 配置合适的token
1. 在个人GitHub页面，依次点击<mark style="background: #FF5582A6;">Settings</mark>-> <mark style="background: #FF5582A6;">Developer settings</mark>-> <mark style="background: #FF5582A6;">Personal access tokens</mark> -> <mark style="background: #FF5582A6;">Tokens (classic)</mark> 进入

![](https://fastly.jsdelivr.net/gh/cjade/gallery@main/20221123222323.png)

2. 点击 <mark style="background: #FF5582A6;">Generate new token</mark> 然后点击 <mark style="background: #FF5582A6;">  Generate new token (classic)</mark>
3. 设置 <mark style="background: #FF5582A6;">Note</mark> 
4. 设置 <mark style="background: #FF5582A6;">Expiration</mark> 为 <mark style="background: #FF5582A6;">No expiration</mark>(永不过期)
5. <mark style="background: #FF5582A6;">Select scopes</mark> 选择 <mark style="background: #FF5582A6;">workflow</mark>
6. 点击 <mark style="background: #BBFABBA6;">Generate token</mark> 生成token
7. 复制生成的 <mark style="background: #FF5582A6;">token</mark> ，注意一旦离开页面后续就无法查看，只能从新生成。
8. 进入对应的 <mark style="background: #FF5582A6;">pages</mark> 项目下
9. 选择 <mark style="background: #FF5582A6;">Secrets</mark> -> <mark style="background: #FF5582A6;">Actions</mark>   点击 <mark style="background: #BBFABBA6;">New repository secret</mark> 
10. 设置 <mark style="background: #FF5582A6;">Name</mark> 为 <mark style="background: #FF5582A6;">PERSONAL_TOKEN</mark> 并把刚刚生成的 <mark style="background: #FF5582A6;">Token</mark> 放入 <mark style="background: #FF5582A6;">Secret</mark> 点击 <mark style="background: #BBFABBA6;">Add secret</mark> 。

整个过程就已经设置完成了。

本地的public目录就可以删除了。现在就可以写一篇md文章，用git命令push到github仓库，即可触发GitHub Action。等待几分钟就可以在网站上看到我们刚刚写的文章。