# LruCache
内部用LinkedHashMap实现. LinkedHashMap每添加一个KV,都将它插入到头部.同样的,在通过KEY查找到了一个VALUE,也会将这个KV提到头部.这样就保证了最少使用的KV在尾部.当超过设置的缓存容量时,将最后的KV删除.
