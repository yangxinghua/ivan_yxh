---
title: Activity Layout 显示
date: 2016-08-25
tag: Android
---

![activity_display](http://ocfc3ge98.bkt.clouddn.com/activity_display.png)

### startActivity
Actiity是Context的间接子类, startActivity方法是由Context的实现类ContextImpl实现。以下是最终调用的方法
```
ContexxtImpl.java

public void startActivity(Intent intent, Bundle options) {
    warnIfCallingFromSystemProcess();
    if ((intent.getFlags()&Intent.FLAG_ACTIVITY_NEW_TASK) == 0) {
        throw new AndroidRuntimeException(
                "Calling startActivity() from outside of an Activity "
                + " context requires the FLAG_ACTIVITY_NEW_TASK flag."
                + " Is this really what you want?");
    }
    mMainThread.getInstrumentation().execStartActivity(
            getOuterContext(), mMainThread.getApplicationThread(), null,
            (Activity) null, intent, -1, options);
}

```

真正的方法就是Instrumentation的execStartActivity.
```
public ActivityResult execStartActivity(
        Context who, IBinder contextThread, IBinder token, Activity target,
        Intent intent, int requestCode, Bundle options) {
    IApplicationThread whoThread = (IApplicationThread) contextThread;
    //省略一堆代码
    ......

    try {
      //省略一堆代码
      ......

        int result = ActivityManagerNative.getDefault()
            .startActivity(whoThread, who.getBasePackageName(), intent,
                    intent.resolveTypeIfNeeded(who.getContentResolver()),
                    token, target != null ? target.mEmbeddedID : null,
                    requestCode, 0, null, options);
        checkStartActivityResult(result, intent);
    } catch (RemoteException e) {
        throw new RuntimeException("Failure from system", e);
    }
    return null;
}

```

在ActivityManagerNative的gDefault,这是用来创建单例类对象的模板，在create方法中通过ServiceManager查询到key为"acitivty"的服务。
```
protected IActivityManager create() {
    IBinder b = ServiceManager.getService("activity");
    if (false) {
        Log.v("ActivityManager", "default service binder = " + b);
    }
    IActivityManager am = asInterface(b);
    if (false) {
        Log.v("ActivityManager", "default service = " + am);
    }
    return am;
}
```
那这个服务是哪一个？这个要从Android的启动过程来看。当zygote进程启动后，就会首先启动SystemServer服务，然后由SystemServer启动一系列的系统服务。
