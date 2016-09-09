---
title: LinkedList
date: 2016-9-8
tag: Java
---
# LinkedList
继承了AbstractSequentialList, 实现了List, Deque, Queue, Cloneable, Serializable.
Cloneable以及Serializable就不说了.其实在AbstractSequentialList已经实现了List接口了.不知为何这里要再实现一次.实现Queue,LinkedList就有成为FIFO队列的能力.实现Deque,则可以在双端操作元素.

### 构造函数
* public LinkedList() 构造一个只有头的双向链表.
* public LinkedList(Collection<? extends E> collection) 调用上面的构造方法.将集合元素转换为数组,然后再将数组转化为双向链表.


### add
最终会调用到下面的方法:
```
private boolean addLastImpl(E object) {
    Link<E> oldLast = voidLink.previous;
    Link<E> newLink = new Link<E>(object, oldLast, voidLink);
    voidLink.previous = newLink;
    oldLast.next = newLink;
    size++;
    modCount++;
    return true;
}
```
添加到尾部.

### get(int location)
```
@Override
public E get(int location) {
    if (location >= 0 && location < size) {
        Link<E> link = voidLink;
        if (location < (size / 2)) {
            for (int i = 0; i <= location; i++) {
                link = link.next;
            }
        } else {
            for (int i = size; i > location; i--) {
                link = link.previous;
            }
        }
        return link.data;
    }
    throw new IndexOutOfBoundsException();
}
```
如果location在小于size的一般,从头部开始查找.否则从尾部开始查找.
