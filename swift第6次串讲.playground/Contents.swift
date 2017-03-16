
/*:
 Swift 协议 👩🏻‍🎓
 ============
 协议语法
 属性要求
 方法要求
 Mutating 方法要求
 构造器要求
 协议作为类型
 委托（代理）模式
 通过扩展添加协议一致性
 通过扩展遵循协议
 协议类型的集合
 协议的继承
 类类型专属协议
 协议合成
 检查协议一致性
 可选的协议要求
 协议扩展
 */

import UIKit

/*:
 协议语法
 */

protocol SomeProtocol {
    
}

struct SomeStructure: SomeProtocol {
    
}

class SomeClass {
    
}

class ChildClass: SomeClass, SomeProtocol {
    
}

/*:
 属性要求
 在类型声明后加上 { set get } 来表示属性是可读可写的，可读属性则用 { get }
 */

protocol SomeProtocol1 {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    static var someTypeProperty: String { get set }
}

struct Person: SomeProtocol {
    var mustBeSettable: Int
    var doesNotNeedToBeSettable: Int
}

let bob = Person(mustBeSettable: 2, doesNotNeedToBeSettable: 3)

/*:
 方法要求
 */

protocol SomeProtocol2 {
    static func someTypeMethod()
}

// 协议并不关心每一个随机数是怎样生成的，它只要求必须提供一个随机数生成器
protocol RandomNumberProtocol {
    func random() -> Double
}

class CLColor: RandomNumberProtocol {
    var randomColor:UIColor {
        return UIColor(red: CGFloat(random()),
                       green: CGFloat(random()),
                       blue: CGFloat(random()),
                       alpha: 1)
    }
    func random() -> Double {
        return Double(Int(arc4random()) % 256)/256.0
    }
}
let randomColor = CLColor().randomColor


/*:
 Mutating 方法要求
 ----------------
 有时需要在方法中改变方法所属的实例(如结构体、枚举等值类型)
 */
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case Off, On
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        case .On:
            self = .Off
        }
    }
}
var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()


/*:
 构造器要求
 */

protocol SomeProtocol3 {
    init(someParameter: Int)
}

// 添加了这个构造器的协议，为了让它一定被执行(指定、便利构造器及子类构造器)，可以加 required
class SomeClass3: SomeProtocol3 {
    required init(someParameter: Int) {
        // 这里是构造器的实现部分
    }
}

final class SomeClass4: SomeProtocol3 {
    // 加不加无所谓
    // required init(someParameter: Int) {
    init(someParameter: Int) {
        // 这里是构造器的实现部分
    }
}

//:> 如果类已经被标记为 final，那么不需要在协议构造器的实现中使用 required 修饰符，因为 final 类不能有子类


protocol SomeProtocol4 {
    init()
}

class SomeSuperClass {
    init() {
        // 逻辑
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // 因为遵循协议，需要加上 required
    // 因为继承自父类，需要加上 override
    required override init() {
        // 逻辑
    }
}


/*:
 协议作为类型
 场景：
 - 作为参数、返回值使用
 - 作为property
 - 集合元素
 */

// 骰子
class Dice {
    let sides: Int
    let generator: RandomNumberProtocol
    init(sides: Int, generator: RandomNumberProtocol) {
        self.sides = sides
        self.generator = generator
    }
    // 6 * random
    func roll() -> Int {
        return Int(ceil((generator.random() * Double(sides))))
    }
}

var v6 = Dice.init(sides: 6, generator: CLColor())
(1...5).forEach {_ in
    print("真出骰子数：\(v6.roll())")
}


/*:
 委托（代理）模式
 委托是一种设计模式，它允许类或结构体将一些需要它们负责的功能委托给其他类型的实例。
 */

protocol DiceGame {
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

// 飞行棋
class FeiXingQi: DiceGame {
    let finalStep = 100
    let dice = Dice(sides: 6, generator: CLColor())
    var step = 0
    var delegate: DiceGameDelegate?
    
    func play() {
        step = 0
        delegate?.gameDidStart(self)
        gameLoop: while step < finalStep {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            step += diceRoll
        }
        delegate?.gameDidEnd(self)
    }
}

// 游戏日志
class DiceGameLogger: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is FeiXingQi {
            print("\n飞行棋游戏开始: 🎲\n")
        }
        print("游戏使用的是 \(game.dice.sides)面骰子\n")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("摇出 \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("游戏结束：共计 \(numberOfTurns) 回合")
    }
}


let game = FeiXingQi()
let gameLogger = DiceGameLogger()
game.delegate = gameLogger
game.play()


/*:
 通过扩展添加协议一致性
 */

protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "这是一个\(sides)面骰子"
    }
}

extension FeiXingQi: TextRepresentable {
    var textualDescription: String {
        return "这是一个使用\(dice.sides)面骰子,优先走完\(finalStep)步的飞行棋游戏"
    }
}
print(game.dice.textualDescription)
print(game.textualDescription)



/*:
 通过扩展遵循协议
 */

struct Human {
    var name: String
    var textualDescription: String {
        return "这个人叫\(name)"
    }
}

extension Human: TextRepresentable {}

let textProtocal: TextRepresentable = Human(name: "john")
textProtocal.textualDescription

/*:
 协议类型的集合
 */
let textProtocalArr: [TextRepresentable] = [game, game.dice, Human(name: "john")]
//textProtocalArr.forEach {
//    print($0.textualDescription)
//}

/*:
 协议的继承
 --------
 
 oc 中的协议继承
 ```
 @protocol UITableViewDataSource<NSObject>
 @protocol CKTableViewDelegate<UITableViewDelegate>
 // ...
 
 ```
 
 swift 的协议继承
 ```
 protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // ...
 }
 
 ```
 */

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

extension Human: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        return name.isEmpty ? "❌: 人名无效" : "✅：这个人叫\(name)"
    }
}

let john = Human(name: "john")
let unnamed = Human(name: "")
print(john.prettyTextualDescription)
print(unnamed.prettyTextualDescription)


/*:
 类类型专属协议
 */
//protocol HumanSpecialProtocol: Dice, TextRepresentable {
//    
//}


/*:
 协议合成
 */


/*:
 检查协议一致性
 */


/*:
 可选的协议要求
 */


/*:
 协议扩展
 */

