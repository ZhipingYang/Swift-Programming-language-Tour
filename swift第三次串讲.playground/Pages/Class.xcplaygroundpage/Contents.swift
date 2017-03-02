//: [Struct](Struct) |
//: Class |
//: [对比](Comparison) |

import UIKit

/*:
 Class 类 🇨🇳 
 ==========
 
 > 类的实例只能通过引用来间接地访问, 它能有很多个持有者
 > 使用类，我们可以通过继承来共享代码
 
 */


/*:
 实例 💃
 ---------
 
 ```
 class SomeClass {
 // code
 }
 ```
 */

class Goods {
    let name: String
    var price: UInt
    
    init(name: String, price: UInt) {
        self.name = name
        self.price = price
    }
}

let phone = Goods(name: "iphone", price: 6005)
phone.name
phone.price += 100
phone.price



//: [上一页](@previous) |
//: [下一页](@next)

