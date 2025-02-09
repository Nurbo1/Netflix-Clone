import UIKit

class MyClass {
    var text: String = "1"
}

var value: MyClass? = MyClass() // 1
weak var weakValue: MyClass? = value // 1
value?.text = "2"

let closure = { [weak value] in
    value?.text = "3"
}

closure() // 3
value = nil // 0

print(weakValue?.text as Any)
