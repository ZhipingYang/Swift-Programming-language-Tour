
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

//: 迭代器和值语义

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

//:> MyIterator & AnyIterator 不具有值语义,任何对 i3、i4 或者 i5、i6 进行的调用，都会增加底层那个相同的迭代器的取值。更多的时候是通过使用 for 循环隐式地进行创建的。你只用它来循环元素，然后就将其抛弃

func fibsIterator() -> AnyIterator<String> {
    let string: String = "Hello"
    var offset = string.startIndex
    return AnyIterator {
        if offset >= string.endIndex { return nil }
        offset = string.index(after: offset)
        return string[string.startIndex..<offset]
    }
}

let sequence = AnySequence(fibsIterator)
let strArray = Array(sequence.prefix(4))
strArray

let sliptSequence = AnySequence(fibsIterator).split { (str) -> Bool in
    return str.characters.count>3
}

// 子序列
if let new = sliptSequence.first {
    let sliptArray = Array(new)
    sliptArray
}

//: [返回Sequence](Sequence) |
//: [返回斐波那契序列](Fibs)

