---
title: LeakCanary
date: 2016-9-19
tag: Android
---

# LeakCanary
LeakCanary 是 Square开源的检测内存泄漏的工具。通过生成Hprof。

## 使用

在build.gradle中添加依赖：
```
dependencies {
  debugCompile 'com.squareup.leakcanary:leakcanary-android:1.4'
  releaseCompile 'com.squareup.leakcanary:leakcanary-android-no-op:1.4'
  testCompile 'com.squareup.leakcanary:leakcanary-android-no-op:1.4'
}
```

在你的Application的onCreate方法中添加如下代码：
```
public class ExampleApplication extends Application {

  @Override public void onCreate() {
    super.onCreate();
    if (LeakCanary.isInAnalyzerProcess(this)) {
      // This process is dedicated to LeakCanary for heap analysis.
      // You should not init your app in this process.
      return;
    }
    LeakCanary.install(this);
    // Normal app init code...
  }
}

```
只要执行添加以上的代码，你就可以使用LeakCanary来进行内存泄漏的检测了。当检测到内存泄漏时，会在通知栏弹出通知，打开通知就可以知道是在哪里出现了内存泄漏。

## 过程
1. 通过Application的registerActivityLifecycleCallbacks方法监听Activity的生命周期。
2. 当一个Actviity调用onDestroy的时候，创建该Activity的WeakReference对象。
3. 触发GC，如果该Activity对象没有被回收，生成head dump文件. 启动HeapAnalyzerService，通过HeapAnalyzer生成Hprof，进行分析，并将结果交给DisplayLeakService处理。生成head dump以及分析，使用的是Square自家的[HAHA](https://github.com/square/haha)
4. 在DisplayLeakService中，如果结果是发生了泄漏，发送通知。
