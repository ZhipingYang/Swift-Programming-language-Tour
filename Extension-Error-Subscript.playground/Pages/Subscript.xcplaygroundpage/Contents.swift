//: [Extension](Extension) |
//: [Error](Error) |
//: Subscript
/*:
 下标 index 📍
 ============
 下标可以定义在类、结构体和枚举中，是访问集合，列表或序列中元素的快捷方式。可以使用下标的索引，设置和获取值，而不需要再调用对应的存取方法。
 举例：someArray[index]，someDictionary[key]
 - 下标语法
 - 下标用法
 - 小标选项
 */
import Foundation
/*:
 下标语法
 ```
subscript(index: Int) -> Int {
    get {
        // 返回一个适当的 Int 类型的值
    }
    set(newValue) {
        // 执行适当的赋值操作
    }
}
 ```
 */
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
threeTimesTable[6]

/*:
 下标用法
 -------
 参考Array和Dictionary
 */

struct CKDictionary {
    var store:[String: Any] = [:]
    subscript(index: String) -> Any? {
        get {
            return store[index]
        }
        set(newValue) {
            if let v = newValue {
                store[index] = v
            }
        }
    }
}

var ck = CKDictionary(store: ["a":1, "b":2, "c":2, "d":4, ])
ck["b"]
ck["c"] = "c"
ck["c"]
ck["e"]


/*:
 小标选项
 -------
 下标可以接受任意数量的入参，并且这些入参可以是任意类型。下标的返回值也可以是任意类型。下标可以使用变量参数和可变参数，但不能使用输入输出参数，也不能给参数设置默认值。
 */


struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix.init(rows: 2, columns: 2)
matrix.grid
matrix[0,0] = 9
matrix[1,1] = 8
matrix.grid

//matrix[2,1] = 8


//: [返回 Extension](Extension)
