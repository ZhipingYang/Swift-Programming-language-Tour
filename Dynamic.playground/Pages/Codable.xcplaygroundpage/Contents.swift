
import UIKit

let jsonString =
"""
{
"name": "小明",
"age": 12,
"weight": 43.2
}
"""

struct Student: Decodable {
    var name: String
    var age: Int
    var weight: Float
}

let xiaoming = try JSONDecoder().decode(Student.self, from: jsonString.data(using: .utf8)!)
xiaoming.name

do {
    let xiaoming = try JSONDecoder().decode(Student.self, from: jsonString.data(using: .utf8)!)
    xiaoming.age
} catch {
    // 异常处理
}
