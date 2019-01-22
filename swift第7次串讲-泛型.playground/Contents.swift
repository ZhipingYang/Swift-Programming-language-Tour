/*:
 泛型 😈
 ======
 
 泛型是 Swift 最强大的特性之一，许多标准库是通过泛型代码构建的。例如，Array 和 Dictionary 都是泛型集合。你可以创建一个 Int 数组，也可创建一个 String 数组，甚至可以是任意其他 Swift 类型的数组。同样的，你也可以创建存储任意指定类型的字典。
 - 泛型所解决的问题
 - 泛型函数
 - 类型参数
 - 命名类型参数
 - 泛型类型
 - 扩展一个泛型类型
 - 类型约束
 - 关联类型
 - 泛型 Where 语句
 */
import UIKit
/*:
 繁琐的OC逻辑处理，一一创建对应不同类型的方法
 */
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

func swapTwoStrings(_ a: inout String, _ b: inout String) {
    let temporaryA = a
    a = b
    b = temporaryA
}

func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var threeInt = 3
var sevenInt = 7

swapTwoInts(&threeInt, &sevenInt)
print("threeInt is now \(threeInt), and sevenInt is now \(sevenInt)")


var name = "andy"
var address = "shanghai"
swapTwoStrings(&name, &address)
print("name: \(name), address: \(address)")

/*:
 泛型函数
 -------
 针对以上：参考 Swift标准库函数 swap，上面三个函数的泛型版本
 */

// Swift标准库函数
swap(&threeInt, &sevenInt)
print("threeInt is now \(threeInt), and sevenInt is now \(sevenInt)")

//:> 占位类型名（在这里用字母 T 来表示）来代替实际类型名（例如 Int、String 或 Double）。占位类型名没有指明 T 必须是什么类型，但是它指明了 a 和 b 必须是同一类型 T，无论 T 代表什么类型。<T> 尖括号告诉 Swift 那个 T 是 swapTwoValues(_:_:) 函数定义内的一个占位类型名，因此 Swift 不会去查找名为 T 的实际类型。

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

swapTwoValues(&threeInt, &sevenInt)
print("threeInt is now \(threeInt), and sevenInt is now \(sevenInt)")

swapTwoValues(&name, &address)
print("name: \(name), address: \(address)")

/*:
 当函数第一次被调用时，T 被 Int 替换，第二次调用时，被 String 替换
 命名类型参数
 
 > 类型参数具有一个描述性名字，例如 Dictionary<Key, Value> 中的 Key 和 Value，以及 Array<Element> 中的 Element，这可以告诉阅读代码的人这些类型参数和泛型函数之间的关系。然而，当它们之间没有有意义的关系时，通常使用单个字母来命名，例如 T、U、V. (首字大写驼峰命名法)
 */
func swap_f<AnyValue>(_ a: inout AnyValue, _ b: inout AnyValue) {
    let temporaryA = a
    a = b
    b = temporaryA
}
swap_f(&threeInt, &sevenInt)
print("threeInt is now \(threeInt), and sevenInt is now \(sevenInt)")

/*:
 泛型类型
 -------
 ![i](stackPushPop_2x.png)
 模拟出入栈
 */

struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("aa")
stackOfStrings.push("bb")
stackOfStrings.push("cc")
/*:
 扩展一个泛型类型
 */
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

if let topElement = stackOfStrings.topItem {
    print(topElement)
}

/*:
 类型约束
 -------
 类型约束可以指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合。
 ```
 Dictionary<Key : Hashable, Value>
 ```
 */

class SomeClass {
    var name = "SomeClass"
}

protocol SomeProtocol {
    var hello: String { get }
}

protocol AnotherProtocol {
    var hello2: String { get }
}

func someFunction<T: SomeClass, U: SomeProtocol & AnotherProtocol>(someT: T, someU: U) {
    print("name:\(someT.name) \nhello 1:\(someU.hello) 2:\(someU.hello2)")
}

class SomeProtocolClass: SomeProtocol, AnotherProtocol {
    var hello2: String = "HelloChild2"
    var hello: String = "HelloChild"
}

class SomeChildClass: SomeClass {
    override var name: String {
        set {
            super.name = newValue;
        }
        get {
            return "child" + super.name
        }
    }
}

let someProto = SomeProtocolClass()
let childObj = SomeChildClass()
childObj.name = "SomeChildClass"
someFunction(someT: childObj, someU: someProto)

//实例练习
func findIndex(array: [String], _ valueToFind: String) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
var animals = ["cat", "dog", "mouse", "fish"]
let foundIndex = findIndex(array: animals, "mouse")

// 泛型
func findIndex<T: Equatable>(array: [T], _ valueToFind: T) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let nums = [2, 4, 7, 1, 3, 4]
let foundIndex2 = findIndex(array: nums, 4)

/*:
 重载 🙄 （坑）
 -----------
 拥有同样名字，但是参数或返回类型不同的多个方法互相称为重载方法，方法的重载并不意味着泛型。不过和泛型类似，我们可以将多种类型使用在同一个接口上。
 > 重载的使用是在编译期间静态决定的。也就是说，编译器会依据变量的静态类型来决定要调用哪一个重载，而不是在运行时根据值的动态类型来决定
 */

func log<View: UIView>(_ view: View) {
    print("It's a \(type(of: view)), frame: \(view.frame)")
}
func log(_ view: UILabel) {
    let text = view.text ?? "(empty)"
    print("It's a label, text: \(text)")
}

