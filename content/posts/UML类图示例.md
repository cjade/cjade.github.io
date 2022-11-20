+++
title =  "UML类图示例"
description = "UML类图示例说明"
image = "images/whoami/avatar.jpg"
date =  2022-11-21T01:08:20+08:00
pinned = false
draft = false

keywords =  [
    "plantuml",
    "uml",
]
tags =  [
    "uml",
    "plantuml",
]

categories = [
   
]

+++

{{< featuredImage >}}



 **使用[plantuml](https://plantuml.com/zh/class-diagram)编写**
 ## 类之间的关系
类之间的关系是用以下符号定义的。

|  **关系类型**   | **符号**  |**绘图**  |
|  ----  | ----  |----  |
| 泛化关系  | `<\|--` |![](https://fastly.jsdelivr.net/gh/cjade/gallery@main/20221121015539.png)
 |
| 组合关系  |`*--`|![](https://fastly.jsdelivr.net/gh/cjade/gallery@main/20221121015553.png)
 |
| 聚合关系  | `o--` |![](https://fastly.jsdelivr.net/gh/cjade/gallery@main/20221121015601.png)
 
可以用`..` 来代替`--` ，会显示为虚线

## UML示例图
![UML示例](https://fastly.jsdelivr.net/gh/cjade/gallery@main/20221121014206.png)

## plantuml代码
```plantuml
@startuml
skinparam groupInheritance 2

abstract 动物 <<abstract>> {
 + 有生命
 + 新陈代谢(o2 氧气, water 水)
 + 繁殖()
}
interface 飞翔 <<interface>> {
	+飞()
}
class 鸟{
	+羽毛
	+有角质缘没有牙齿
	+下蛋()
}
鸟 -up-|> 动物 
note on link #yellow
 继承
 空心三角+实现
end note
note left of 鸟 
class Bird extends Animal{
	private Wing wing;
	public Bird()
	{
		// 在鸟Bird类中，初始化时，实例化翅膀Wing,它们之间同时生成
		wing = new Wing();
	}
}
end note

class 雁群 {
	+V形飞行()
	+一形飞行()
}

note left of 雁群
class WideGooseAggrefate {
	private []WideGoose arrayWideGoose;
}
end note

class 大雁 {
	+下蛋()
	+飞()
  }
大雁 -up-|> 鸟 : 继承
class 企鹅 {
-气候类型 气候
+下蛋()
}
class 鸭 {
  +下蛋()
}
鸭 -up-|> 鸟 : 继承

大雁 -right[hidden]- 鸭
鸭 -right[hidden]- 企鹅

class 唐老鸭 {
    +讲话()
}
唐老鸭 <|-up- 鸭
讲人话 ()- 唐老鸭 
note on link #yellow
 实现接口
 棒棒糖表示发
 圆圈旁边是接口名称
 接口方法在实现类中出现
 interface ILanguage {
	void Speak();
}
end note



大雁 .down.|> 飞翔
note on link #yellow
 实现接口
 空心三角+虚线
end note
note top of 大雁 
class WideGoose extends Bird implements IFly{

}
end note


note right of 企鹅
class Penguin implements Bird{
	private Climate climate;
}
end note
企鹅 -up-|> 鸟 : 继承

class 气候 

企鹅 -down-> 气候
note on link #yellow
关联关系
企鹅是会游泳，不会飞的鸟。更重要的是，它与气候有很大的关联。
企鹅需要‘知道’气候的变化，需要‘了解’气候规律。当一个类‘知道’另一个类时，可 以用关联（association）。
关联关系用实线箭头来表示。
end note

大雁 o-left-> 雁群
note on link #yellow
大雁是群居动物，每个大雁都是属于一个雁群，一个雁群可以有多只大雁。
所以它们之间就满足聚合(Aggregation)关系。聚合表示一总弱的’拥有‘关系，体现的是<b>A</b>对象可以包含<b>B</b>对象，但<b>B</b>对象不是<b>A</b>对象的一部分。
聚合关系用空心的菱形+实线箭头来表示。
end note



class 翅膀
翅膀 "2" <-left-* "1" 鸟
note on link #yellow
合成(组合)关系
合成(<b>Composition</b>,也有’组合‘的意思)是一种强’拥有‘关系，体现了严格的部分和整体的关系，部分和整体的生命周期一样。
这里鸟和翅膀就是合成(组合)关系，因为它们是部分和整体的关系，并且翅膀和鸟的生命周期是相同的。
合成关系用<b>实心的菱形+实线箭头</b>来表示。
另外，你会注意到合成关系的连线两端还有一 个数字‘1’和数字‘2’，这被称为基数。表明这一端的类可以有几个实例，很显然，一个鸟 应该有两只翅膀。
如果一个类可能有无数个实例，则就用‘n’来表示。关联关系、聚合关 系也可以有基数的。
end note

together {
  class 氧气
  class 水
}
氧气 -[hidden]- 水
动物 .left.> 氧气
动物 .left.> 水

note "依赖关系\n动物几点特征，比如有新陈代谢，能繁殖。而动物要有生命力，需要氧气、水以及食物等。\n 也就是说，动物依赖于氧气和水。他们之间是依赖关系(Dependency),\n 用虚线箭头来表示。" as Y1
动物 .left. Y1
Y1 .right. 氧气
动物 .left. Y1
Y1 .right. 水

note top of 动物
abstract class Animal {
	public Metabolism（Oxygen oxygen，Water water） {

}
}
end note

@enduml

```