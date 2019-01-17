/*:
 集合类型 (Collection)
 ===================
 指的是那些稳定的序列，它们能够被多次遍历且保持一致。除了线性遍历以外，集合中的元素也可以通过下标索引的方式被获取到。下标索引通常是整数，索引也可以是一些不透明值 (比如在字典或者字符串中)。集合的索引值可以构成一个有限的范围，它具有定义好了的开始和结束索引。也就是说，和序列不同，集合类型不能是无限的
 */


import UIKit

// Collection
let arr = [1,2,3,4,5]
arr.first
arr.count
arr.index(of: 3)
arr.prefix(upTo: 4)
arr.count
arr.isEmpty

let text = "hello world"
let num = text.count
if let firstSpace = text.index(of: " ") {
    print(text.prefix(upTo: firstSpace))
}
let firstCharacter = text[text.startIndex]
let firstCharacter2 = text.first

for i in text {
    print(i)
}

for i in text.indices {
    print(text[i])
}


// 一个能够将元素入队和出队的类型
protocol Queue {
    // 在 `self` 中所持有的元素的类型
    associatedtype Element
    // 将 `newElement` 入队到 `self`
    mutating func enqueue(_ newElement: Element)
    // 从 `self` 出队一个元素
    mutating func dequeue() -> Element?
}

// left、right 高效数据处理的队列
struct FIFOQueue<Element>: Queue {
    // 数据缓冲区
    fileprivate var left = [Element]()
    fileprivate var right = [Element]()
    /// 将元素添加到队列最后
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    /// 从队列前端移除一个元素
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}


/*:
 > Collection 的协议扩展为我们提供了默认的实现。这些扩展有一些包含关联类型的约束，它们要求协议中的关联类型需要是默认类型；比如，Collection 只为那些其中 Iterator 为 IndexingIterator<Self> 的类型提供 makeIterator 方法的默认实现：
 
 ```
 extension Collection where Self.Iterator == IndexingIterator<Self>, Self.Iterator.Element == Self._Element {
    public func makeIterator() -> IndexingIterator<Self>
 }
 ```

 Collection 四项基本实现
 ---------------------
 - startIndex
 - endIndex
 - index after
 - readOnly subscript at least
 
 > swift3.0 collection 继承协议有Indexable，IndexableBase，Sequence，
 >
 > swift3.1 collection 继承协议只有 Sequence

 */
extension FIFOQueue: Collection {
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

/*:
 ExpressibleByArrayLiteral 协议
 -----------------------------
 可以用所熟知的 [value1, value2, etc] 语法创建一个队列
 */

// 数组字面量表达协议
extension FIFOQueue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        // 已经在左侧的缓冲区准备好待用
        self.init(left: elements.reversed(), right: [])
    }
}

// 这不是数组
let queue:FIFOQueue = [2,4,6,8,0]
queue.left
queue.right
//queue.count
//查看 Array 对于 count 的默认实现

