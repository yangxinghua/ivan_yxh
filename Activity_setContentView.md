---
title: setContentView
date: 2016-10-23
tag: Android
---

## Activity.setContentView(int layoutResID)
最终会通过调用到PhoneWindow的setContentView(int layoutResID)


## Window.setContentView(int layoutResID)
generateDecor(). 实例化DecorView, 该类继承FrameLayout.

generateLayout(DecorView). 这里主要是这两句
```
View in = mLayoutInflater.inflate(layoutResource, null);
decor.addView(in, new ViewGroup.LayoutParams(MATCH_PARENT, MATCH_PARENT));

```
通过LayoutInflater获取到布局后,添加到decor中.那这个布局是什么?是根据不同的feature来选择不同的预置的布局.
所以我们如果要调用 ``` getWindow().requestFeature(int feature); ```要在setContentView之前才会有效果.
接着就通过ViewGroup contentParent = (ViewGroup)findViewById(ID_ANDROID_CONTENT);找到id为
android:id/content的ViewGroup, 这个ViewGroup是一个FrameLayout.然后就返回了这个ViewGroup.


然后回到setContentView方法中, ``` mLayoutInflater.inflate(layoutResID, mContentParent); ```
通过这里,我们的布局就添加到id为android:id/content的FrameLayout中了.
