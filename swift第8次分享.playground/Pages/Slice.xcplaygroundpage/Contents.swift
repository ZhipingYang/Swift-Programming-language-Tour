//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

let arr = [11,22,33,44,55,66]

let new = arr.split(separator: 55)
new

let new2 = arr.split { (num) -> Bool in
    return num<30
}
new2