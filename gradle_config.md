# Gradle Config

## 多渠道打包
1. 在渠道不多的情况下,可以使用如下方法:

```
productFlavors {
      xiaomi {
          manifestPlaceholders = [CHANNEL_VALUE: "xiaomi"]
          buildConfigField "String", "CHANNEL", "\"xiaomi\""
      }

      qihoo {
          manifestPlaceholders = [CHANNEL_VALUE: "qihoo"]
          buildConfigField "String", "CHANNEL", "\"qihoo\""
      }

      tencent {
          manifestPlaceholders = [CHANNEL_VALUE: "tencent"]
          buildConfigField "String", "CHANNEL", "\"tencent\""
      }

      huawei {
          manifestPlaceholders = [CHANNEL_VALUE: "huawei"]
          buildConfigField "String", "CHANNEL", "\"huawei\""
      }

      firim {
          manifestPlaceholders = [CHANNEL_VALUE: "firim"]
          buildConfigField "String", "CHANNEL", "\"firim\""
      }

      googleplay {
          manifestPlaceholders = [CHANNEL_VALUE: "googleplay"]
          buildConfigField "String", "CHANNEL", "\"googleplay\""
      }
}
```

在Android Manifest中添加如下配置

```
<meta-data
        android:name="CHANNEL"
        android:value="${CHANNEL_VALUE}"
/>
```
上面的方法打包非常慢.每打一个包都要执行一次构建过程.

2. 在渠道较多的情况下,可参考美团的打包方法: [链接](http://tech.meituan.com/mt-apk-packaging.html)


## apk名称加上版本号
我们生成的apk的时候,名称最好是加上版本号.对此,我们可以在gradle中加上如下配置.
defaultConfig {
    setProperty("archivesBaseName", "iMCO_$versionName")
}