let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 32))
label.text = "Password"
log(label)
let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
log(button)

[label, button].forEach{ log($0) }

//: 这是因为 array 的静态类型是 [UIView]，UILabel 本来应该使用更专门的另一个重载，但是因为重载并不会考虑运行时的动态类型，所以两者都使用了 UIView 的泛型重载。

// 运算符重载
let num = powf(2, 10)

// 幂运算比乘法运算优先级更高
precedencegroup ExponentiationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}
infix operator **: ExponentiationPrecedence
func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)+0.1
}
func **(lhs: Float, rhs: Float) -> Float {
    return powf(lhs, rhs)+0.2
}

// 只要有一个指定了类型
let num2 = 2 ** Float(10)
let num3 = 2.0 ** 10
let num4:Float = 2 ** 10

//func **<I: SignedInteger>(lhs: I, rhs: I) -> I {
//    // 转换为 IntMax，使用 Double 的重载计算结果，
//    // 然后用 numericCast 转回原类型
//    let result = Double(UInt64(lhs)) ** Double(UInt64(rhs))
//    return numericCast(BinaryInteger(result))
//}

//:> 当使用操作符重载时，编译器会表现出一些[奇怪的行为](http://www.cocoawithlove.com/blog/2016/07/12/type-checker-issues.html)。即使泛型版本应该是更好的选择 (而且应该在一个普通函数调用时被选择) 的时候，类型检查器也还是会去选择那些非泛型的重载，而不去选择泛型重载。
//// Ambiguous use of operator '**'
//let num5 = 2 ** 10
//let num6:Int = 2 ** 10

//:> 编译器忽略了整数的泛型重载，因此它无法确定是去调用 Double 的重载还是 Float 的重载，因为两者对于整数字面量输入来说，是相同优先级的可选项 (Swift 编译器会将整数字面量在需要时自动向上转换为 Double 或者 Float)，所以编译器报错说存在歧义

/*:
 关联类型
 ------
 关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的实际类型在协议被采纳时才会被指定。你可以通过 associatedtype 关键字来指定关联类型。
 */
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct StrStack: Container {
    // 协议部分：指定关联类型后，ItemType的相关协议才生效, 或者直接实现ItemType方法的类型
    typealias ItemType = String
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> String {
        return items[i]
    }
    mutating func append(_ item: String) {
        self.push(item)
    }
    // 原始实现部分
    var items = [String]()
    mutating func push(_ item: String) {
        items.append(item)
    }
    mutating func pop() -> String {
        return items.removeLast()
    }
}

var alphabet = ["a","b","c","d","e"]
var ss = StrStack(items: alphabet)
ss.append("f")
ss.count
//ss[0] = "3" // 下标为 get 无 set
ss[0]
ss.pop()



extension Array: Container{}
alphabet.count
alphabet[0] = "3"
alphabet[0]
alphabet.append("3")



struct AnyStack<Element>: Container {
    // AnyStack<Element> 的原始实现部分
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // Container 协议的实现部分
//    typealias ItemType = Element 可有可无

    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

var anyS = AnyStack(items: [SomeClass()])
anyS.count
anyS[0].name
anyS.pop()

/*:
 泛型 Where 语句 😏
 ----------------
 */
func isAllItemsEqual<T:Container>(_ someContainer: T) -> Bool where T.ItemType: Equatable {
    
    if someContainer.count > 1 {
        for i in 1..<someContainer.count {
            if someContainer[i] != someContainer[0] {
                return false
            }
        }
    }
    return true
}

func isTwoContainerAllItemsEqual<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable /*, C2.ItemType: Equatable*/
{
    if someContainer.count != anotherContainer.count { return false }
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
}


let abS = StrStack(items: ["a","b"])
let aaS = StrStack(items: ["aa","aa"])
let abArr = ["a","b"]
let aa = ["aa","aa"]

isAllItemsEqual(abS)
isAllItemsEqual(aa)

isTwoContainerAllItemsEqual(abS, abArr)
isTwoContainerAllItemsEqual(abS, aa)



// 拓展：回顾 where 关键字的使用场景

// 递进条件判断

let where_arr = (0...8).map{$0} // Array(0...8)

for i in where_arr where i%2==0 {
    print("where_arr"+"\(i)")
}

enum FamilyMember {
    case father(age: Int)
    case mother(realAge: Int, looksLikeAge:Int)
    case sister(age: Int)
    
    var gift: String {
        switch(self) {
        case .sister(let age):
            if age > 18 {
                return "iphone"
            } else {
                return "toy"
            }
        case .mother(let realAge, let looksLikeAge) where realAge > looksLikeAge && realAge < 40:
            return "cloth"
        default:
            return "book"
        }
    }
}

let sister = FamilyMember.sister(age: 23)

if case .sister(let age) = sister, age > 20 {
    print("sisiter age: \(age) > 20, gift:"+sister.gift)
}

// 协议、类型约束

protocol WhereProtocol {}
class WhereClass {}

extension WhereProtocol where Self: WhereClass {
    //code
}

extension Array where Iterator.Element: WhereClass/*, Iterator.Element: Hashable*/ {
    func hello() {print("hello")}
}

let helloArr = [WhereClass()]
helloArr.hello()
//where_arr.hello()

// 泛型 约束 对象遵从协议
func someFunction<T: SomeClass>(someT: T) where T:SomeProtocol {
    print("name:\(someT.name) \nhello 1:\(someT.hello)")
}


