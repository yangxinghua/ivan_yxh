# Java基础

## 存储
1. 寄存器: 无法控制
2. 栈:存储对象的引用以及基本类型。
3. 堆:对象。
4. 常量区:常量。

## finalize()方法
当垃圾回收器准备好释放对象占用的空间时，首先会调用finalize()方法。然而我们不能保证对象一定会被回收。这样的话， finalize方法有可能不会被调用。finalize方法是用来释放在JNI中调用的C或者C++中所申请的内存。

## 垃圾回收器如何工作
1. 引用计数。当有引用连接至对象时，引用计数+1,如果引用计数为0,则回收该对象。
2. 停止-复制。先暂停程序的运行，将所有存活的对象从当前堆复制到另一个堆。没有被复制的全部都是垃圾。
3. 标记-清扫。遍历所有引用，进而找出所有存活的对象，每当找到一个存活对象，就会给对象设一个标记。没有标记的对象就会被回收。

## 容器
+ Collection
  + List --> 以特定的顺序保存一组元素
    - ArrayList:插入和移除慢。随机访问快。基于数组实现。
    - LinkedList:插入与移除快，随机访问慢。基于双向链表实现。
    - CopyOnWriteArrayList:专门用于并发编程。线程安全。

  + Set --> 元素不能重复
    - HashSet 使用散列。顺序不能保证。
    - TreeSet 元素存储在红黑树中，有顺序。
    - LinkedHashSet 使用散列，但是用链表维护了插入顺序。所以是有序的。同时也实现了Queue接口。
    - CopyOnWriteArraySet 用于并发编程。线程安全。

  + Queue --> FIFO.只允许在容器的一端插入对象，并从另一端移除对象
    - PriorityQueue 根据某种规则将元素进行排序。
    - LinkedList

  + Deque --> 双向队列。可以在任意一端添加或删除元素。


+ Map 键值对.
  - HashMap:无序。查找时同时要匹配key以及key的hashcode.
  - TreeMap:有序
  - LinkedHashMap:同时具有散列数据结构以及链表。插入比HashMap慢，但是迭代速度快。
  - ConcurrentHashMap:用于多线程。线程安全。
  - WeakHashMap
  - IdentityHashMap

## 迭代器

+ Iterator
  - ListIterator --> 用于各种List的访问，可双向移动。


## 泛型


## 并发
* Runnable

* Thread

* Executor

ExecutorService exec = Executors.newCachedThreadPool();
ExecutorService exec = Executors.newFixedThreadPool(5);
ExecutorService exec = Executors.newSingleThreadPool();

* Callable

使用ExecutorService的sumbit来将Callable加入到线程池中，会返回一个Future对象。可以调用Future的isDone来查询任务是否完成。也可以用get，但是该方法是阻塞的。

* 优先级

通过setPriority来设置线程的优先级，MAX_PRIORITY,NOM_PRIORITY, MINPROIRITY.

* 让步

yield方法。让出CPU给其他线程，不保证会被采纳。

* 后台线程

在xianch启动之前调用setDaemon将该线程设置为后台线程。

* jion

A线程在B线程中调用jion方法，B被挂起，直到A完成。

* Wait()与notifyAll()

属于Object而非Thread的方法。
调用wait方法，线程被挂起，锁被释放。直到其他线程调用notifyAll或者notify
