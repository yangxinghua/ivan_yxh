---
title: AsyncTask
date: 2016-8-24
tag: Android
---
# AsyncTask

## 使用
```
   private TextView mTextView;

   @Override
   protected void onCreate(Bundle savedInstanceState) {
       super.onCreate(savedInstanceState);
       setContentView(R.layout.activity_main);
       mTextView = (TextView) findViewById(R.id.text_view);
       new MyAsyncTask().execute("http://www.baidu.com");

   }


   class MyAsyncTask extends AsyncTask<String, Void, String> {

       @Override
       protected String doInBackground(String... params) {
           try {
               URL url = new URL(params[0]);
               HttpURLConnection connection = (HttpURLConnection) url.openConnection();
               connection.setDoInput(true);
               InputStream is = connection.getInputStream();
               InputStreamReader reader = new InputStreamReader(is);
               BufferedReader bufferedReader = new BufferedReader(reader);
               String s;
               StringBuffer sb = new StringBuffer();
               while ((s = bufferedReader.readLine()) != null) {
                   sb.append(s);
               }
               return sb.toString();

           } catch (MalformedURLException e) {
               e.printStackTrace();
           } catch (IOException e) {
               e.printStackTrace();
           }

           return null;

       }

       @Override
       protected void onPostExecute(String s) {
           mTextView.setText(s);
       }
   }
```

* doInBackground。运行在线程中，我们可以做耗时操作，比如上面的网络请求。
* onPostExecute. 运行在主线程。当这个方法被调用时，就表明doInBackground方法执行完了，调用了这个方法，并传入结果。整个Task就完成了。

execute方法就只有一句，调用了executeOnExecutor方法。所以直接来看executeOnExecutor：
```
public final AsyncTask<Params, Progress, Result> executeOnExecutor(Executor exec, Params... params) {
        if (mStatus != Status.PENDING) {
            switch (mStatus) {
                case RUNNING:
                    throw new IllegalStateException("Cannot execute task:"
                            + " the task is already running.");
                case FINISHED:
                    throw new IllegalStateException("Cannot execute task:"
                            + " the task has already been executed "
                            + "(a task can be executed only once)");
            }
        }

        mStatus = Status.RUNNING;

        onPreExecute();

        mWorker.mParams = params;
        exec.execute(mFuture);

        return this;
    }
```
首先判断当前的状态，如果是已经开始或者已经结束，抛出异常。
接着将当前的状态设置为正在执行。调用onPreExecute，所以我们可以复写这个方法来在任务开始之前做一些初始化。最后，线程池就开始执行mFuture这个任务。mFuture是在AsyncTask的构造方法中初始化的。
```
/**
 * Creates a new asynchronous task. This constructor must be invoked on the UI thread.
 */
public AsyncTask() {
    mWorker = new WorkerRunnable<Params, Result>() {
        public Result call() throws Exception {
            mTaskInvoked.set(true);

            Process.setThreadPriority(Process.THREAD_PRIORITY_BACKGROUND);
            //noinspection unchecked
            Result result = doInBackground(mParams);
            Binder.flushPendingCommands();
            return postResult(result);
        }
    };

    mFuture = new FutureTask<Result>(mWorker) {
        @Override
        protected void done() {
            try {
                postResultIfNotInvoked(get());
            } catch (InterruptedException e) {
                android.util.Log.w(LOG_TAG, e);
            } catch (ExecutionException e) {
                throw new RuntimeException("An error occurred while executing doInBackground()",
                        e.getCause());
            } catch (CancellationException e) {
                postResultIfNotInvoked(null);
            }
        }
    };
}
```
上面我们可以看到，mFuture是通过mWorker来构造的。而mWorker是一个Callable。那么执行的就是mWorker的call方法。上面的call方法中，我们可以看到doInBackground方法被调用了。当结果返回后，调用了postResult方法将结果投入到主线程中。
```
private Result postResult(Result result) {
       @SuppressWarnings("unchecked")
       Message message = getHandler().obtainMessage(MESSAGE_POST_RESULT,
               new AsyncTaskResult<Result>(this, result));
       message.sendToTarget();
       return result;
   }
```
这里就是Handler的知识了。
```
public void handleMessage(Message msg) {
      AsyncTaskResult<?> result = (AsyncTaskResult<?>) msg.obj;
      switch (msg.what) {
          case MESSAGE_POST_RESULT:
              // There is only one result
              result.mTask.finish(result.mData[0]);
              break;


          //省略代码
          ....
      }
```
上面的mTask就是当前的AsyncTask对象。所以，猜测，finish方法中肯定会调用onPostExecute。
```
private void finish(Result result) {
     if (isCancelled()) {
         onCancelled(result);
     } else {
         onPostExecute(result);
     }
     mStatus = Status.FINISHED;
 }

```

到这里，整个任务就完成了。

注意：内部类默认会持有外部类， 使用AsyncTask，小心内存泄漏。一个例子：我们在Activity中定义了一个继承至AsyncTask的MyAsyncTask来执行耗时操作的任务，比如从网络上下载数据。当任务还没有执行完，Activity被销毁了，因为MyAsyncTask持有了Activity，使得Activity不能被释放，从而引起内存泄漏。
