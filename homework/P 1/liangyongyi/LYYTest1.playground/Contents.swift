//: Playground - noun: a place where people can play

import UIKit

var arra = Array(0...1000)

let arra3 = arra.filter{$0 % 3 == 0}//被3整除
let arra7 = arra.filter{$0 % 7 == 0}//被7整除

for i in 0...1000{//随机打乱数组
    let j = Int(arc4random_uniform(UInt32(1000 - i)))+i
    if i != j{
        swap(&arra[i], &arra[j])
    }
}
print(arra);

let sum = arra.reduce(0,{$0 + $1})//求和
print(sum);

let squareSum = arra.reduce(0){ total, num in return total + num*num}//求平方和
print(squareSum);

let average = double_t(sum)/double_t(arra.count)//求平均值

arra.sort()
let max = arra.last //取最大值

var array :Array = [2,4,6,3]

func getMaxAndMinTuple(array: Array<Int>) -> (min: Int, max: Int){
    var arrSort = array.sorted()
    return (arrSort[0],arrSort[arrSort.count - 1])
}

var trupe = getMaxAndMinTuple(array: array)//创建返回数组中最大最小值的元组的函数

//尾随闭包 和高阶的在上面有用过，其余的下次补上在提交
