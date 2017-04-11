//: [Previous](@previous)

import UIKit

/*:
 Sequence & Reduce 😈
 ====================
 sequence(first:next:) 和 sequence(state:next:) 的返回值类型是 UnfoldSequence。
 
 这个术语来自函数式编程，在函数式编程中，这种操作被称为展开 (unfold)。
 
 sequence 是和 reduce 对应的 (在函数式编程中 reduce 又常被叫做 fold)。
 
 reduce 将一个序列缩减 (或者说折叠) 为一个单一的返回值，而 sequence 则将一个单一的值展开形成一个序列。
 */


let randomNumbers = sequence(first: 100) { (previous: UInt32) in
    let newValue = arc4random_uniform(previous)
    guard newValue > 0 else {
        return nil
    }
    return newValue
}

print(Array(randomNumbers))



let fibsSequence2 = sequence(state: (0, 1)) { (state: inout (Int, Int)) -> Int? in
    let upcomingNumber = state.0
    state = (state.1, state.0 + state.1)
    return upcomingNumber
}

print(Array(fibsSequence2.prefix(10)))



/*:
 作业: 💪
 sequence 遍历实现UIView实例对象的所子view及子view的子view一直递归下去，使用数组承载
 */
let view = UIView()
//
//let viewSequence = sequence(state: view) { (superView) -> [UIView]? in
//    
//}
