import Foundation

class Item {
    let itemName: String
    let serialNumber: String
    let valueInDollars: Int
    let dateCreated: NSDate

    // Designated Initializer
    init(itemName name: String, valueInDollars: Int, serialNumber: String) {
        self.itemName = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        dateCreated = NSDate()
    }

    convenience init(itemName name: String) {
        self.init(itemName: name, valueInDollars: 0, serialNumber: "")
    }

    convenience init() {
        self.init(itemName: "Item")
    }

    class func randomItem() -> Item {
        let randomAdjectiveList = ["Fluffy", "Rusty", "Shiny"]
        let randomNounList = ["Bear", "Spork", "Mac"]
        let adjectiveIndex = Int(arc4random()) % randomAdjectiveList.count
        let nounIndex = Int(arc4random()) % randomNounList.count

        let randomName = "\(randomAdjectiveList[adjectiveIndex]) \(randomNounList[nounIndex])"
        let randomVal = Int(arc4random()) % 100
        let aStr = "A" + 0

        let randomSerial =
            "\(arc4random() % 10)\(aStr + Int(arc4random() % 26))" +
            "\(arc4random() % 10)\(aStr + Int(arc4random() % 26))\(arc4random() % 10)"

        return Item(itemName: randomName, valueInDollars: randomVal, serialNumber: randomSerial)
    }

    func description() -> String {
        return "\(itemName) (\(serialNumber)): Worth $\(valueInDollars), recorded on \(dateCreated)"
    }
}