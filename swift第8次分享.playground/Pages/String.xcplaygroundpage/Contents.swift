//: [Previous](@previous)

import Foundation

// 遍历 String 打印

struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index
    init(string: String) {
        self.string = string
        self.offset = string.startIndex
    }
    mutating func next() -> String? {
        if offset >= string.endIndex { return nil }
        offset = string.index(after: offset)
        return string[string.startIndex..<offset]
    }
}

struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

for prefix in PrefixSequence(string: "Hello") {
    print("prefix："+prefix.uppercased())
}

var i1 = PrefixSequence(string: "Hello").makeIterator()
i1.next()

var i2 = i1
i1.next()
i2.next()


var i3 = AnyIterator(i1)
var i4 = i3
i1.next()
i3.next()
i4.next()



class MyIterator {
    var base: PrefixIterator
    
    public init(_ base: PrefixIterator) {
        self.base = base
    }
    func next() -> PrefixIterator.Element? {
        return base.next()
    }
}

var i5 = MyIterator(i2)
var i6 = i5
i2.next()
i5.next()
i6.next()






