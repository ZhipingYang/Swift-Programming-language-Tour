import Foundation

//柯里化
public func square(_ a:Float) -> Float {
    return a * a
}
public func cube(_ a:Float) -> Float {
    return a * a * a
}
public func averageSumOfSquares(a:Float,b:Float) -> Float {
    return (square(a) + square(b)) / 2.0
}
public func averageSumOfCubes(a:Float,b:Float) -> Float {
    return (cube(a) + cube(b)) / 2.0
}
// Currying（柯里化），可以灵活调配使用
public func averageOfFunction(a:Float,b:Float,f:((Float) -> Float)) -> Float {
    return (f(a) + f(b)) / 2
}
