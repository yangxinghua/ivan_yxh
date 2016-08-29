# App性能检测与提升

## UI
系统每16ms发出VSYNC信号,触发对UI渲染,保证60fps.也就是说程序的操作要在16ms完成,才能保证UI流畅.
一下问题有可能会导致程序操作无法在16ms完成.

* OverDraw(过度绘制). 指同一个像素点被绘制了超过一次.应该避免.可通过开发者选项的
  Show GPU OverDraw来查看过度绘制情况.
* layout层级过深. 可以通过HierarchyViewer来查看layout层级.尽量保持UI层级的扁平,避免层级过深.
