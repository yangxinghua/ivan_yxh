# Android APK 安装

## APK安装
调用以下代码安装我们app.apk
```
Intent install = new Intent(Intent.ACTION_VIEW);
install.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
File apkFile = new File(Environment.getExternalStorageDirectory() + "/download/" + "app.apk";
install.setDataAndType(Uri.fromFile(apkFile)), "application/vnd.android.package-archive");
startActivity(install)
```
上述代码，调起了系统的packageinstaller的PackageInstallerActivity。
在PackageInstallerActivity中，当用户点击ok之后，执行以下代码调起安装过程的界面
```
// Start subactivity to actually install the application
   newIntent.setClass(this, InstallAppProgress.class);
   startActivity(newIntent);
```
在InstallAppProgress中开始执行真正的安装代码
```
pm.installPackageWithVerificationAndEncryption(mPackageURI, observer, installFlags,installerPackageName, verificationParams, null);
```
上述代码，调用的是ApplicationPackageManager的以下方法
```
public void installPackageWithVerificationAndEncryption(Uri packageURI, IPackageInstallObserver observer, int flags, String installerPackageName, VerificationParams verificationParams, ContainerEncryptionParams encryptionParams) {
      installCommon(packageURI, new LegacyPackageInstallObserver(observer), flags,
              installerPackageName, verificationParams, encryptionParams);
    }

```

```
private void installCommon(Uri packageURI,
            PackageInstallObserver observer, int flags, String installerPackageName,
            VerificationParams verificationParams, ContainerEncryptionParams encryptionParams) {
        if (!"file".equals(packageURI.getScheme())) {
            throw new UnsupportedOperationException("Only file:// URIs are supported");
        }
        if (encryptionParams != null) {
            throw new UnsupportedOperationException("ContainerEncryptionParams not supported");
        }

        final String originPath = packageURI.getPath();
        try {
            mPM.installPackage(originPath, observer.getBinder(), flags, installerPackageName,
                    verificationParams, null);
        } catch (RemoteException ignored) {
        }
    }
```
最后，真正在安装是由PackageManagerService来执行的。

## PackageManagerService安装过程
1.　首先复制apk到
