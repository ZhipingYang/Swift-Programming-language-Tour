import UIKit

//: ## 创建0到1000的数组
print("hello")
var thousandArray = [Int]()
for i in 0...1000 {
    thousandArray.append(i)
}

//: ## 求数组中能被的3或7整除的数
var numList = [Int]()
for i in 0..<thousandArray.count {
    if i % 7 == 0 || i % 3 == 0 {
        numList.append(i)
    }
}

//: ## 随机打乱当前数组里元素的顺序

//: ## 求数组里元素的和、平方和、平均值、最大值
func analyseArray(array: [Int]) -> (sum: Int, sumOfSuqares: Int, avarage: Int, max: Int) {
    var sum = 0
    var sumOfSuqares = 0
    var max = array[0]
    for item in array {
        sum += item
        sumOfSuqares += item * item
        if item > max {
            max = item
        }
    }
    return (sum, sumOfSuqares, sum/array.count, max)
}

//: ## 创建返回数组中最大最小值的元组的函数
func getMaxAndMin(array:[Int]) -> (max: Int, min: Int) {
    var max = array[0]
    var min = array[0]
    for item in array {
        if item > max {
            max = item
        }
        if item < min {
            min = item
        }
    }
    return (max, min)
}

//: ## 设计一个两个数可相加减乘除（或者其他逻辑）的带有尾随闭包的函数

var add = {
    (num1: Int, num2: Int) -> Int in
    return num1+num2
}
add(1,2)

//func math(num1: Int, num2: Int)- >

//: ## 高阶函数
//: map、filter、sort、foreach、reduce的举例实战（每个函数至少两个示例）

//: [Demo](@next)
