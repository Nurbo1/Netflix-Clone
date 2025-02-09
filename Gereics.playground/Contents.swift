import UIKit

var greeting = "Hello, playground"


protocol Container {
    associatedtype Item
    var count: Int { get }
    
    mutating func append(_ item: Item)
    subscript(i: Int) -> Item {get}
}

func allItemsMatch<C1: Container, C2: Container>(_ container1: C1, container2: C2) where C1.Item == C2.Item, C1.Item: Equatable {
    
}


func doSomething(completion: () -> Void) {
    print("do something")
}

doSomething {
    print("gey")
}

let value: (Int) -> Int = { (value1) in
    return value1 * 3
}

print(value(5))
