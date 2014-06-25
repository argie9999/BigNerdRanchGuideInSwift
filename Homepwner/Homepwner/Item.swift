import Foundation

class Item: Equatable {
    var itemName: String
    var serialNumber: String
    var valueInDollars: Int
    var dateCreated: NSDate
    @NSCopying var itemKey: NSString?

    // Designated Initializer
    init(name: String, valueInDollars: Int, serialNumber: String) {
        self.itemName = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        dateCreated = NSDate()

        // Create a NSUUID object and get its string representation
        let uuid = NSUUID()
        itemKey = uuid.UUIDString
    }

    convenience init(itemName name: String) {
        self.init(name: name, valueInDollars: 0, serialNumber: "")
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

        return Item(name: randomName, valueInDollars: randomVal, serialNumber: randomSerial)
    }

    func description() -> String {
        return "\(itemName) (\(serialNumber)): Worth $\(valueInDollars), recorded on \(dateCreated)"
    }
}

// Conform to the Equatable Protocol (I have to put this outside the class' scope)
func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.itemName == rhs.itemName &&
           lhs.serialNumber == rhs.serialNumber &&
           lhs.dateCreated == rhs.dateCreated &&
           lhs.valueInDollars == rhs.valueInDollars
}