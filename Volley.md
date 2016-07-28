# Volley

在调用时Volley.newRequestQueue(Context)， 做了几件事情，下面是源码

```
public static RequestQueue newRequestQueue(Context context, HttpStack stack) {
        File cacheDir = new File(context.getCacheDir(), DEFAULT_CACHE_DIR);

        String userAgent = "volley/0";
        try {
            String packageName = context.getPackageName();
            PackageInfo info = context.getPackageManager().getPackageInfo(packageName, 0);
            userAgent = packageName + "/" + info.versionCode;
        } catch (NameNotFoundException e) {
        }

        if (stack == null) {
            if (Build.VERSION.SDK_INT >= 9) {
                stack = new HurlStack();
            } else {
                // Prior to Gingerbread, HttpUrlConnection was unreliable.
                // See: http://android-developers.blogspot.com/2011/09/androids-http-clients.html
                stack = new HttpClientStack(AndroidHttpClient.newInstance(userAgent));
            }
        }

        Network network = new BasicNetwork(stack);

        RequestQueue queue = new RequestQueue(new DiskBasedCache(cacheDir), network);
        queue.start();

        return queue;
    }
```
获取Cache目录
``` File cacheDir = new File(context.getCacheDir(), DEFAULT_CACHE_DIR); ```

根据SDK版本来决定使用HttpUrlConnection还是HttpClient。接着就是真正的创建RequestQueue.
看一下RequestQueue的构造方法
```
public RequestQueue(Cache cache, Network network, int threadPoolSize,
            ResponseDelivery delivery) {
        mCache = cache;
        mNetwork = network;
        mDispatchers = new NetworkDispatcher[threadPoolSize];
        mDelivery = delivery;
    }

```
最终的使用这个构造方法，就是一些属性的赋值。然后来看一下ReuequestQueue的start()方法

```
    public void start() {
        stop();  // Make sure any currently running dispatchers are stopped.
        // Create the cache dispatcher and start it.
        mCacheDispatcher = new CacheDispatcher(mCacheQueue, mNetworkQueue, mCache, mDelivery);
        mCacheDispatcher.start();

        // Create network dispatchers (and corresponding threads) up to the pool size.
        for (int i = 0; i < mDispatchers.length; i++) {
            NetworkDispatcher networkDispatcher = new NetworkDispatcher(mNetworkQueue, mNetwork,
                    mCache, mDelivery);
            mDispatchers[i] = networkDispatcher;
            networkDispatcher.start();
        }
    }
```
首先，停止Cached的线程和Network的多个线程。接着创建一个新的CacheDispatcher， 这是一个Thread对象。看一下它的run()方法
```
@Override
 public void run() {
     if (DEBUG) VolleyLog.v("start new dispatcher");
     Process.setThreadPriority(Process.THREAD_PRIORITY_BACKGROUND);

     // Make a blocking call to initialize the cache.
     mCache.initialize();

     while (true) {
         try {
             // Get a request from the cache triage queue, blocking until
             // at least one is available.
             final Request<?> request = mCacheQueue.take();
             request.addMarker("cache-queue-take");

             // If the request has been canceled, don't bother dispatching it.
             if (request.isCanceled()) {
                 request.finish("cache-discard-canceled");
                 continue;
             }

             // Attempt to retrieve this item from cache.
             Cache.Entry entry = mCache.get(request.getCacheKey());
             if (entry == null) {
                 request.addMarker("cache-miss");
                 // Cache miss; send off to the network dispatcher.
                 mNetworkQueue.put(request);
                 continue;
             }

             // If it is completely expired, just send it to the network.
             if (entry.isExpired()) {
                 request.addMarker("cache-hit-expired");
                 request.setCacheEntry(entry);
                 mNetworkQueue.put(request);
                 continue;
             }

             // We have a cache hit; parse its data for delivery back to the request.
             request.addMarker("cache-hit");
             Response<?> response = request.parseNetworkResponse(
                     new NetworkResponse(entry.data, entry.responseHeaders));
             request.addMarker("cache-hit-parsed");

             if (!entry.refreshNeeded()) {
                 // Completely unexpired cache hit. Just deliver the response.
                 mDelivery.postResponse(request, response);
             } else {
                 // Soft-expired cache hit. We can deliver the cached response,
                 // but we need to also send the request to the network for
                 // refreshing.
                 request.addMarker("cache-hit-refresh-needed");
                 request.setCacheEntry(entry);

                 // Mark the response as intermediate.
                 response.intermediate = true;

                 // Post the intermediate response back to the user and have
                 // the delivery then forward the request along to the network.
                 mDelivery.postResponse(request, response, new Runnable() {
                     @Override
                     public void run() {
                         try {
                             mNetworkQueue.put(request);
                         } catch (InterruptedException e) {
                             // Not much we can do about this.
                         }
                     }
                 });
             }

         } catch (InterruptedException e) {
             // We may have been interrupted because it was time to quit.
             if (mQuit) {
                 return;
             }
             continue;
         }
     }
 }

```
这里有一个死循环，就是不断从队列中拉取Request，如果Request已经被取消，则继续拉取下一个Request。
首先从Cache中查找是否有这个entry，如果没有或者Cache过期了，则把这个Request加入到网络下载队列中。
如果查找到了Cache，直接调用Request的数据解析方法解析数据，并通过调用Request的deliverResponse()
将解析数据返回。

```
// Deliver a normal response or error, depending.
           if (mResponse.isSuccess()) {
               mRequest.deliverResponse(mResponse.result);
           } else {
               mRequest.deliverError(mResponse.error);
           }

```

Ok，上面是Cache已经存在的情况下，那如果要从网络下载数据呢？
在上面Cache不存在或者Cache过期的情况下，会把这个Request加入网络请求队列中。
``` mNetworkQueue.put(request); ```
我们回来RequestQueue的构造方法中
```
public RequestQueue(Cache cache, Network network, int threadPoolSize,
            ResponseDelivery delivery) {
        mCache = cache;
        mNetwork = network;
        mDispatchers = new NetworkDispatcher[threadPoolSize];
        mDelivery = delivery;
    }

```
