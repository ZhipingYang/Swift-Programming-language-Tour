/*:
 Sequence 👍
 ===========
 Sequence 协议是集合类型结构中的基础。一个序列 (sequence) 代表的是一系列具有相同类型的值，你可以对这些值进行迭代。遍历一个序列最简单的方式是使用 for 循环：
 ```
 for element in someSequence {
    doSomething(with: element)
 }
 ```
 */
// Array
let arr = Array(0..<3)
arr.forEach{ print($0) }

// Dictionary
let dic = ["a":"a_a","b":"b_b","c":"c_c"]
for item in dic {
    print(item.value)
}

// Set
let set = Set(["set_a","set_b","set_a","set_d"])
for (idx,value) in set.enumerated() {
    print("idx:\(idx),  value:\(value)")
}
/*:
 满足 Sequence 协议的要求十分简单，你需要做的所有事情就是提供一个返回迭代器 (iterator) 的 makeIterator() 方法:
 ```
 protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
 }
 
 ```
 IteratorProtocol 协议要求
 ```
 protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
 }
 ```
 */
//: 迭代器协议
//: --------

// 类似于forin： arr / dic / set
var iterator = set.makeIterator()
while let element = iterator.next() {
    print("iterator: \(element)")
}

//:> 迭代器是单向结构，它只能按照增加的方向前进，而不能倒退或者重置,遇到 nil 终止

// 可以创建一个无限的，永不枯竭的序列
struct ConstantIterator: IteratorProtocol {
    mutating func next() -> Int? {
        return 1024
    }
}
//:> 注意这里 next() 被标记为了 mutating。对于我们这个简单的例子来说，我们的迭代器不包含任何可变状态，所以它并不是必须的。不过在实践中，迭代器的本质是存在状态的。几乎所有有意义的迭代器都会要求可变状态，这样它们才能够管理在序列中的当前位置
var iterator2Limit = 0
var iterator2 = ConstantIterator()
while let num = iterator2.next() {
    print("常量序列:\(num)")
    iterator2Limit+=1
    if iterator2Limit>5 {
        break
    }
}
//: 实践: [斐波那契序列](Fibs)
//: ---------------
struct FibsIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let result = state.0
        state = (state.1, state.0 + state.1)
        return result
    }
}

var iterator3Limit = 0
var iterator3 = FibsIterator()
while let num = iterator3.next() {
    print("斐波那契序列:\(num)")
    iterator3Limit+=1
    if iterator3Limit>10 {
        break
    }
}

/*:
 序列的不稳定性
 > 如果一个序列遵守 Collection 协议的话，那就可以肯定这个序列是稳定的了，因为 Collection 在这方面进行了保证。但是反过来却不一定，稳定的序列并不一定需要是满足 Collection
 */

//: [swift3：原生sequence高阶函数 & 作业](OriginSequence)

