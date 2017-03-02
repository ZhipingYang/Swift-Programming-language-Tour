

//: Struct |
//: [Class](Class) |
//: [对比](Comparison) |

/*:
 Swift 结构体 🤔
 ===============
 > 在 Swift 中，所有的基本类型:整数(Integer)、浮 点数(floating-point)、布尔值(Boolean)、字符串(string)、数组(array)和字典(dictionary)，都是 值类型，并且在底层都是以结构体的形式所实现
 > 结构体可以被直接持有及访问，不会被引用，但是会被复制。也就是说，结构体的持有者是唯一的
 > 结构体 (以及枚举) 是不能被继承的。想要在不同的结构体之间共享代码，需要使用如:组合、泛型以及协议扩展等。
 
 
 **考虑构建结构体的准则**
 - 该数据结构的主要目的是用来封装少量相关简单数据值
 - 有理由预计该数据结构的实例在被赋值或传递时，封装的数据将会被拷贝而不是被引用
 - 该数据结构中储存的值类型属性，也应该被拷贝，而不是被引用
 - 该数据结构不需要去继承另一个既有类型的属性或者行为
 */

import Foundation
import UIKit

/*:
 实例 💃
 ---------

 ```
 struct SomeStruct {
    // code
 }
 ```
 */

struct Goods {
    let name: String
    var price: UInt
}

// 结构体可以自己实现默认的构造方法
let phone = Goods(name: "iphone", price: 6005)
phone.name
phone.price

// 这里注意，即使price是可变类型，也不能赋值
//phone.price += 100



//: [下一页](@next)
