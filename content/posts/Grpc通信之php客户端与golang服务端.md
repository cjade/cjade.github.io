+++
title =  "Grpc通信之php客户端与golang服务端"
description = "Grpc通信之php客户端与golang服务端"
image = "images/whoami/avatar.jpg"
date =  2022-11-17T18:08:20+08:00
pinned = true
draft = false

keywords =  [
    "grpc",
    "golang",
    "go",
    "php",
]
tags =  [
    "grpc",
    "golang",
    "php",
]

categories = [
    "grpc",
]

+++

{{< featuredImage >}}



# Grpc通信之php客户端与golang服务端
- [grpc](https://grpc.io/docs/languages/)
- 服务端 golang iris  
- 客户端 php laravel

## golang 服务端

- 创建项目

```bash

mkdir iris-example

cd iris-example

go mod init iris-example

go mod tidy

 
```
### 安装gRPC和Protobuf 

https://grpc.io/docs/languages/go/quickstart/

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28

go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```

### 定义proto 文件
api/protos/test/test.proto
```proto

// 指定proto版本
syntax = "proto3";  

// 指定默认包名
package test;  

// 指定golang包名
option go_package = ".;test";  
  
  
// The greeting service definition.  
service Greeter {  
  // Sends a greeting  
  rpc SayHello (HelloRequest) returns (HelloReply) {}  
}  
  
// The request message containing the user's name.  
message HelloRequest {  
  string name = 1;  
}  
  
// The response message containing the greetings  
message HelloReply {  
  string message = 1;  
}
```

### 生成go的grpc代码

- --go_out=.  表示输出的文件夹,需要我们自己创建 .当前文件夹

- go_opt=paths=source_relative  表示按源文件的目录组织输出,也就是" the same relative directory ",  
这意味着,会将proto文件相对proto_path指定的基目录,按同样的目录组织,在$go_out上重放一遍
> 一般都会使用source_relative,否则，就会按照option go_package里面的那个路径生成

iris-example 根目录执行
```bash
protoc --go_out=. --go_opt=paths=source_relative  --go-grpc_out=. --go-grpc_opt=paths=source_relative api/protos/test/test.proto
```

创建<mark style="background: #FF5582A6;">protos</mark>目录，在此目录下创建proto 文件
目录结构如下
```text
#iris-example
#├──api
#├──└── protos
#│    └── test
#│        ├── test.pb.go
#│        ├── test.proto
#│        └── test_grpc.pb.go
#├──server
#├──└── grpc_server.go
```

### 实现服务端接口 `server/grpc_server.go`

```go
// Package main implements a server for Greeter service.  
package main  
  
import (  
   "context"  
   "flag"   "fmt"   pb "iris-example/api/protos/test"  
   "log"   "net"  
   "google.golang.org/grpc")  
  
var (  
   port = flag.Int("port", 50051, "The server port")  
)  
  
// server is used to implement helloworld.GreeterServer.type server struct {  
   pb.UnimplementedGreeterServer  
}  
  
// SayHello implements helloworld.GreeterServerfunc (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {  
   log.Printf("Received: %v", in.GetName())  
   return &pb.HelloReply{Message: "Hello " + in.GetName()}, nil  
}  
  
func main() {  
   flag.Parse()  
   lis, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))  
   if err != nil {  
      log.Fatalf("failed to listen: %v", err)  
   }  
   s := grpc.NewServer()  
   pb.RegisterGreeterServer(s, &server{})  
   log.Printf("server listening at %v", lis.Addr())  
   if err := s.Serve(lis); err != nil {  
      log.Fatalf("failed to serve: %v", err)  
   }  
}
```
### 启动服务

```bash
go run server/grpc_server.go
```

## 创建PHP客户端

laravel 项目


### 安装php扩展

```bash
pecl install protobuf
pecl install grpc
```

### 编译安装protoc的grpc_php_plugin插件

```bash
# 下载对应分支（对应版本的）grpc
git clone -b RELEASE_TAG_HERE https://gitee.com/github-fast-sync/grpc

cd grpc

# 下载子模块
git submodule update --init

mkdir -p cmake/build
cd cmake/build
# 编译 protoc 与 grpc_php_olugin makefile 文件
cmake ../..

# 编译 makefile文件 生成可执行文件
make protoc grpc_php_plugin

# 编译完成后将grpc_php_plugin 移动到 /usr/local/bin 目录下
 mv grpc_php_plugin /usr/local/bin

```

### 生成PHP的gRPC客户端代码

在laravel根目录执行

```bash
protoc -I=/Users/Jade/Code/Go/iris-example/api/protos/ --php_out=./grpc --grpc_out=./grpc --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin  /Users/Jade/Code/Go/iris-example/api/protos/test/test.proto
```
- -I(等同--proto_path)  用于表示要编译的proto文件所依赖的其他proto文件的查找位置，可以使用-I来替代。如果没有指定则从当前目录中查找

- --php_out php代码输出路径，里面包含request，response，client代码。

- --grpc_out GPBMetadata输出路径，用于保存.proto的二进制元数据

- --plugin 生成代码插件的类型与插件的绝对路径路径

- 最后 定义好的proto文件路径



生成目录

```
# laravel-example-app
grpc
├── GPBMetadata  # 二进制元数据
│   └── Test
│       └── Test.php
└── Test  # 客户端代码
    ├── GreeterClient.php
    ├── HelloReply.php
    └── HelloRequest.php
```

把<mark style="background: #FF5582A6;">grpc</mark> 放在 <mark style="background: #FF5582A6;">composer.json</mark>的<mark style="background: #FF5582A6;">autoload/psr-4</mark>下
```json
"autoload": {  
    "psr-4": {  
        "App\\": "app/",  
        "Database\\Factories\\": "database/factories/",  
        "Database\\Seeders\\": "database/seeders/",  
        "GPBMetadata\\":"grpc/GPBMetadata/",  
        "Test\\":"grpc/Test/"  
    } 
},
```

### 添加composer相关依赖

```bash
composer require google/protobuf
composer require grpc/grpc
```


### 客户端调佣服务端

创建<mark style="background: #FF5582A6;">app/Http/Controllers/TestController</mark> 控制器，新建grpc方法，代码如下
```php
<?php  
declare(strict_types=1);  
  
namespace App\Http\Controllers;  
    
use Grpc\ChannelCredentials;    
use Test\GreeterClient;  
use Test\HelloReply;
use Test\HelloRequest;  
  
class TestController extends Controller  
{  

    public function grpc(): JsonResponse
    {
        $host    = 'localhost:50051';
        $client  = new GreeterClient($host, [
            'credentials' => ChannelCredentials::createInsecure(),
        ]);
        $name    = 'world';
        $request = new HelloRequest();
        $request->setName($name);
        $call = $client->SayHello($request);
        /**
         * @var HelloReply $response
         */
        list($response, $status) = $call->wait();
        $data = [
            'status' => $status,
            'message' => $response->getMessage()
        ];
        return response()->json($data,200, [], JSON_UNESCAPED_UNICODE);
    }
}
```

<mark style="background: #FF5582A6;">routes/api.php</mark>文件增加路由

```php
Route::get("grpc",[TestController::class, 'grpc']);
```

### 启动laravel
```bash
php artisan serve
```

### 请求服务器
浏览器访问
[http://127.0.0.1:8000/api/grpc](http://127.0.0.1:8000/api/grpc)
```json
{
  "status": {
    "metadata": [
      
    ],
    "code": 0,
    "details": ""
  },
  "message": "Hello world"
}
```
输出以上内容就成功了。