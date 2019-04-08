
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
        return String(string[string.startIndex..<offset])
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

// 写时复制
var i2 = i1
i1.next()
i2.next()

//: 迭代器和值语义
var i3 = AnyIterator(i1)    // i1被复制了
var i4 = i3                 // i3 i4引用都一个迭代器
i1.next()
i3.next()
i4.next()


class MyReferanceIterator {
    var base: PrefixIterator
    
    public init(_ base: PrefixIterator) {
        self.base = base
    }
    func next() -> PrefixIterator.Element? {
        return base.next()
    }
}

var i5 = MyReferanceIterator(i2)
var i6 = i5
i2.next()
i5.next()
i6.next()

//:> MyReferanceIterator & AnyIterator 不具有值语义,任何对 i3、i4 或者 i5、i6 进行的调用，都会增加底层那个相同的迭代器的取值。更多的时候是通过使用 for 循环隐式地进行创建的。你只用它来循环元素，然后就将其抛弃

func fibsIterator() -> AnyIterator<String> {
    let string: String = "Hello"
    var offset = string.startIndex
    return AnyIterator {
        if offset >= string.endIndex { return nil }
        offset = string.index(after: offset)
        return String(string[string.startIndex..<offset])
    }
}

//: AnySequence

let sequence = AnySequence(fibsIterator)
let strArray = Array(sequence.prefix(4))
strArray

let commaSeparatedArray = "a,b,c".split { $0 == "," }
commaSeparatedArray.map(String.init)

let SSequence = AnySequence(fibsIterator)
let AArray = SSequence.map { $0 }
AArray

let sliptSequence = SSequence.split { (str) -> Bool in
    return str.count>4
}

let split_flatMap = sliptSequence.flatMap{ $0 }
split_flatMap

let split = sliptSequence.map{ $0.map{$0} }
split

// 子序列
if let new = sliptSequence.first {
    let sliptArray = Array(new)
    sliptArray
}

//: [返回Sequence](Sequence)

