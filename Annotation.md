# 注解
用来描述数据的数据，很拗口是吧。说人话就是：我是A（注解）， 我的作用是用来描述*的，额，换个说法：我的作用是用来描述一个数据的。比如
```
@Get(age = 20, name = "xiaoming")
Person person;


public class User {
    private String name;
    private int age;
}
```
好吧，小明叕躺枪。继续用人话来说就是：上述的Get注解描述了Persion类的age属性,name属性的值。然而(有这个词一般都没什么好事)，这需要一个解释器来解释。
