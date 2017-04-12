//: [Previous](@previous)

import UIKit

var str = "Hello, playground"

//: [Next](@next)

let numbersCompound = [[1,2,3],[4,5,6]]

let new = numbersCompound.flatMap{ $0 }

new

let view = UIView()
view.addSubview(UIView())

let views = [view].map{$0.subviews}.flatMap{$0}
views