import UIKit

//: ## 创建0到1000的数组
var arr = [Int]();
var n = 0;
var m = 10
//方式一
//while n <= m {
//    arr.append(n);
//    n = n + 1;
//}
//方式二
//repeat {
//    arr.append(n);
//    n = n + 1;
//} while (n <= m)
//方式三
for index in 0 ... m {
    arr.append(index);
}
print(arr)

//: ## 求数组中能被的3或7整除的数
var arr1 = [Int]();
//方式一
for number in arr {
    if number > 0 {
        if number % 3 == 0 ||
           number % 7 == 0 {
            arr1.append(number);
        }
    }
}
//方式二
print(arr1)

//: ## 随机打乱当前数组里元素的顺序
for i in 0 ..< arr.count {
    let j = Int(arc4random()) % arr.count;
    if i != j {
        swap(&arr[i], &arr[j])
    }
}
print(arr)

//: ## 求数组里元素的和、平方和、平均值、最大值
//数据元素和
let result = arr.reduce(0){$0 + $1}
print(result)
//平方和
let result1 = arr.map({$0*$0}).reduce(0){$0 + $1}
print(result1)
//平均值
let result2 = result / arr.count
print(result2)
//最大值
var resultMax = 0;
arr.forEach { (num) in
    if num > resultMax {
        resultMax = num
    }
}
print(resultMax)

//: ## 创建返回数组中最大最小值的元组的函数
func maxminValue ( arr:[Int] ) -> (max:Int, min:Int) {
    var curmax = arr[0], curmin = arr[0]
    for value in arr[1 ..< arr.count] {
        curmax = max(curmax, value)
        curmin = min(curmin, value)
    }
    return (curmax, curmin)
}
print(maxminValue(arr: arr))

//: ## 设计一个两个数可相加减乘除（或者其他逻辑）的带有尾随闭包的函数
func twoNumberOperation (num1: Int, num2: Int, funcation: (Int, Int) -> Int) -> Int {
    return funcation(num1, num2)
}
let addFun = twoNumberOperation(num1: 1, num2: 2) {
    (num1: Int, num2: Int) -> Int in
    return num1 + num2;
}
print(addFun)

//: ## 高阶函数
//: map、filter、sort、foreach、reduce的举例实战（每个函数至少两个示例）
arr.map { (num: Int) -> String in
    return "数字" + String(num)
}
var arr2 = arr.map { (num: Int) -> Int in
    return num * num;
}
print(arr2)

var arr3 = arr.filter { (num: Int) -> Bool in
    return num > 5
}
print(arr3)
arr3 = arr3.filter({$0 > 8})
print(arr3)

var arr4 = arr.sorted()

arr4.forEach { (num) in
    print(num)
}

var sum = arr4.reduce(0) { (sum: Int, num: Int) -> Int in
    sum + num;
}
print(sum)
var sumStr = arr4.reduce("数组里有") { (sum: String, num: Int) -> String in
    sum + String(num) + ",";
}
print(sumStr)


//: [Demo](@next)
