//: 结构体构造 |
//: [类构造](init_class)
/*:
 结构体构造 😬
 ===========
 >- 构造过程是使用类、结构体或枚举类型的实例之前的准备过程
 >- 与 Objective-C 中的构造器不同，Swift 的构造器无需返回值
 >- 类和结构体在创建实例时，必须为所有存储型属性设置合适的初始值
 >- 当你为存储型属性设置默认值或者在构造器中为其赋值时，它们的值是被直接设置的，不会触发任何属性观察者(见：Human2)
 
 */

import Foundation

/*:
 存储属性初始赋值
 -------------
 1. 默认赋值
 2. 构造赋值
 3. 默认构造器
 4. 对外名称 的构造方法
 5. 匿名构造
 */

// 默认赋值
struct Human1 {
    var age = 11
}

let age1 = Human1().age

// 构造赋值
struct Human2 {
    var age: Int {
        didSet {
            print("Human2 观察者启动")
        }
    }
}

// 结构体默认构造器（遍历里面的变量一一构造赋值）
var human2 = Human2(age: 22)
human2.age = 33
human2.age

struct Human3 {
    var age: Int
    init() {
        age = 33
    }
}
let age3 = Human3().age

//: > 如果你为某个值类型定义了一个自定义的构造器，你将无法访问到默认构造器
// 自定义一些 对外名称 的构造方法

struct Human4 {
    var age: Int
    init(child age:Int) {
        self.age = age<12 ? age : 12
    }
    init(old age:Int) {
        self.age = age>50 ? age : 50
    }
    //匿名
    init(_ age: Int) {
        self.age = age
    }
}
let age41 = Human4(old: 40).age
let age42 = Human4(child: 40).age
let age43 = Human4(40).age


/*:
 构造器代理
 --------
 构造器可以通过调用其它构造器来完成实例的部分构造过程。这一过程称为构造器代理
 
 > 构造器代理的实现规则和形式在值类型和类类型中有所不同。值类型（结构体和枚举类型）不支持继承，所以构造器代理的过程相对简单，因为它们只能代理给自己的其它构造器。类则不同，它可以继承自其它类（请参考[继承](inherit)），这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化.
 
 `构造也可以放在拓展Extension中，后续讲到`
 */
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
    init(_ x:Double=0, _ y:Double=0, _ w:Double=0, _ h:Double=0) {
        self.origin = Point(x: x, y: y)
        self.size = Size(width: w, height: h)
    }
}

let zeroRect = Rect()
let originRect = Rect(origin: Point(x: 10, y: 20), size: Size(width: 30, height: 40))
let lovelyRect = Rect(1, 2, 3, 4)


//: 可失败构造器（同理用于其他值类型、Class中）

struct Human5 {
    let age: Int
    init?(age: Int) {
        if age<=0 { return nil }
        self.age = age
    }
}

let mySon = Human5(age: -2)


//: [类构造](init_class) | 
//: [类的继承](inherit)
