//: [Struct](Struct) |
//: Class |
//: [对比](Comparison) 

import UIKit
/*:
 Class 类 🇨🇳 
 ==========
 
 1.类的实例只能通过引用来间接地访问, 它能有很多个持有者
 
 2.使用类，我们可以通过继承来共享代码
 
 3.NSString,NSArray和NSDictionary类型均以类的形式实现，而并非结构体
 
 */
/*:
 实例 💃
 ---------
 
 ```
 class SomeClass {
 // code
 }
 ```
 */
class Goods {
    let name: String
    var price: UInt
    
    init(name: String, price: UInt) {
        self.name = name
        self.price = price
    }
}

let phone = Goods(name: "iphone", price: 6000)
phone.name
// 不可变对象的属性可变
phone.price += 100
phone.price

//: 更多属性添加

class iPhone {
    var price: UInt?
    // 静态变量
    static var productor = "鸿海集团"
    // 计算属性
    var secondHandPrice: UInt {
        set{
            self.price = newValue*2
        }
        get{
            return (self.price ?? 0)/2
        }
    }
    
    func getBroken() {
        guard let price = price else {
            return
        }
        self.price = price/10
    }
}
// 即使let修饰，对象属性也可以修改（不同于struct）
let danielsiPhone = iPhone()
danielsiPhone.price
danielsiPhone.price = 6000

let Inc = iPhone.productor

let dannyiPhone = danielsiPhone
dannyiPhone.getBroken()
dannyiPhone.price
danielsiPhone.price

/*:
 恒等运算符
 --------
 - 等价于(===)
 > 表示两个类类型(class type)的常量或者变量引用同一个类实例
 - 不等价于( !== )
 > 表示两个实例的值“相等”或“相同”，判定时要遵照设计者定义的评判标准，因此相对于“相 等”来说，这是一种更加合适的叫法。
 
 */

if dannyiPhone === danielsiPhone {
    print("同一个对象引用")
}

/*:
 内存管理 👻
 =========
 - weak 引用
 - unowned 引用
 - 循环引用
 - 捕获列表
 */

// 为什么struct可以而class不能这样
struct Human {
    let name: String
    var children: [Human]
}
var john = Human(name: "John", children: [])
john.children = [john]



//: 引用循环

class View1 {
    var window: Window1
    init(window: Window1) {
        self.window = window
    }
    deinit {
        print("view1释放")
    }
}
class Window1 {
    var rootView: View1?
    deinit {
        print("Window1释放")
    }
}

var window1: Window1? = Window1()
var view1: View1? = View1(window: window1!)
window1?.rootView = view1
view1 = nil
window1 = nil

//: weak

class View2 {
    var window: Window2
    init(window: Window2) {
        self.window = window
    }
    deinit {
        print("View2释放")
    }
}
class Window2 {
    weak var rootView: View2?
    deinit {
        print("Window2释放")
    }
}

var window2: Window2? = Window2()
var view2: View2? = View2(window: window2!)
window2?.rootView = view2
view2 = nil
window2 = nil

//: unowned
//: > 因为 weak 引用的变量可以变为 nil，所以它们必须是可选值类型，但是有些时候这并不是你想要的.

class View3 {
    unowned var window: Window3
    init(window: Window3) {
        self.window = window
    }
    deinit {
        print("View3释放")
    }
}
class Window3 {
    var rootView: View3?
    deinit {
        print("Window3释放")
    }
}
// 保证 window 的生命周期比 view 长
// 每个 unowned 的引用，Swift 运行时将为这个对象维护另外一个引用计数。当所有的 strong 引用消失时，对象将把它的资源 (比如对其他对象的引用) 释放掉。不过，这个对象本身的内存将继续存在，直到所有的 unowned 引用也都消失
var window3: Window3? = Window3()
var view3: View3? = View3(window: window3!)
window3?.rootView = view3
view3 = nil
window3 = nil


//: 捕获列表

class View {
    var window: Window
    init(window: Window) {
        self.window = window
    }
    deinit {
        print("Deinit View")
    }
}
class Window {
    weak var rootView: View?
    deinit {
        print("Deinit Window")
    }
    var onRotate: (() -> ())?
}

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view!

// ❌
window?.onRotate = {
    print("We now also need to update the view: \(String(describing: view))")
}
// ✅
window?.onRotate = { [weak view, weak myWindow=window] in
    print("We now also need to update the view: \(String(describing: view))")
    print("Because the window \(String(describing: myWindow)) changed")
}

//: [上一页](@previous) |
//: [下一页](@next)

