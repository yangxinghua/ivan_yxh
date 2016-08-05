# Service弹出Dialog

## 获取权限
```
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

## 设置type
```
AlertDialog.Builder builder = new AlertDialog.Builder(this);
builder.setTitle("Dialog");
builder.setMessage("dialog show by service");

AlertDialog dialog = builder.create();
dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
dialog.show();
```
