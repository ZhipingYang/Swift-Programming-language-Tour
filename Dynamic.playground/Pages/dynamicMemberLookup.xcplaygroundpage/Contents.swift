/*:
 dynamicMemberLookup
 ===================
 */
import Foundation

@dynamicMemberLookup
struct Person {
    subscript(dynamicMember member: String) -> String {
        let dic = ["name": "Daniel", "city": "Xiamen"]
        return dic[member] ?? ""
    }
    
    subscript(dynamicMember member: String) -> Int {
        return 18
    }
    
    subscript(dynamicMember member: String) -> (_ input: String) -> Void {
        return {
            print("Hello! I live at the address \($0).")
        }
    }
}

let p = Person()
let city: String = p.city
let age: Int = p.city

let fun:(String)->Void = p.hello
fun("daniel!")



@dynamicMemberLookup
class User {
    subscript(dynamicMember member: String) -> String {
        return "user"
    }
}
class Developer: User { }
let dev = Developer()
dev.name // "user"




let s = """
hello whis string
hie
[hello world]""\"
"""

print(s)

