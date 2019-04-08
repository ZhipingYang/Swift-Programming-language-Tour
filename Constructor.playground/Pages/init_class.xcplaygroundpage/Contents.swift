//: [结构体构造](init_struct) |
//: 类构造

/*:
 类的构造 😪
 ==========
 类可以继承自其它类，这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化
 类里面的所有存储型属性——包括所有继承自父类的属性——都必须在构造过程中设置初始值。
 
 指定构造器:主要的
 --------------
 `指定构造器将初始化类中提供的所有属性，并根据父类链往上调用父类的构造器来实现父类的初始化。`
 
 便利构造器：辅助的
 ---------------
 `你可以定义便利构造器来调用同一个类中的指定构造器，并为其参数提供默认值。你也可以定义便利构造器来创建一个特殊用途或特定输入值的实例`
 
 #### 类的构造器代理规则3则：
 - 指定构造器必须调用其直接父类的的指定构造器
 - 便利构造器必须调用同类中定义的其它构造器
 - 便利构造器必须最终导致一个指定构造器被调用
 
 > 指定构造器必须总是向上代理,便利构造器必须总是横向代理
 
 ![image](initializerDelegation.png)
 */

import Foundation

// 除了可选值可以为nil外，其他储存属性变量必须初始化
class Human {
    var name = "name"
    init() {
    }
}

let hum = Human().name


class Human2 {
    var name: String
    init(name:String) {
        self.name = name
    }
    convenience init(){
        self.init(name: "Human2")
    }
}

let hum21 = Human2().name
let hum22 = Human2.init(name: "哈哈哈").name

class Chinese: Human2 {
    var address:String
    
    init(name:String, address:String) {
        self.address = address
        //放下面，只能是 super
        super.init(name: name)
    }
    convenience init(address: String) {
        // 只能是 self
        self.init(name:"nunamed", address:address)
        // 不能调用父类的指定构建方法或便利构建方法
//        super.init(name: "nunamed")
//        super.init()
    }
}


let YaoMing = Chinese(name: "姚明", address: "上海")
YaoMing.name

let someone = Chinese(address: "shanghai")
someone.name

// 子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器
// ❌ 错误
//let someone2 = Chinese()


//: 两段式构造过程
//: - 每个存储型属性被引入它们的类指定一个初始值
//: - 当每个存储型属性的初始值被确定后，它给每个类一次机会，在新实例准备使用之前进一步定制它们的存储型属性
//: > 两段式构造过程跟 Objective-C 中的构造过程类似。最主要的区别在于阶段 1，Objective-C 给每一个属性赋值0或空值（比如说0或nil）

/*:
 安全检查
 - 所在类所有属性先初始化
 - 自己先调用父类构造器，再为继承属性赋值（防止被覆盖）
 - 便利构造器先代理同类其他构造器，在赋值（防止被覆盖）
 - 构造器在第一阶段构造完成之前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用self作为一个值
 */


//: 可失败构造器（同理用于其他值类型）
class Human3 {
    var name: String?
    init?(name:String) {
        if !name.isEmpty { return nil }
        self.name = name
    }
}

//: 必要构造器
// required 修饰符表明所有该类的子类都必须实现该构造器
class SomeClass {
    var name: String = {
       return "unNmaed"
    }()
    required init(name:String) {
        self.name = name
    }
}

class SomeSubclass: SomeClass {
    
    // 必要的存在
    required init(name: String) {
        super.init(name: name)
    }
    
    init(name_name: String) {
        super.init(name: name_name)
    }
    
    convenience init(newName: String) {
        self.init(name: newName)
    }
}







//: [下一部分：类的继承](@next)
