import UIKit

//: ## 创建0到1000的数组

func generate1000Array() -> [Int] {
    var array = [Int]()
    
    for i in 34..<1034 {
        array.append(i)
    }
    return array
}

var testArray = generate1000Array()

//: ## 求数组中能被的3或7整除的数

let filterArray = testArray.filter { (num: Int) -> Bool in
    return ((num%3)==0 || (num%7)==0)
}

print(filterArray.count)

//: ## 随机打乱当前数组里元素的顺序

let randomArray = testArray.sorted { (num0: Int, num1: Int) -> Bool in
    return arc4random()%2 > 0
}

print(testArray.count)

//: ## 求数组里元素的和、平方和、平均值、最大值

let arraySum = randomArray.reduce(0) { (result: Int, num: Int) -> Int in
    return result + num
}

let arrayMutileSum = randomArray.reduce(0) { (result: Int, num: Int) -> Int in
    return result + num*num
}

let avangeValue = arraySum/randomArray.count

let maxValue = randomArray.reduce(0) { (result: Int, num: Int) -> Int in
    if result > num {
        return result
    }
    return num
}

//: ## 创建返回数组中最大最小值的元组的函数

func getMaxAndMinValueTruple(array: [Int]) -> (Int, Int) {
    let result = array.reduce((0, 0)) { (result: (Int, Int), num: Int) -> (Int, Int) in
        if num > result.0 {
            return (num, result.1)
        } else {
            if (num < result.1 || !array.contains(result.1)) {
                return (result.0, num)
            } else {
                return result
            }
        }
    }
    return result
}

let truple = getMaxAndMinValueTruple(array: randomArray)

//: ## 设计一个两个数可相加减乘除（或者其他逻辑）的带有尾随闭包的函数

func testFunc(_ num0: Int, _ num1: Int, caluationFunction: (Int, Int) -> Int) -> Int {
    return caluationFunction(num0, num1)
}

let demoNum = testFunc(6, 7) { (num0: Int, num1: Int) -> Int in
    num1+num0
}

let demoNum1 = testFunc(6, 7) { (num0: Int, num1: Int) -> Int in
    num1-num0
}

let demoNum2 = testFunc(6, 7) { (num0: Int, num1: Int) -> Int in
    num1*num0
}

let demoNum3 = testFunc(6, 7) { (num0: Int, num1: Int) -> Int in
    num1/num0
}


//: ## 高阶函数
//: map、filter、sort、foreach、reduce的举例实战（每个函数至少两个示例）

let mapArray = randomArray.map { (num: Int) -> String in
    return ".\(num)"
}

let filterTestArray = randomArray.filter { (num: Int) -> Bool in
    num%2 > 0
}

var sumValue = 0
randomArray.forEach { (num: Int) in
    sumValue += num
}
print(sumValue)

let sortedArray = randomArray.sorted {
    $0 > $1
}


//: [Demo](@next)
