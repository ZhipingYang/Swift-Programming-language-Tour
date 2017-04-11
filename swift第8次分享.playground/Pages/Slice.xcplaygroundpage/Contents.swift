//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)




import UIKit

protocol Entertainment {
    var name: String {get}
    func haveFun()
}

extension Entertainment where Self: Programmer {
    var name: String {
        return "video game"
    }
    func haveFun() {
        print("开始玩\(name)啦。。")
    }
}

extension Entertainment where Self: Producter {
    // 拓展里只能是计算属性
    var name: String {
        return "card game"
    }
    func haveFun() {
        print("来一起玩\(name)，怎么样")
    }
}


class Programmer: Entertainment {}

class Producter: Entertainment {}

extension Array where Iterator.Element: Entertainment {
    var allNames:String {
        return self.reduce("结果：", {
            $0 + "\n" + $1.name
        })
    }
}

let representableArray = [Programmer(),Programmer(),Programmer()]
// 留下待解决问题
//let representableArray = [Producter(),Programmer()] as [Entertainment]
print(representableArray.allNames)