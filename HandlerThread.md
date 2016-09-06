---
title: HandlerThread使用
date: 2016-9-6
tag: Android
---
```
public class MainActivity extends AppCompatActivity {
    private static final String PIC_URL = "http://img5.imgtn.bdimg.com/it/u=3586233367,3171193232&fm=11&gp=0.jpg";

    private Handler mThreadHandler;

    private ImageView mImageView;

    private Button mBtnDownload;


    final Handler mHandler = new Handler() {
        //运行在主线程
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            Bitmap bitmap = (Bitmap)msg.obj;
            if(bitmap != null) {
              mImageView.setImageBitmap(bitmap);
            }


        }
    };


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mImageView = (ImageView) findViewById(R.id.image);
        mBtnDownload = (Button) findViewById(R.id.btn_download);
        mBtnDownload.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mThreadHandler.sendEmptyMessage(0);
            }
        });

        HandlerThread thread = new HandlerThread("demo");
        thread.start();

        mThreadHandler = new Handler(thread.getLooper()) {

            //运行在HandlerThread构建出来的线程中.
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                Bitmap bitmap = donwloadBitmap();
                if (bitmap != null) {
                    Message uiMsg = Message.obtain();
                    msg.what = 1;
                    uiMsg.obj = bitmap;
                    mHandler.sendMessage(uiMsg);
                }
            }
        };
    }

    private Bitmap donwloadBitmap() {
        try {
            URL url = new URL(PIC_URL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.connect();
            InputStream is = connection.getInputStream();
            Bitmap bitmap = BitmapFactory.decodeStream(is);
            return bitmap;

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }
```
因为threadHandler是使用HandlerThread的Looper来构造的,该Looper的loop方法是运行在HandlerThread创建的线程中.从消息队列中取出消息是运行在该线程中,自然的,threadHandler的handleMessage方法也是运行在该线程中.

而mHandler是在主线程中创建的,由于是一个无参的构造方法,默认获取的是当前线程的Looper.所以mHandler的handleMessage是运行在主线程中.

顺便说一下,IntentService内部实现也是HandlerThread.
