//: [Extension](Extension) |
//: Error |
//: [Subscript](Subscript)


/*:
 错误处理 ❌
 ==========
 举例：假如有个从磁盘上的某个文件读取数据并进行处理的任务，该任务会有多种可能失败的情况，包括指定路径下文件并不存在，文件不具有可读权限，或者文件编码格式不兼容。区分这些不同的失败情况可以让程序解决并处理某些错误，然后把它解决不了的错误报告给用户
 - 表示并抛出错误
 - 处理错误
 - 指定清理操作
 */

import UIKit

//: 表示并抛出错误
enum DatingMachineError: Error {
    case invalidSelection                       //选择无效
    case insufficientFunds(coinsNeeded: Int)    //金额不足
    case outOfStock                             //缺货
    case unknow                                 //未知
    
    var localizedDescription: String {
        switch self {
        case .invalidSelection:
            return "选择无效"
        case .insufficientFunds(let coinsNeeded):
            return "请再投入\(coinsNeeded)元"
        case .outOfStock:
            return "缺货"
        default:
            return "未知错误"
        }
    }
}

// throw DatingMachineError.insufficientFunds(coinsNeeded: 5)



/*:
 错误抛出
 ------
 ```
 func canThrowErrors() throws -> String
 func cannotThrowErrors() -> String
 ```
 */

struct Person {
    var price: Int
    var count: Int
}

class DatingMachine {
    
    var waitingList = [
        "boyFriend" : Person(price: 10,   count: 7),
        "grilFriend": Person(price: 10,   count: 3),
        "goddess"   : Person(price: 100,  count: 0)
    ]
    
    var moneyPaid = 0
    
    func selling(itemNamed name: String) throws {
        
        guard let item = waitingList[name] else {
            throw DatingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw DatingMachineError.outOfStock
        }
        guard item.price <= moneyPaid else {
            throw DatingMachineError.insufficientFunds(coinsNeeded: item.price - moneyPaid)
        }
        
        moneyPaid -= item.price
        
        var newItem = item
        newItem.count -= 1
        waitingList[name] = newItem
        
        print("已派出 \(name)")
    }
}

//: 嵌套错误抛出的函数
//: ---------------
//: 抛出的错误会一直被传递到外围的抛出错误函数

let customerFavorite = [
    "Alice" : "girlFriend",
    "Bob"   : "cat",
    "Daniel": "goddess"
]
func dateFavoritePerson(customer: String, datingMachine: DatingMachine) throws {
    let snackName = customerFavorite[customer] ?? "grilFriend"
    try datingMachine.selling(itemNamed: snackName)
}

// 初始化方法错误抛出
struct PurchasedSnack {
    let name: String
    init(name: String, datingMachine: DatingMachine) throws {
        try datingMachine.selling(itemNamed: name)
        self.name = name
    }
}

/*:
 错误处理
 ------
 和其他语言中（包括 Objective-C ）的异常处理不同的是，Swift 中的错误处理并不涉及解除调用栈（函数调用栈解释参考[blog1](http://www.cnblogs.com/rain-lei/p/3622057.html)，[blog2](http://blog.csdn.net/wangxiaolong_china/article/details/6844371)），这是一个计算代价高昂的过程。就此而言，throw语句的性能特性是可以和return语句相媲美的
 */

// do catch
var datingMachine = DatingMachine()
datingMachine.moneyPaid = 80

