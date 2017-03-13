/*:
 错误处理 ❌
 ==========
 举例：假如有个从磁盘上的某个文件读取数据并进行处理的任务，该任务会有多种可能失败的情况，包括指定路径下文件并不存在，文件不具有可读权限，或者文件编码格式不兼容。区分这些不同的失败情况可以让程序解决并处理某些错误，然后把它解决不了的错误报告给用户
 - 表示并抛出错误
 - 处理错误
 - 指定清理操作
 */

import UIKit

//: 表示并抛出错误
enum ATMError: Error {
    case invalid                                //暂定服务
    case insufficientFunds(coinsNeeded: Int)    //余额不足
    case outOfStock                             //机器余额不足
}

throw ATMError.insufficientFunds(coinsNeeded: 5)


//: 处理错误

struct Card {
    var money = 0
    mutating func topUp(_ num:Int) {
        money = money+num
    }
}

struct ATM {
    
    var store = 10000
    
    mutating func getMoneyFrom( card:inout Card, money:Int) throws {
        if self.store <= 0 {
            throw ATMError.invalid
        } else if money > store {
            throw ATMError.outOfStock
        } else if card.money < money {
            throw ATMError.insufficientFunds(coinsNeeded: money-card.money)
        } else {
            store -= money
            card.money -= money
            print("取款成功")
        }
    }
}

var mycard = Card(money: 1000)
var atm = ATM(store: 10000)

try atm.getMoneyFrom(card: &mycard, money: 10000)


//: 指定清理操作




