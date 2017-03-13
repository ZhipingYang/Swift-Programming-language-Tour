//: [Previous](@previous)

/*:
 拓展 Extensions
 ==============
 扩展 就是为一个已有的类、结构体、枚举类型或者协议类型添加新功能。和OC的category类似
 - 拓展语法
 - 计算属性
 - 构造器
 - 方法
 - 下标
 - 嵌套类型
 */

import UIKit

//: 拓展语法： 举个🌰
//: ---------------
//: 常见的viewController, 可以添加新的功能 或 拆分代理协议

class Human: NSObject {
    
    var name = "my_vc"
    
    init(name: String) {
        self.name
    }
    func work() {
        print("工作中")
    }
}

extension Human {
    func drivingTest() {
        print("通过驾照考试")
    }
}

extension Human: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(name)
    }
}



/*:
 计算型属性
 --------
 */

extension Double {
    var km: Double { return self / 1000.0 }
    var m : Double { return self }
    var cm: Double { return self * 100.0 }
    var mm: Double { return self * 1000.0 }
}

let distance = Double(7353)
distance.km


struct iOSer {
    var name: String
}

extension iOSer {
    var isValid: Bool {
        return !name.isEmpty
    }
    mutating func work() {
        name = name + "_coding_dog"
    }
}

enum AppleDevice {
    case iPhone,iPod,iPad,Mac,iMac
}

extension AppleDevice {
    func whatShouldIBuy(money: Int) -> AppleDevice {
        if money < 10000 {
            return .iPhone
        }
        return .Mac
    }
}

/*:
 构造器
 -----
 值类型可以直接构造，引用类型需要使用便利构造器
 */

extension iOSer {
    init(firstName: String, secondName: String) {
        self.name = firstName + secondName
    }
}

extension Human {
    convenience init(firstName: String, secondName: String) {
        self.init(name: firstName + secondName)
    }
}

/*:
 方法
 -----
 静态方法，实例方法，类方法
 */

extension iOSer {
    static func bestPrictise() -> String {
        return "Swift3.0"
    }
    func favoriteLanguage() -> String {
        return "\(name) loved swift"
    }
}

let bp = iOSer.bestPrictise()
let xcodeyang = iOSer(name: "xy")
xcodeyang.favoriteLanguage()


extension Human {
    static func tranlateChinese() -> String {
        return "人类"
    }
    class func tranlateJanpanese() -> String {
        return "ピープル"
    }
    func coding(code:(()->Void)?) {
        code?()
    }
}

let chineseName = Human.tranlateChinese()
let janpaneseName = Human.tranlateJanpanese()
let me = Human(firstName: "yang", secondName: "zhi")
me.coding { 
    print("Hello World")
}



/*:
 嵌套类型
 ------
 比如结构体里面的枚举等等
 */

extension iOSer {
    
    class Job {
        var experience: Int = 0 {
            didSet{
                salary = experience>3 ? 50:10
            }
        }
        var salary = 0
        
        init(l: Language) {
            if l != .oc {
                experience = 3
                salary = 30
            }
        }
    }
    
    enum Language {
        case oc, swift, java, js, c
    }
    
    var myFavoriteDSL: Language {
        return .js
    }
    
    var newJob: Job {
        return Job(l: myFavoriteDSL)
    }
}

xcodeyang.newJob.salary

/*:
 下标
 ----
 常见数组，字典等等 见:[下标学习](Subscript)
 */

extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]
746381295[5]

//: [Next](@next)