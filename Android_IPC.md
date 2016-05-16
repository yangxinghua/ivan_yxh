# Android IPC

## IPC是Inter-Process Communication的缩写。其含义为进程间通信，指的是两个进程间进行数据交换。
进程与线程的区别：线程是CPU调度的最小单元，而进程一般指一个执行单元，一般指一个应用程序。一个进程
可以包含多个线程。也可以只包含一个线程，即主线程。


## 在同一个应用中开启多进程
要在同一个应用中开启多进程， 只需要给四大组件在AndroidMenifest中指定：android：process属性。
但是，多线程会带来一些问题：
* 静态成员和单例模式完全失效。
* 线程同步机制完全失效。
* SharedPreferences的可靠性下降。
* Application会多次创建。

## 序列化
进程间数据传输需要将数据先进行序列化。可以通过以下两种方式进行序列化：
* Serializable接口（Java提供）
* Parcelable 接口（Android提供）

## Android中的IPC方式
* 使用Bundle. 因为Bundle已经实现了Parcelable接口。
* 使用文件共享。
* 使用Messenger。其本质为AIDL
* 使用AIDL
* 使用ContentProvider 其本质为Binder
* 使用Socket。

## Binder连接池
