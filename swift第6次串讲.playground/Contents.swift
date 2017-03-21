
/*:
 Swift 协议 👩🏻‍🎓
 ============
 类、结构体或枚举都可以遵循协议
 
 - 协议语法
 - 属性要求
 - 方法要求
 - Mutating 方法要求
 - 构造器要求
 - 协议作为类型
 - 委托（代理）模式
 - 通过扩展添加协议一致性
 - 通过扩展遵循协议
 - 协议类型的集合
 - 协议的继承
 - 类类型专属协议
 - 协议合成
 - 检查协议一致性
 - 可选的协议要求
 - 协议扩展
 */
import UIKit

/*:
 协议语法
 ------
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
 ------
 在类型声明后加上 { set get } 来表示属性是可读可写的，可读属性则用 { get }
 { set get } 不适合在Extension和enum中执行，只能使用{ get }
 */

protocol SomeProtocol1 {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    static var someTypeProperty: String { set get }
}

struct SomeStruct1: SomeProtocol1 {
    static var someTypeProperty: String = "someTypeProperty"
    var mustBeSettable: Int
    var doesNotNeedToBeSettable: Int
}

SomeStruct1.someTypeProperty = "123"
SomeStruct1.someTypeProperty

let someStruct = SomeStruct1(mustBeSettable: 2, doesNotNeedToBeSettable: 3)
someStruct.mustBeSettable
someStruct.doesNotNeedToBeSettable


/*:
 方法要求
 ------
 */

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
 Mutating 方法：有时需要在方法中改变方法所属的实例(如结构体、枚举等值类型)
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
 ------
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
 ------
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
 ------
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
 ------
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
 ------
 */
protocol Area: class {
    var area:Double {get}
}

//struct CGPoint: Area {
//
//}

/*:
 协议合成
 ------
 */
protocol Student {
    var subject: String {get}
}
protocol Father {
    var project: String { set get }
}

struct Family: Student, Father {
    var project: String
    var subject: String
}

func hopeSonPassTheTest(obj: Student & Father) {
    print("老爸的<\(obj.project)>项目很忙，没法辅导儿子<\(obj.subject)>科目的考试")
}

let family = Family(project: "查违章", subject: "英语")
hopeSonPassTheTest(obj: family)


/*:
 检查协议一致性
 ------------
 可以使用类型转换中描述的 is 和 as 操作符来检查协议一致性，即是否符合某协议
 */
protocol Color {
    var color:UIColor {get}
}

class BlackBoard: Color {
    let color =  UIColor.black
}

class Glass {
    var color: UIColor {
        return UIColor.clear
    }
}

class Apple: Color {
    var color: UIColor
    init(_ color: UIColor) {
        self.color = color
    }
}

let arr = [BlackBoard(), Glass(), Apple(.red)] as [AnyObject]
arr.forEach {
    let classNmae = String(describing: $0)
    if $0 is Color {
        print("\(classNmae) is follow Color")
    } else {
        print("\(classNmae) isn't follow Color")
    }
    
    //    if let _ = $0 as? Color {
    //        print("\(classNmae) as Color")
    //    } else {
    //        print("\(classNmae) cann't as Color")
    //    }
}

//extension Glass: Color {}
//
//let glass = Glass()
//
//if let _ = glass as? Color, glass is Color {
//    print("😘 Glass is kind of clear Color")
//}

/*:
 可选的协议要求 (optional)
 -----------
 */


@objc protocol Yell {
    // 分贝
    @objc optional var db: Int {get}
    // 叫
    @objc optional func yell() -> String
}

class Daniel: NSObject, Yell {
    var age = 12
    var db = 20
    func yell() -> String {
        return "hahaha..."
    }
}

class Cat: NSObject, Yell {
    func yell() -> String {
        return "喵。。。"
    }
}

class Animal {
    var delegate: Yell?
}

let animal = Animal()
let human = Daniel()
animal.delegate = human
animal.delegate?.yell?()
animal.delegate?.db

let cat = Cat()
animal.delegate = cat
animal.delegate?.yell?()
animal.delegate?.db


/*:
 协议扩展 (注意：协议的默认实现) 👍🏻
 -----------------------------
 协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数
 */

protocol PlayGame {
    var gameName: String {get}
    func startGame()
    func endGame()
}

extension PlayGame {
    func startGame() {
        print("\(self.gameName) 游戏开始了")
    }
    func endGame() {
        print(self.gameName + " 结束了")
    }
}

extension Daniel: PlayGame {
    var gameName: String {
        return "王者荣耀"
    }
}

human.gameName
human.startGame()
human.endGame()

//: 为协议扩展添加限制条件

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

class Designer: Entertainment {
    func haveFun() {
        print("只能自己看\(name)")
    }
    var name: String = "动画片"
}


let prog = Programmer()
prog.haveFun()
let prod = Producter()
prod.haveFun()
let desi = Designer()
desi.haveFun()


//: 集合的运用

extension Collection where Iterator.Element: Entertainment {
    var allNames:String {
        return self.reduce("结果：", {
            $0 + "\n" + $1.name
        })
    }
}

let representableArray = [Designer(),Designer(),Designer()]
// 留下待解决问题
//let representableArray = [Programmer(),Designer()] as [Entertainment]
print(representableArray.allNames)
