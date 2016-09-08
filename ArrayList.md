---
title: ArrayList
date: 2016-9-8
tag: Java
---

# ArrayList
继承AbstractList. 实现了Cloneable, Serializable, RandomAccess三个接口.使得ArrayList可以被克隆,序列化以及实现快速查找. 底层实现是数组.

### 构造函数
* public ArrayList() 底层数组为空.
* public ArrayList(int capacity) 指定底层数字长度.
* public ArrayList(Collection<? extends E> collection) 将传进来的集合转化为数组,并将这个数组赋值给底层数组.

### 扩容
```
private static int newCapacity(int currentCapacity) {
    int increment = (currentCapacity < (MIN_CAPACITY_INCREMENT / 2) ?
            MIN_CAPACITY_INCREMENT : currentCapacity >> 1);
    return currentCapacity + increment;
}
```
MIN_CAPACITY_INCREMENT为12. 当前容量小于MIN_CAPACITY_INCREMENT的一半,直接增加MIN_CAPACITY_INCREMENT.否则容量增加当前容量的一半.
