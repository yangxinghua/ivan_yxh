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
获取Cache目录` File cacheDir = new File(context.getCacheDir(), DEFAULT_CACHE_DIR); `
这个目录的路径是/data/data/packagename/volley

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
首先从Cache中查找是否有这个entry，如果没有或者entry过期了，则把这个Request加入到网络下载队列中。
如果查找到了Cache，判断是否需要刷新,如果不需要,直接调用Request的数据解析方法解析数据，并通过调用Request的deliverResponse(), 将解析数据返回。如果需要刷新,先将Cache返回,然后将这个Request加入到下载队列中.


```
// Deliver a normal response or error, depending.
           if (mResponse.isSuccess()) {
               mRequest.deliverResponse(mResponse.result);
           } else {
               mRequest.deliverError(mResponse.error);
           }

```

Ok，上面是Cache已经存在的情况下，那如果要从网络下载数据呢？


上面的几个步骤:
1. 是否被取消,取消从头开始.
2. 是否有缓存,没有则直接加入下载队列.从头开始.
3. 缓存是否过期,是则加入下载队列,从头开始.
4. 缓存是否需要刷新,否直接交付,是则先交付,并加入请求队列.




在上面Cache不存在或者Cache过期的情况下，会把这个Request加入网络请求队列中.那网络请求是在哪里?
我们回来RequestQueue的start方法中
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
这里创建的4（private static final int DEFAULT_NETWORK_THREAD_POOL_SIZE = 4;）个NetworkDispatcher，该类继承Thread，看一下它的run()方法：
```
@Override
public void run() {
    Process.setThreadPriority(Process.THREAD_PRIORITY_BACKGROUND);
    while (true) {
        long startTimeMs = SystemClock.elapsedRealtime();
        Request<?> request;
        try {
            // Take a request from the queue.
            request = mQueue.take();
        } catch (InterruptedException e) {
            // We may have been interrupted because it was time to quit.
            if (mQuit) {
                return;
            }
            continue;
        }

        try {
            request.addMarker("network-queue-take");

            // If the request was cancelled already, do not perform the
            // network request.
            if (request.isCanceled()) {
                request.finish("network-discard-cancelled");
                continue;
            }

            addTrafficStatsTag(request);

            // Perform the network request.
            NetworkResponse networkResponse = mNetwork.performRequest(request);
            request.addMarker("network-http-complete");

            // If the server returned 304 AND we delivered a response already,
            // we're done -- don't deliver a second identical response.
            if (networkResponse.notModified && request.hasHadResponseDelivered()) {
                request.finish("not-modified");
                continue;
            }

            // Parse the response here on the worker thread.
            Response<?> response = request.parseNetworkResponse(networkResponse);
            request.addMarker("network-parse-complete");

            // Write to cache if applicable.
            // TODO: Only update cache metadata instead of entire record for 304s.
            if (request.shouldCache() && response.cacheEntry != null) {
                mCache.put(request.getCacheKey(), response.cacheEntry);
                request.addMarker("network-cache-written");
            }

            // Post the response back.
            request.markDelivered();
            mDelivery.postResponse(request, response);
        } catch (VolleyError volleyError) {
            volleyError.setNetworkTimeMs(SystemClock.elapsedRealtime() - startTimeMs);
            parseAndDeliverNetworkError(request, volleyError);
        } catch (Exception e) {
            VolleyLog.e(e, "Unhandled exception %s", e.toString());
            VolleyError volleyError = new VolleyError(e);
            volleyError.setNetworkTimeMs(SystemClock.elapsedRealtime() - startTimeMs);
            mDelivery.postError(request, volleyError);
        }
    }
}

```
先不要急着WTF，一句话就可以说明这一大坨东西做了什么：从网络下载数据,如果需要缓存则进行缓存,然后调用Request的解析方法然后告诉Request：我做完了。跟上面从cache获取数据是一样一样的。
其中`NetworkResponse networkResponse = mNetwork.performRequest(request);`
这一句就是从网络上下载数据:
```
@Override
   public NetworkResponse performRequest(Request<?> request) throws VolleyError {
       long requestStart = SystemClock.elapsedRealtime();
       //省略代码
       ......
       httpResponse = mHttpStack.performRequest(request, headers);
       //省略代码
       ......
       return new NetworkResponse(statusCode, responseContents, responseHeaders, false,SystemClock.elapsedRealtime() - requestStart);
      ......
   }
```
上面省略较多代码,核心只有这两句.就是下载数据,返回respons.然后看下HttpURLConnection的下载方式:
```
@Override
public HttpResponse performRequest(Request<?> request, Map<String, String> additionalHeaders)
        throws IOException, AuthFailureError {
    String url = request.getUrl();
    HashMap<String, String> map = new HashMap<String, String>();
    map.putAll(request.getHeaders());
    map.putAll(additionalHeaders);
    if (mUrlRewriter != null) {
        String rewritten = mUrlRewriter.rewriteUrl(url);
        if (rewritten == null) {
            throw new IOException("URL blocked by rewriter: " + url);
        }
        url = rewritten;
    }
    URL parsedUrl = new URL(url);
    HttpURLConnection connection = openConnection(parsedUrl, request);
    for (String headerName : map.keySet()) {
        connection.addRequestProperty(headerName, map.get(headerName));
    }
    setConnectionParametersForRequest(connection, request);
    // Initialize HttpResponse with data from the HttpURLConnection.
    ProtocolVersion protocolVersion = new ProtocolVersion("HTTP", 1, 1);
    int responseCode = connection.getResponseCode();
    if (responseCode == -1) {
        // -1 is returned by getResponseCode() if the response code could not be retrieved.
        // Signal to the caller that something was wrong with the connection.
        throw new IOException("Could not retrieve response code from HttpUrlConnection.");
    }
    StatusLine responseStatus = new BasicStatusLine(protocolVersion,
            connection.getResponseCode(), connection.getResponseMessage());
    BasicHttpResponse response = new BasicHttpResponse(responseStatus);
    if (hasResponseBody(request.getMethod(), responseStatus.getStatusCode())) {
        response.setEntity(entityFromConnection(connection));
    }
    for (Entry<String, List<String>> header : connection.getHeaderFields().entrySet()) {
        if (header.getKey() != null) {
            Header h = new BasicHeader(header.getKey(), header.getValue().get(0));
            response.addHeader(h);
        }
    }
    return response;
}

```
这里就是常规的使用HttpURLConnection使用了.
