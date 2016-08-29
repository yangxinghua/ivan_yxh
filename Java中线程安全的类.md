# Java中线程安全的类

* CopyOnWriteArrayList
* CopyOnWriteArraySet
写入时会复制底层数组，源数组保持不变，只修改复制数组，在修改完成之后再将修改的数组替换源数组。读取时，
只会读取源数组。

* ConcurrentLinkedQueue
* ConcurrentHashMap
