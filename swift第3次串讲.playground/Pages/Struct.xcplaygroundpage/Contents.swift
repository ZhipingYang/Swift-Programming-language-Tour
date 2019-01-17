//: Struct |
//: [Class](Class) |
//: [对比](Comparison)
/*:
 Swift 结构体 🤔
 ===============
 > 在 Swift 中，所有的基本类型:整数(Integer)、浮点数(floating-point)、布尔值(Boolean)、字符串(string)、数组(array)和字典(dictionary)，都是 值类型，并且在底层都是以结构体的形式所实现
 
 **考虑构建结构体的准则**
 - 该数据结构的主要目的是用来封装少量相关简单数据值
 - 有理由预计该数据结构的实例在被赋值或传递时，封装的数据将会被拷贝而不是被引用
 - 该数据结构中储存的值类型属性，也应该被拷贝，而不是被引用
 - 该数据结构不需要去继承另一个既有类型的属性或者行为
 */

import Foundation
import UIKit

/*:
 实例 💃
 ---------

 ```
 struct SomeStruct {
    // code
 }
 ```
 */

struct Goods {
    let name: String
    var price: UInt
}

// 结构体可以自己实现成员逐一构造器
let phone = Goods.init(name: "iPhone", price: 6088)
phone.name
phone.price
// 这里注意，即使secondHandPrice是可变类型，也不能赋值
//phone.secondHandPrice = 1000


struct iPhone {
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
    // self 或者 property 变化 时需要 mutating
    // 同时，自身也被复制一份（浅复制，出现引用类型只复制指针）
    // 同理：属性的setter，数组append等等也是隐式添加 mutating
    mutating func getBroken() {
        guard let price = price else {
            return
        }
        self.price = price/10
    }
}

var danielsiPhone = iPhone()
danielsiPhone.price
danielsiPhone.price = 6000

let Inc = iPhone.productor

var dannyiPhone = danielsiPhone
dannyiPhone.getBroken()
dannyiPhone.price
danielsiPhone.price

//: ===结构体不可用 你只能通过它们的属性来比较两个结构体
//if dannyiPhone === danielsiPhone {
//    print("同一个对象引用")
//}

struct Point {
    var x: Int
    var y: Int
}

struct Size {
    var width: Int
    var height: Int
}

struct Rectangle {
    var origin: Point
    var size: Size
}

var originRect = Rectangle(origin: Point(x: 10, y: 20), size: Size(width: 30, height: 40))
var newRect = originRect
newRect.origin.x += 1
originRect
newRect

//: > 当我们只是改变深入结构体中的某个属性的时候，didSet会被触发，Swift会自动对它进行复制。虽然听起来这会很浪费，不过大部分的复制都会被编译器优化掉，Swift 也竭尽全力让这些复制操作更加高效。实际上，标准库中有很多结构体都使用了写时复制的技术进行实现

var rect = Rectangle(origin: Point(x: 10, y: 20), size: Size(width: 30, height: 40)){
didSet {
    print("Rect changed: \(rect)")
}
}
rect.origin.x = 20


//: > 同理：更改数组中某个元素的一个属性，整个数组的 didSet 也将被触发.
var rectArray = [Point(x: 0, y: 0)] {
    didSet{
        print("array changed")
    }
}
rectArray[0].x = 20

/*:
 值类型 😆
 ---------
 > 数组或结构体等值类型对象存储的引用类型被修改时，自己是不会发生改变复制的，只是引用指向的对象发生了改变
 > 对象复制的时候发生的是按照字节进行的浅复制。除非结构体中含有类（引用类型），否则复制时都不需要考虑其中属性（引用类型）的引用计数
 > 只有一个持有者，所以它不可能造成引用循环
 */

// 触发didSet 相当于 mutating 修饰
rectArray.sort{$0.x>$1.x}
// 未触发didSet 返回新对象，原对象不改变
rectArray.sorted {$0.x>$1.x}

func changeArray(array: [Point]) {
    var new = array;
    new.append(Point.init(x: 0, y: 0))
}
// inout 用于值类型
func changeArray2(array: inout [Point]) {
    array.append(Point.init(x: 0, y: 0))
}
// 未触发didSet
changeArray(array: rectArray)
// 触发didSet
changeArray2(array: &rectArray)



// ❌
//let mutableArray: NSMutableArray = [1,2,3]
//for _ in mutableArray {
//    mutableArray.removeLastObject()
//}

// ✅ 想想为什么
var mutableArray2 = [1, 2, 3]
for _ in mutableArray2 {
    mutableArray2.removeLast()
}
mutableArray2.count

// ✅ 想想为什么
struct Human {
    let name: String
    var children: [Human]
}
var john = Human(name: "John", children: [])
john.children = [john]


/*:
 写时复制 👍🏻
 ----------
 在 Swift 标准库中，像是 Array，Dictionary 和 Set 这样的集合类型是通过一种叫做写时复制 (copy-on-write) 的技术实现的
 **使用 isKnownUniquelyReferenced 函数来检查引用的唯一性**
 */

class cPerson {
    var name:String
    init(_ name:String) {
        self.name = name
    }
}
var classArray = [cPerson("Daniel")]
isKnownUniquelyReferenced(&classArray[0])
var newClassArray = classArray
isKnownUniquelyReferenced(&classArray[0])
newClassArray.first?.name = "Angel"
classArray
newClassArray

//:> 把 structArray 赋值给 newStructArray 时，会发生复制。在内部，这些 Array 结构体含有指向某个内存的引用。这个内存就是数组中元素所存储的位置，它们位于堆 (heap) 上。两个数组的引用指向的是内存中同一个位置，这两个数组共享了它们的存储部分。不过，当我们改变 x 的时候，这个共享会被检测到，内存将会被复制
struct sPerson {
    var name:String
}
var structArray = [sPerson(name: "Daniel")]
var newStructArray = classArray
newStructArray.first?.name = "Angel"
structArray
newStructArray


class Empty {}

struct ContainClassStruct {
    var refValue = Empty()
    mutating func change() -> String {
        if isKnownUniquelyReferenced(&refValue) {
            return "No copy"
        } else {
            self.refValue = Empty()
            return "Copy"
        }
    }
}

//: 不解：指定Empty为NSObject子类，copy就成功了？？
var s = ContainClassStruct()
s.change()

var original = ContainClassStruct()
var copy = original
original.change()

if original.refValue !== copy.refValue {
    print("引用类型的对象深拷贝成功")
}

//: > 字典的下标将会在字典中寻找值，然后将它返回。因为我们是在值语义下处理，所以返回的是找到的值的复制
var dic = ["key":ContainClassStruct()]
dic["key"]?.change()
//: > Array 通过使用地址器 (addressors) 的方式实现下标。地址器允许对内存进行直接访问。数组的下标并不是返回元素，而是返回一个元素的地址器。这样一来，元素的内存可以被原地改变，而不需要再进行不必要的复制
//: Array 的下标使用了特别的处理，来让写时复制生效。但是不幸的是，现在其他类型都没有使用这种技术。Swift 团队提到过它们希望提取该技术的范式，并将其应用在字典上
var arr = [ContainClassStruct()]
arr[0].change()

var otherArr = [ContainClassStruct()]
var xx = otherArr[0]
xx.change()
/*:
 
 > 默认情况下结构体是存储在堆上的，但是在绝大多数时候，这个优化会生效，并将结构体存储到栈上。当结构体变量被一个函数闭合的时候，优化将不再生效，此时这个结构体将存储在堆上。如果结构体太大，它也会被存储在堆上
 */

//: [下一页](@next)
