---
title: ANR
date: 2016-9-6
tag: Android
---

ANR, 即Application Not Responding.程序会弹出对话框来提示用户. 发生ANR有多种情况.

* 程序在5秒内没有响应用户输入.
* 启动服务在20秒内没有完成.
* 广播在10秒内没有完成处理.
* 在主线程调用Thread.sleep().
* 在主线程中做耗时操作.

在这里实验下在主线程中调用Thread.sleep()
```

@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        try {
            Thread.sleep(10000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }


    }
```

每次ANR发生的时候,异常信息会保存到/data/anr/trace.txt文件下面.同时,logcat也会有如下信息输出:
```
I/art: Thread[2,tid=24154,WaitingInMainSignalCatcherLoop,Thread*=0xae602000,peer=0x2ac0a100,"Signal Catcher"]: reacting to signal 3
I/art: Wrote stack traces to '/data/anr/traces.txt'
```
traces.txt的信息如下
```

```
