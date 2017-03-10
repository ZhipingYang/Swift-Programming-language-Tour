

//: Closure |
//: [Enum](Enum) |
//: [Struct](Struct)
/*:
 Swift 闭包入门 🎬
 ==================
 > 闭包是自包含的函数代码块，可以在代码中被传递和使用。Swift的闭包相当于是函数的一个子集，它利用上下文推断参数和返回值类型来省略书写，Swift还有一个闭包还有一个特性叫“尾
 随闭包”，它一个书写在函数括号之后的闭包表达式，可以增强函数的可读性。
 
 - 闭包
 - 尾随闭包
 - 省略
 - 高阶函数（介绍*柯里化*）
 */

import Foundation
import UIKit

/*:
 属性（初始化）中闭包的运用 🤓
 ---------------------
 闭包通用书写方式
 ```
 {
    (arguments) -> returnType  in
    // code
 }(arguments)
 
 ```
 */

let str = "XcodeYang"

let str1 = {
    return str+"1"
}()

let str21 = { _ in
    return "XcodeYang21"
}()

let str22 = { obj in
    return obj
}("XcodeYang22")

let str23 = {$0}("XcodeYang23")

// 懒加载
var str3: String {
    return str + "3"
}

var str4: String {
    get {
        return "XcodeYang4"
    }
}

// set get 方法
var str5: String {
    get{
        return "XcodeYang5"
    }
    set(new) {
        print(new)
    }
//    set {
//        print(newValue)
//    }
}

let str6 = str5 + "4"
str5 = "new value str5"

var str7: String = "XcodeYang7" {
    willSet{
        print("newValue:\(newValue)")
    }
    didSet{
        print("oldValue:\(oldValue)")
    }
}

str7 = "new value"

var str8 = {
    arg1,arg2 -> String in
    return arg1+arg2;
}("Xcode","Yang")

var str81 = {$0+$1}("Xcode","Yang")
str81

/*:
 闭包：尾随 😌
 ---------
 经典示例，使用UIView的动画
 ```
 UIView.animate(withDuration: TimeInterval, animations: () -> Void)
 
 UIView.animate(withDuration: 0.3, animations: { Void -> Void in
 // animation
 })
 
 UIView.animate(withDuration: 0.3) {
 // animation
 }
 ```
 */

func twoNumbersFunc(num1: Int, num2: Int, caluFunction: (Int, Int) -> Int) -> Int{
    return caluFunction(num1, num2)
}

let addResult = twoNumbersFunc(num1: 3, num2: 4) {
    (num1: Int, num2: Int) -> Int in
    return num1 + num2
}

/*:
 > 别名有助于程序的理解，如下，可以把闭包当成一个普通参数使用，尾随在代码可读性上增强了
 */

typealias NumBlock = (Int) -> Int
typealias TwoNumBlock = (Int, Int) -> Int

func newTwoNumbersFunc(num1: Int, num2: Int, first:NumBlock, second:TwoNumBlock) -> Int{
    return second(first(num1),first(num2))
}

// 非尾随的样式 
// 4*4 + 5*5 = 41
let 两个数的平方和 = newTwoNumbersFunc(num1: 4, num2: 5, first: { (num) -> Int in
    return num * num
}, second: { (num1, num2) -> Int in
    return num1 + num2
})

// 尾随的样式
let 新两个数的平方和 = newTwoNumbersFunc(num1: 4, num2: 5, first: { (num) -> Int in
    return num * num
}) { (num1, num2) -> Int in
    return num1 + num2
}

/*:
 闭包：书写省略 😘
 -----------
 如上：
 ```
 let 省略新两个数的平方和 = newTwoNumbersFunc(num1: 4, num2: 5, first: {$0 * $0}) { $0 + $1 }
 新两个数的平方和 // 41
 ```
 */
let squareResult1 = averageOfFunction(a: 2, b: 4, f: square)
let squareResult2 = averageOfFunction(a: 2, b: 4, f: {
    (a: Float) -> Float in
    return a * a
})
//{(x: Float) -> Float in return x * x}
//{x in return x * x}
//{x in x * x}
//{$0 * $0}
let squareResult3 = averageOfFunction(a: 2, b: 4, f: {$0 * $0})
squareResult3


/*:
 闭包：高阶函数 😱
 -----------
 简单说就是：以接受一个或多个函数作为输入，输出一个函数作为返回值的函数，举个NSArray的map函数做例子
 ```
 var numberArr = [1,7,4,6,3,2,5]
    let strArray = numberArr.map { (num: Int) -> String in
    return "\(num)"
 }

 ```
 借此概念我们也可以在objc中也一样可以实现类似功能
 ```
 - (NSArray *)ck_arrayMap:(id (^)(id obj))block
 {
	NSParameterAssert(block != nil);
 
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
 
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj) ?: [NSNull null];
        [result addObject:value];
	}];
 
	return result;
 }
 ```
 */

var numbersArr = [1,7,4,6,3,2,5]

//: ### forEach
var sum_each = 0;
numbersArr.forEach { (num) in
    sum_each += num
}
sum_each

//: ### map
let mapArray = numbersArr.map { (num: Int) -> String in
    return "第\(num)名"
}
let mapArray2 = numbersArr.map({"第\($0)名"})
mapArray2
// 可选型随意解包 str 可以为 nil
let numStr: String? = "1234567890"
let mapStr = numStr.map({"第\($0)名"})
mapStr

//: ### filter
let filArr = numbersArr.filter { (num: Int) -> Bool in
    return num > 4
}
let filArr2 = numbersArr.filter({ $0 > 4 })
filArr2

/*:
 ### reduce
 他比其他的更加强大，如下reduce实现，涉及的泛型知识后面串讲会提到
 
 ```
 extension Array {
    func reduce<T>(_ initial: T, combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
 }
 ```
 */

let sum = numbersArr.reduce(0) { (presum:Int, num:Int) -> Int in
    return presum + num
}
let sum2 = numbersArr.reduce(10){$0 + $1}
sum2
let sumToStr = numbersArr.reduce("") { (str: String, num: Int) -> String in
    str + String(num)
}


// 求一个数组中偶数的平方和（一口气使用swift提供的三个高阶函数）
//[1,2,3,4,5,6,7] -> [2,4,6] -> 4+16+36 = 56
let result = numbersArr.filter({$0%2==0}).map({$0*$0}).reduce(0){$0+$1}
result


/*:
 家庭作业：
 =======
 面试题：用数组的 reduce 方法实现 map 的功能。
 */
let arr = [1, 3, 2]
let res = arr.map({$0*2})
res
let res2 = arr.reduce([]) {
    (a: [Int], element: Int) -> [Int] in
    var t = a
    t.append(element * 2)
    return t
}
res2

/*:
 // 面试题：用 reduce 方法一次求出数组中奇数的和、以及偶数乘积
 // 使用元组，注意占位数据(0, 1)，第一联合数据a :(Int, Int)，函数输出数据(Int, Int) 三者类型一致
*/

let arr2 = [1, 3, 2, 4]
let res3: (Int, Int) = arr2.reduce((0, 1)) {
    (a :(Int, Int), element: Int) -> (Int, Int) in
    if element % 2 == 0 {
        return (a.0, a.1 * element)
    } else {
        return (a.0 + element, a.1)
    }
}

//: [跳转到下一页](@next)
