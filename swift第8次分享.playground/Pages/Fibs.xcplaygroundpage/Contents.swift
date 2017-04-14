//: [返回Sequence](Sequence)

import Foundation

//: ## 斐波那契序列
//: 0,1,1,2,3,5,8....
//: > sequence 对于 next 闭包的使用是被延迟的。也就是说，序列的下一个值不会被预先计算，它只在调用者需要的时候生成

struct FibsUnlimitedIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

struct FibUnlimitedSequence: Sequence {
    func makeIterator() -> FibsUnlimitedIterator {
        return FibsUnlimitedIterator()
    }
}

// 子序列
// 这个序列是无限的, prefix条件限制获取完毕，然后便停止了;
let unlimitedArr = Array(FibUnlimitedSequence().prefix(10))
let unlimitedArr2 = Array(FibUnlimitedSequence().prefix(while: { $0<20 }))
unlimitedArr
unlimitedArr2



struct FibsIterator: IteratorProtocol {
    var limit = 0
    let count:Int
    var state = (0, 1)
    init(count:Int) {
        self.count = count
    }
    mutating func next() -> Int? {
        defer {
            limit += 1
        }
        let result = state.0
        state = (state.1, state.0 + state.1)
        return limit < count ? result:nil
    }
}

struct FibSequence: Sequence {
    let count: Int
    func makeIterator() -> FibsIterator {
        return FibsIterator.init(count: count)
    }
}

// while
var iterator3 = FibsIterator(count:7)
while let num = iterator3.next() {
    print("while: \(num)")
}

// forin
for num in FibSequence(count: 6) {
    print("forin: \(num)")
}

for (index, num) in FibSequence(count: 5).enumerated() {
    print("index:\(index) num: \(num)")
}

// 高阶函数
let array = FibSequence(count: 5).map{ $0 }
array
let sum = FibSequence(count: 5).reduce(0) { $0+$1 }
sum

//: [返回Sequence](Sequence) |
//: [其他例子](String)
