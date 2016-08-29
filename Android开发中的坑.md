# Android开发中的坑

* Support包中的资源找不到

```
Caused by: android.content.res.Resources$NotFoundException: File res/drawable/abc_btn_radio_material.xml from drawable resource ID #0x7f020008
at android.content.res.Resources.loadDrawable(Resources.java:2285)
at android.content.res.TypedArray.getDrawable(TypedArray.java:624)
at android.widget.CompoundButton.<init>(CompoundButton.java:74)
at android.widget.RadioButton.<init>(RadioButton.java:63)
at android.support.v7.widget.AppCompatRadioButton.<init>(Unknown Source)
at android.support.v7.widget.AppCompatRadioButton.<init>(Unknown Source)
at android.support.v7.app.bd.a(Unknown Source)
at android.support.v7.app.AppCompatDelegateImplV7.c(Unknown Source)
at android.support.v7.app.AppCompatDelegateImplV7.a(Unknown Source)
at android.support.v4.view.ak.onCreateView(Unknown Source)
at android.view.LayoutInflater.createViewFromTag(LayoutInflater.java:684)

```
项目中使用了包是23.2.0.Google了一番之后,发现很多人都遇到这个问题,只要升级一下,用23.2.1就没
问题了.
