---
title: LaunchMode
date: 2016-8-24
tag: Android
---

# Activity LaunchMode
在AndroidManifest的Activity配置中有一个属性是launcheMode,就是配置Activity的启动方式.
Android developers对launchMode的解释是:An instruction on how the activity should be launched.
在解析Activity的启动方式的时候,有必要了解Task一下的概念.官方解释:A task is a collection of activities that users interact with when performing a certain job. 简单来说Task就是里面存放了一个或多个Acitivty.
## standard
默认的启动方式.在task中可以存放多个实例.比如说启动了两个相同的Actiivty,在Task中存在两个该
Activity实例.

## singleTop
如果在task存在当前实例,并且在栈顶,不会新建一个实例, 只会调用Activity的onNewIntent().否则,
新建Activity实例.

## singleTask
如果当前task不存在该实例, 系统会新建一个实例并把这个实例放到一个新的task中.如果在task中存在该
实例,则会把位于该实例之上的Activity都出栈,并调用该实例的onNewIntent().然而当你设置了singleTask属性之后,你会发现,然并卵,还是在同一个Task中.这时候,你需要定义taskAffinity值.
任意值都可以，除了包名。因为task的taskAffinity默认为包名。

## singleInstance
跟singleTask的区别在于,新的task只存放一个实例,如果再启动其他Activity,会新建另一个task.
而singleTask模式中,新的task中可以存放其他实例,即如果再启动一个standard的Activity,还是存在
在当前task.
