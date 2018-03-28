# Android 64K 限制

## 64K
Dalvik VM执行.dex文件时，使用了short类型来索引.dex文件的方法。short类型最大值为65536，即64K

## 如何处理
### 分包
* 在5.0之后，只需要在app的build.gradle中进行如下配置：
```
android {
    defaultConfig {
        ...
        minSdkVersion 21
        targetSdkVersion 26
        multiDexEnabled true
    }
    ...
}
```
在5.0及以上版本，Dalvik VM被替换为ART。不同于DVM的即时编译，ART在应用安装时，就已经进行了预编译，也会将所有.dex文件编译为一个.oat文件。

* 在5.0之前，需要引入分包的support library。

```
dependencis {
  compile 'com.android.support:multidex:1.0.1'
}
```

配置app的build.gradle

```
android {
    defaultConfig {
        ...
        minSdkVersion 19
        targetSdkVersion 26
        multiDexEnabled true
    }
    ...
}
```

如果没有复写Application类，则在manifest中配置application标签：
```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myapp">
    <application
            android:name="android.support.multidex.MultiDexApplication" >
        ...
    </application>
</manifest>
```
如果复写了Application，则让你的Application类继承MultiDexApplication，则在你的Application的onCreate方法中进行如下配置：
```
public class MyApplication extends SomeOtherApplication {
  @Override
  protected void attachBaseContext(Context base) {
     super.attachBaseContext(context);
     Multidex.install(this);
  }
}
```

：
```
public class MyApplication extends MultiDexApplication { ... }
```
如果不能继承MultiDexApplication，则在你的Application的onCreate方法中进行如下配置：
```
public class MyApplication extends SomeOtherApplication {
  @Override
  protected void attachBaseContext(Context base) {
     super.attachBaseContext(context);
     Multidex.install(this);
  }
}
```
