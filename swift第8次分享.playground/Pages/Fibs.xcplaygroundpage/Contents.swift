//: [Previous](@previous)

import Foundation

//: ## 斐波那契序列
//: 0,1,1,2,3,5,8....

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
    print("for: \(num)")
}

// 高阶函数
let array = FibSequence(count: 5).map{ $0 }
array
let sum = FibSequence(count: 5).reduce(0) { $0+$1 }
sum





