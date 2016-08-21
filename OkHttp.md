# OKHttp3

## 使用
```
private void download(String url) {
    OkHttpClient client = new OkHttpClient();
    final Request request = new Request.Builder()
            .url(url)
            .build();
    Call call = client.newCall(request);
    call.enqueue(new Callback() {
        @Override
        public void onFailure(Call call, IOException e) {
            Log.d(TAG, e.getMessage());
        }

        @Override
        public void onResponse(Call call, Response response) throws IOException {
            Bitmap bitmap = BitmapFactory.decodeStream(response.body().byteStream());
            mImageView.setImageBitmap(bitmap);
        }
    });
}
```

OkHttpClient的构造方法里面调用了默认的建造者来对属性赋值.接着同样的使用建造者来构建了一个Request
看一下这个Request的Builder的构造方法.这里的默认连接方式是GET.
```
public Builder() {
    this.method = "GET";
    this.headers = new Headers.Builder();
}
```
下面看一下client的newCall方法
```
/**
   * Prepares the {@code request} to be executed at some point in the future.
   */
  @Override public Call newCall(Request request) {
    return new RealCall(this, request);
  }

```
没有做什么,就是创建了一个RealCall对象.

看下call的enqueue方法,这里添加了一个Callback回调.看下Call的enqueue方法是由其子
类RealCall实现的.下面是RealCall的enqueue方法
```
@Override public void enqueue(Callback responseCallback) {
    synchronized (this) {
      if (executed) throw new IllegalStateException("Already Executed");
      executed = true;
    }
    client.dispatcher().enqueue(new AsyncCall(responseCallback));
  }
```
这里通过再将RealCall封装成AsyncCall然后加入到线程池中.这里的AsyncCall是一个Runnable.方法实现如下:

```
synchronized void enqueue(AsyncCall call) {
    if (runningAsyncCalls.size() < maxRequests && runningCallsForHost(call) < maxRequestsPerHost) {
      runningAsyncCalls.add(call);
      executorService().execute(call);
    } else {
      readyAsyncCalls.add(call);
    }
}

```
首先判断正在进行的任务,如果没有到maxRequests(64),并且具有相同host的任务没有到
maxRequestsPerHost(5),则立即执行该任务,否则加入到等待的队列中.

那么执行具体任务就应该在AsyncCall的run方法中,AsyncCall的run方法是由其父类NamedRunnable
实现了,最后会调用那个到AsyncCall的excute方法
```
@Override protected void execute() {
      boolean signalledCallback = false;
      try {
        Response response = getResponseWithInterceptorChain();
        if (retryAndFollowUpInterceptor.isCanceled()) {
          signalledCallback = true;
          responseCallback.onFailure(RealCall.this, new IOException("Canceled"));
        } else {
          signalledCallback = true;
          responseCallback.onResponse(RealCall.this, response);
        }
      } catch (IOException e) {
        if (signalledCallback) {
          // Do not signal the callback twice!
          Platform.get().log(INFO, "Callback failure for " + toLoggableString(), e);
        } else {
          responseCallback.onFailure(RealCall.this, e);
        }
      } finally {
        client.dispatcher().finished(this);
      }
    }

```
通过```getResponseWithInterceptorChain();```得到了我们想要的Response.如果任务取消了,
调用Callbak的onFailure, 否则回调onResponse.最后告诉dispatcher自己执行完了.然后
dispatcher就会拉取下一个任务.

重头戏来了.接下来是整个OkHttp的精华部分.我们是怎么样获取到Response的?
```
private Response getResponseWithInterceptorChain() throws IOException {
   // Build a full stack of interceptors.
   List<Interceptor> interceptors = new ArrayList<>();
   interceptors.addAll(client.interceptors());
   interceptors.add(retryAndFollowUpInterceptor);
   interceptors.add(new BridgeInterceptor(client.cookieJar()));
   interceptors.add(new CacheInterceptor(client.internalCache()));
   interceptors.add(new ConnectInterceptor(client));
   if (!retryAndFollowUpInterceptor.isForWebSocket()) {
     interceptors.addAll(client.networkInterceptors());
   }
   interceptors.add(new CallServerInterceptor(
       retryAndFollowUpInterceptor.isForWebSocket()));

   Interceptor.Chain chain = new RealInterceptorChain(
       interceptors, null, null, null, 0, originalRequest);
   return chain.proceed(originalRequest);
 }
```
在上面的方法中，加入了一堆的拦截器，按照一下顺序来拦截:
1. RetryAndFollowUpInterceptor:创建连接池，路由表。如果Response code无法识别，进行重试。
1. Bridgeinterceptor:构建http请求头部。进入下一个拦截器。
2. CacheInterceptor:根据http请求消息查找缓存。如果没有，进入下一个拦截器。
3. ConnectInterceptor:建立链接，进入下一个拦截器。
4. CallServerInterceptor:构建http请求行以及http请求体，向服务器发送请求，并返回Response。
