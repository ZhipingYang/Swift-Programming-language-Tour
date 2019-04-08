//: [结构体构造](init_struct) |
//: [类构造](init_class)


/*:
 类的继承 👨‍💻
 ===========
 值类型（结构体、枚举）是不支持继承的
 */

import UIKit


//: 定义一个基类

class Human {
    let habit = "play"
    // 存储属性
    var age = 0
    // 计算属性
    var description: String {
        return "这个人年龄是\(age)"
    }
    func work() {
        print("人类需要工作")
    }
    class func playGame() {
        print("玩羽毛球")
    }
}

let xiaoMing = Human()
xiaoMing.work()
Human.playGame()

//:子类生成

class Chinese: Human {
    var country = "中国"
}

let superStar = Chinese()
superStar.country = "美国"
superStar.age = 25


/*:
 重写
 > 子类重写某个特性，你需要在重写定义的前面加上override关键字，任何缺少override关键字的重写都会在编译时被诊断为错误，这个关键字会提醒 Swift 编译器去检查该类的超类；
 > 相比于OC就是一个很大的优点，可以非常直观。
 在属性someProperty的 getter 或 setter 的重写实现中，可以通过super.someProperty来访问超类版本的someProperty属性。
 */

class Japanese: Human {
    // 重写计算属性
    override var description: String {
        return "这个日本人年龄是\(age)"
    }
    // 重写方法
    override func work() {
        print("日本人工作兢兢业业")
    }
    override class func playGame() {
        print("玩电子游戏")
    }
    override var age: Int {
        set{
            super.age = newValue
        }
        get{
            return super.age
        }
    }
//    override var age: Int = 20
}
Japanese.playGame()
let someone = Japanese()
someone.age
someone.age = 20
someone.age
someone.description
someone.work()

//: 重写属性观察器

class XcodeYang: Chinese {
    var homeTown:String?
    
    override var country: String {
        didSet {
            homeTown = country
        }
    }
}

let me = XcodeYang()
me.country = "China"
me.country
me.homeTown

//: >防止继承重写 **final**, 在class 前加**final**，则类无法被继承

class Hero {
    final var name = "李小龙"
    final func fight() {
        print("一招致胜")
    }
    final class func hahaha() {
        print("haha")
    }
}

// 无法重写
final class ChineseHero: Hero {
    
}

// ❌
//class shanghaiHero:ChineseHero {
//    
//}


//: 可失败构造器（同理用于其他值类型）
class Human3 {
    var name: String?
    init() { }
    init?(name:String) {
        if !name.isEmpty { return nil }
        self.name = name
    }
}

// 重载
class NewHuman3: Human3 {
    override init() {
        super.init()
        self.name = "unNamed"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "unNamed"
        } else {
            self.name = name
        }
        
    }
}



//: [构造](init_struct)

