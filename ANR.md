---
title: ANR
date: 2016-9-6
tag: Android
---

ANR, 即Application Not Responding.程序会弹出对话框来提示用户. 发生ANR有多种情况.

##### 1.程序在5秒内没有响应用户输入.
如果在主线程中执行了耗时操作，比如进行IO操作、调用了Thread.sleep()等，而导致主线程无法马上响应用户的操作，这时候，就会弹出来ANR的对话框。

##### 2.广播在10秒内没有完成处理.
在收到广播时，会回调onReceive方法。如果我们在onReceive方法中的操作在10秒中之内没有完成，系统也会弹出ANR的对话框。

##### 3.启动服务在20秒内没有完成.


每次ANR发生的时候,异常信息会保存到/data/anr/trace.txt文件下面.同时,logcat也会有如下信息输出:
```
I/art: Thread[2,tid=24154,WaitingInMainSignalCatcherLoop,Thread*=0xae602000,peer=0x2ac0a100,"Signal Catcher"]: reacting to signal 3
I/art: Wrote stack traces to '/data/anr/traces.txt'
```
traces.txt的信息如下
```
//省略一堆信息
......

DALVIK THREADS (15):
"main" prio=5 tid=1 Sleeping
  | group="main" sCount=1 dsCount=0 obj=0x74426000 self=0xb4025800
  | sysTid=2654 nice=0 cgrp=default sched=0/0 handle=0xb77e5ea0
  | state=S schedstat=( 0 0 0 ) utm=34 stm=25 core=1 HZ=100
  | stack=0xbf627000-0xbf629000 stackSize=8MB
  | held mutexes=
  at java.lang.Thread.sleep!(Native method)
  - sleeping on <0x15dbe433> (a java.lang.Object)
  at java.lang.Thread.sleep(Thread.java:1031)
  - locked <0x15dbe433> (a java.lang.Object)
  at java.lang.Thread.sleep(Thread.java:985)
  at com.ivan.flatmapdemo.MainActivity$1$override.onClick(MainActivity.java:32)
  at com.ivan.flatmapdemo.MainActivity$1$override.access$dispatch(MainActivity.java:-1)
  at com.ivan.flatmapdemo.MainActivity$1.onClick(MainActivity.java:0)
  at android.view.View.performClick(View.java:4780)
  at android.view.View$PerformClick.run(View.java:19866)
  at android.os.Handler.handleCallback(Handler.java:739)
  at android.os.Handler.dispatchMessage(Handler.java:95)
  at android.os.Looper.loop(Looper.java:135)
  at android.app.ActivityThread.main(ActivityThread.java:5254)
  at java.lang.reflect.Method.invoke!(Native method)
  at java.lang.reflect.Method.invoke(Method.java:372)
  at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:903)
  at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:698)

//省略一堆信息
......
```
上面的信息指出了是在MainActivity的第32行代码导致了ANR，这行代码就是   `Thread.sleep(10*1000);`.
