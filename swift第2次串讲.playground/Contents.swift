//: Playground - noun: a place where people can play

import UIKit

let str1 = "XcodeYang1"

let str2 = {
    return "XcodeYang2"
}()

let str21 = { obj in
    return "XcodeYang21"
}()

let str22 = { obj in
    return obj
}("XcodeYang22")

let str23 = {$0}("XcodeYang23")

// 懒加载
var str3: String {
    print("XcodeYang3")
    return "XcodeYang3"
}

var str31 = String("XcodeYang3")

var str4: String {
    get{
        return "XcodeYang4"
    }
}

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
str5 = "new Xcode"

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
 ```
 {
    (arguments) ->returnType  in
    // code
 }(arguments)
 ```
*/



var numberArr = [1,7,4,6,3,2,5]
func sort_function(_ a:Int, _ b:Int) -> Bool {
    return a>b
}
let res1 = numberArr.sorted(by: sort_function)

typealias SortBlock = (Int,Int)->Bool;
let newSortFunc:SortBlock = {
    $0 < $1
}
let res2 = numberArr.sorted(by: newSortFunc)


func caculateTwoNumbers(num1: Int, num2: Int, CaluFunction: (Int, Int) -> Int) -> Int{
    return CaluFunction(num1, num2)
}

//内联闭包形式，不使用尾随闭包，求和
var numReult1 = caculateTwoNumbers(num1: 2, num2: 3,CaluFunction: {
    (num1: Int, num2: Int) -> Int in
    return num1 + num2
})
//5
//使用尾随闭包,求乘机
var numReult2 = caculateTwoNumbers(num1: 3, num2: 4) { $0 * $1 }
numReult2 //12



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
// 尾随闭包
let squareResult4 = averageOfFunction(a: 4, b: 5) { $0*$0 }
squareResult3
squareResult4





var value = 50
print(value)  // 此时value值为50

func increment( value: inout Int, length: Int = 10) {
    value += length
}

increment(value: &value)
print(value)  // 此时value值为60，成功改变了函数外部变量value的值


//:[next page](Sources/closure.swift)

