## 初始化本地.gitmodules文件
```
git submodule init  
```
## 同步远端submodule源码
```
git submodule update  
```
## 测试
```
hugo server --theme=zzo --buildDrafts -w
```
## 编译
```
hugo --theme=zzo --baseUrl="https://week8.fun/"
```