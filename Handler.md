---
title: Handler
date: 2016-8-24
tag: Android
---

# Handler
在Android中，只能在UI线程中更新UI这是常识。但是我们又需要用到多线程来执行耗时操作，比如说从网络上下载图片，然后通过ImageView来显示。Handler就是用来做协调这个矛盾的。它还有两个帮手，Looper, MessageQueue。

但是在说上面的东西之前，我们需要先来了解一下ThreadLocal.通常情况下，我们创建的变量是可以被任何一个线程访问并修改的。而使用ThreadLocal创建的变量只能被当前线程访问，其他线程则无法访问和修改。


下面是Handler的一般使用方法
```
private void send() {
    new Thread(new Runnable() {
        @Override
        public void run() {
            String text = "sendMessage";
            Message msg = Message.obtain();
            msg.obj = text;
            msg.what = SEND;
            mHandler.sendMessage(msg);
        }
    }).start();
}

private Handler mHandler = new Handler() {
    @Override
    public void handleMessage(Message msg) {
        Log.d(TAG, "handleMessage >>>>>> " + Thread.currentThread().getId());
        mTextView.setText((String)msg.obj);
    }
}

```
上面的方法只是为了分析Handler使用，并无实际意义。并且，这样的写法有可能会导致内存泄漏，我只是贪图方便，实际使用时，不能这样去使用Handler。废话完毕。

## Handler的构造方法
上面调用了Handler的无参构造方法，最终会调用下面这个构造方法中
```
public Handler(Callback callback, boolean async) {
    if (FIND_POTENTIAL_LEAKS) {
        final Class<? extends Handler> klass = getClass();
        if ((klass.isAnonymousClass() || klass.isMemberClass() || klass.isLocalClass()) &&
                (klass.getModifiers() & Modifier.STATIC) == 0) {
            Log.w(TAG, "The following Handler class should be static or leaks might occur: " +
                klass.getCanonicalName());
        }
    }

    mLooper = Looper.myLooper();
    if (mLooper == null) {
        throw new RuntimeException(
            "Can't create handler inside thread that has not called Looper.prepare()");
    }
    mQueue = mLooper.mQueue;
    mCallback = callback;
    mAsynchronous = async;
}
```
留意一下，上面的Handler是在主线程中定义的。那么获取的就是主线程的Looper，如果没有找到，就抛出异常。取出Looper中的MessageQueue。MessageQueue是一个FIFO的消息队列。
都知道主线程的Looper是系统帮我们定义好的。具体的定义是在ActivityThread的main方法中。当我们启动一个Activity都需要一个ActivityThread.下面是ActivityThread的main方法
```
public static void main(String[] args) {
        ......

        Looper.prepareMainLooper();

        ......

    }
```
Looper的prepare方法最终调用的方法
```
private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException("Only one Looper may be created per thread");
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }
```
如果在ThreadLocal中找到了Looper，会抛出RuntimeException，这样就保证了一个线程就只有一个Looper。这也是我们只能调用一次prepare方法的原因。上面ThreadLocal的set方法首先获取当前线程，然后以当前线程为句柄保存了Looper。

loop方法很简单，进入死循环， 获取到自己的Looper， 不断的从Looper的MessageQueueu中把Message取出来.然后交给msg.target处理，这个target,就是sendMessage的Handler,在Handler的enqueueMessage方法中赋值的。  
```
/**
 * Run the message queue in this thread. Be sure to call
 * {@link #quit()} to end the loop.
 */
public static void loop() {
    final Looper me = myLooper();
    ......
    final MessageQueue queue = me.mQueue;

    for (;;) {
        Message msg = queue.next(); // might block
        ......
        msg.target.dispatchMessage(msg);
        ......
    }
}
```
到这里，