do {
    try dateFavoritePerson(customer:"Bob", datingMachine: datingMachine)
} catch  {
    if let reason = (error as? DatingMachineError)?.localizedDescription {
        print(reason)
    } else {
        print(DatingMachineError.unknow.localizedDescription)
    }
}
//: > Swift 的错误抛出其实是无类型的：我们只能够将一个函数标记为 throws，但是我们并不能指定应该抛出哪个类型的错误。
//:
//: 这是一个有意的设计，在大多数时候，你只关心有没有错误抛出。如果我们需要指定所有错误的类型，事情可能很快就会失控：它将使函数类型的签名变得特别复杂，特别是当函数调用其他的可抛出函数，并且将它们的错误向上传递的时候，这个问题将尤为严重。另外，添加一个错误类型，可能对使用这个 API 的所有客户端来说都是一个破坏性的 API 改动。
do {
    try dateFavoritePerson(customer:"Daniel", datingMachine: datingMachine)
} catch DatingMachineError.invalidSelection {
    print("无此类型可供选择")
} catch DatingMachineError.outOfStock {
    print("已被约满，请换其他的")
} catch DatingMachineError.insufficientFunds(let coinsNeeded) {
    print("余额不足. 请继续投 \(coinsNeeded) 个一元硬币.")
} catch {
    print("其他错误")
}

// 将错误转换成可选值

func someThrowingFunction() throws -> Int {
    return 0
}

var x = try? someThrowingFunction()
x

//等同于

let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}

//let fileItem = try FileManager.default.attributesOfItem(atPath: "")
//fileItem


/*:
 rethrows
 ---------
 map函数：
 
 public func map<T>(_ transform: (Key, Value) throws -> T) rethrows -> [T]
 
 */

extension Array {
    /// 当且仅当所有元素满足条件时返回 `true`
    func all(condition: (Iterator.Element) -> Bool) -> Bool {
        for element in self {
            guard condition(element) else { return false }
        }
        return true
    }
}
extension Int {
    // 是否是质数
    var isPrime: Bool {
//        return self > 1 && !(2..<self).contains { self % $0 == 0 }
        return self > 1 && !(2..<Int(sqrt(Double(self)))).contains { self % $0 == 0 }
    }
}

func checkPrimes(_ numbers: [Int]) -> Bool {
    return numbers.all { $0.isPrime }
}

let numberArray = [2,3,5,7,11,47]
let numberArray2 = [2,3,5,6,7,11]
checkPrimes(numberArray)
checkPrimes(numberArray2)

//:> 将 all 标记为 rethrows。这样一来，我们就可以一次性地对应两个版本(一个需要错误抛出，一个不需要)。rethrows 告诉编译器，这个函数只会在它的参数函数抛出错误的时候抛出错误。对那些向函数中传递的是不会抛出错误的 check 函数的调用，编译器可以免除我们一定要使用 try 来进行调用的要求：
// 添加 rethrows
extension Sequence {
    func all(condition: (Iterator.Element) throws -> Bool) rethrows
        -> Bool {
            for element in self {
                guard try condition(element) else { return false }
            }
            return true
    }
}

/*:
 指定清理操作 defer
 ----------------
 defer语句：将代码的执行延迟到当前的作用域退出之前 
 (同理，guard也需要掌握)
 > 注意多个defer嵌套或串行并列的执行先后顺序（自下而上，由表及里）
 
 普通用法如下例子：
 */


prefix func ++(x: inout Int) -> Int {
    x += 1
    return x
}
var number = 100
let number2 = ++number
number
number2

postfix func ++(x: inout Int) -> Int {
    defer {
        x += 1
    }
    return x
}
var num = 100
let num2 = num++
num
num2

func deferCount(_ x: inout Int) -> Int {
//    defer {
//        x = x/2
//        defer {
//            x += 100
//        }
//    }
    defer {
        x = x/10
    }
    defer {
        x += 100
    }
    x += 10
    return x
}
var deferNumber = 100
let deferNumber2 = deferCount(&deferNumber)
deferNumber
deferNumber2


/*:
 > **defer** 能让你能执行一些必要的清理工作，不管是以何种方式离开当前代码块的（抛出错误而离开，或是return、break语句）。
 例如，你可以用defer语句来确保文件描述符得以关闭，以及手动分配的内存得以释放。
 ```
 // 文件关闭
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // 处理文件。
        }
        // close(file) 会在这里被调用，即作用域的最后。
    }
}

// 约束使用
let view = UIView()

let childView = UIView()
defer {
    childView.mas_makeConstraints {
        $0.edges.equalTo()(view)
    }
}
view.addSubview(childView)
 
 ```
 */
