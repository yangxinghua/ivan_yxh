---
title: Android混淆
date: 2016-9-11
tag: Android
---
摘自《App研发录》:
ProGuard一共包括以下4个功能:
* 压缩(Shrink)：侦测并移除代码中无用的类，字段，方法和特性。
* 优化(Optimize):对字节码进行优化，移除无用指令。
* 混淆(Obfuscate):使用a,b,c,d这样简短而无意义的名称，对类，字段，和方法进行重命名。
* 预检测(Preverify):在Java平台上对处理后的代码进行预检。
