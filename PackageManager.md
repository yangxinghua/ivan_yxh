# PackageManager
在要获取APK版本信息或者包名时,我们都需要PackageManager来获取.那PackageManager是如何获取
到这些信息的呢?

通常我们都是调用context.getPackageManager()就可以获取到PackageManager了.看一下这个方法的
实现.首先要知道Context是一个抽象类.getPackageManager方法具体是由ContextImpl实现的
```
@Override
public PackageManager getPackageManager() {
    if (mPackageManager != null) {
        return mPackageManager;
    }

    IPackageManager pm = ActivityThread.getPackageManager();
    if (pm != null) {
        // Doesn't matter if we make more than one instance.
        return (mPackageManager = new ApplicationPackageManager(this, pm));
    }

    return null;
}

```
从``` new ApplicationPackageManager() ``` 我们知道获取到的PackageManager其实是
ApplicationPackageManager实例
接着我们来看看 ActivtyThread.getPackageManager()

```
public static IPackageManager getPackageManager() {
        if (sPackageManager != null) {
            //Slog.v("PackageManager", "returning cur default = " + sPackageManager);
            return sPackageManager;
        }
        IBinder b = ServiceManager.getService("package");
        //Slog.v("PackageManager", "default service binder = " + b);
        sPackageManager = IPackageManager.Stub.asInterface(b);
        //Slog.v("PackageManager", "default service = " + sPackageManager);
        return sPackageManager;
    }

```
通过ServiceManager.getService()查询到package服务返回Binder接口,通过Binder来得到PackageManager
实例.这个IPackageManager的实现是哪个类? -->PackageManagerService.它实现了IPackageManager.Stub
(附一个AIDL的DEMO, 来自Android开发艺术探索 [AIDL](git@github.com:yangxinghua/AIDLDemo.git))
在PackageManagerService中保存了已经安装的应用的各种信息,包括版本号,Activity,Service,
Receiver,ContentProvider,最后升级时间,安装时间等等.
