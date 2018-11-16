# 把此代码加入到.bashrc
# 作用：能够通过进程名显示log
# 用法：alogcat com.android.calendar or alogcat calendar
# 当监控的进程异常退出时，需要重新运行此命令
function alogcat() {
    OUT=$(adb shell ps | grep -i $1 | awk '{print $2}')
    OUT=$(echo $OUT | sed 's/[[:blank:]]\+/\|/g')
    # 当进程异常退出，log是通过 AndroidRuntime 输出的
    adb logcat -v time  |grep -E "$OUT|AndroidRuntime"
}
