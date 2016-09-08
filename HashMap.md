---
title: HashMap
date: 2016-9-8
tag: Java
---

# HashMap
继承AbstractMap, 实现了Cloneable,Serializable接口, 所以是可以被克隆以及序列化的.
K,V都允许为null.

### 使用
一般而言使用是这样的
```
Map<K, V> map = new HashMap();
map.put(k, v);

```

### 构造方法
* public HashMap() 无参构造方法,初始数组长度为2.
* public HashMap(int capacity)  指定数组长度,如果不是2的n次方,增大到离该数最近的一个2的n次方的数.
* public HashMap(int capacity, float loadFactor) 与上一个一样,并且在HashMap忽略了这个负载因子,与上一个构造方法无异.

这里只看无参的构造方法.
```
public HashMap() {
    table = (HashMapEntry<K, V>[]) EMPTY_TABLE;
    threshold = -1; // Forces first put invocation to replace EMPTY_TABLE
}
```
EMPTY_TABLE是一个长度为2的空数组,同时,将threshold赋值为-1,这个threshold后面会讲到.

### put
```
public V put(K key, V value) {
    if (key == null) {
        return putValueForNullKey(value);
    }

    int hash = Collections.secondaryHash(key);
    HashMapEntry<K, V>[] tab = table;
    int index = hash & (tab.length - 1);
    for (HashMapEntry<K, V> e = tab[index]; e != null; e = e.next) {
        if (e.hash == hash && key.equals(e.key)) {
            preModify(e);
            V oldValue = e.value;
            e.value = value;
            return oldValue;
        }
    }

    // No entry for (non-null) key is present; create one
    modCount++;
    if (size++ > threshold) {
        tab = doubleCapacity();
        index = hash & (tab.length - 1);
    }
    addNewEntry(key, value, hash, index);
    return null;
}
```
当KEY为null的时候,处理比较简单.不去看了.下来是对获取key的hash值,至于为什么是调用secondaryHash方法来求hash值,其目的在于下面这一句 `int index = hash & (tab.length - 1);` 这个hash跟数组的长度减1(数组长度为2n -1)进行与运算时,能尽可能的产生不同的index, 并且这个index是小于数组长度的.这样就能最大程度的使元素能排布数组当中,在查找时,较少的在链表中查找.接着在数组与链表中查找是否有hash以及key相同的元素.有则替换value值.没有则把元素添加到数组的index位置.链表是怎么回事?继续看addNewEntry(key, value, hash, index)方法
```
void addNewEntry(K key, V value, int hash, int index) {
        table[index] = new HashMapEntry<K, V>(key, value, hash, table[index]);
    }
```
将要插入的元素放到数组的index位置,然后当前元素指向上一个插入index位置的元素.链表,就是这样来的.最先插入这个位置的元素在链表尾部,最后插入的在链表头部.

### 扩容
```
if (size++ > threshold) {
    tab = doubleCapacity();
    index = hash & (tab.length - 1);
}
```
当HashMap的size加上要添加的元素之后大于threshold,进行扩容.那这个threshold是什么?看makeTable方法就知道了.
```
private HashMapEntry<K, V>[] makeTable(int newCapacity) {
    @SuppressWarnings("unchecked") HashMapEntry<K, V>[] newTable
            = (HashMapEntry<K, V>[]) new HashMapEntry[newCapacity];
    table = newTable;
    threshold = (newCapacity >> 1) + (newCapacity >> 2); // 3/4 capacity
    return newTable;
}
```
原来是数组的长度的3/4,也就是说,当要在添加一个元素之后存储的元素达到了数组的3/4,则进行扩容到原来数组的两倍.

### get
```
public V get(Object key) {
    if (key == null) {
        HashMapEntry<K, V> e = entryForNullKey;
        return e == null ? null : e.value;
    }

    int hash = Collections.secondaryHash(key);
    HashMapEntry<K, V>[] tab = table;
    for (HashMapEntry<K, V> e = tab[hash & (tab.length - 1)];
            e != null; e = e.next) {
        K eKey = e.key;
        if (eKey == key || (e.hash == hash && key.equals(eKey))) {
            return e.value;
        }
    }
    return null;
}
```
get方法就比较简单了.计算出根据hash计算出index,在数组的index位置遍历链表.
