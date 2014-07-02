import UIKit

class Item: NSObject, Equatable, NSCoding {
    var itemName: String
    var serialNumber: String
    var valueInDollars: Int
    var dateCreated: NSDate
    var thumbnail: UIImage?
    @NSCopying var itemKey: NSString?

    // MARK: Initializers
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

    // MARK: NSCoding protocol methods
    init(coder aDecoder: NSCoder!) {
        itemName = aDecoder.decodeObjectForKey("itemName") as String
        serialNumber = aDecoder.decodeObjectForKey("serialNumber") as String
        dateCreated = aDecoder.decodeObjectForKey("dateCreated") as NSDate
        itemKey = aDecoder.decodeObjectForKey("itemKey") as String
        thumbnail = aDecoder.decodeObjectForKey("thumbnail") as? UIImage
        valueInDollars = aDecoder.decodeIntegerForKey("valueInDollars")
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder!) {
        // Add the names and values of the item's properties to the stream
        aCoder.encodeObject(itemName, forKey: "itemName")
        aCoder.encodeObject(serialNumber, forKey: "serialNumber")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        aCoder.encodeObject(itemKey, forKey: "itemKey")
        aCoder.encodeObject(thumbnail, forKey: "thumbnail")
        aCoder.encodeInteger(valueInDollars, forKey: "valueInDollars")
    }

    // MARK: Item methods
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

    func setThumbnailFromImage(image: UIImage!) {
        let origImageSize = image.size
        let newRect = CGRectMake(0, 0, 40, 40)
        // Figure out a scaling ratio to make sure we maintain the same aspect ratio
        let ratio = max(newRect.size.width / origImageSize.width,
            newRect.size.height / origImageSize.height)

        // Create a transparent bitmap context with a scaling factor equal to that of the screen
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0)

        // Create a path that is a rounded rectangle
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: 5.0)
        // Make all subsequent drawing clip to this rounded rectangle
        path.addClip()

        // Center the image in the thumbnail
        var projectRect = CGRect()
        projectRect.size = CGSize(width: ratio * origImageSize.width, height: ratio * origImageSize.height)
        projectRect.origin = CGPoint(x: newRect.size.width / 20, y: projectRect.size.width / 2.0)

        // Draw the image on it
        image.drawInRect(projectRect)

        // Get the image from the image context; keep it as our thumbnail
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        thumbnail = smallImage

        // Cleanup image context resources; we're done
        UIGraphicsEndImageContext()
    }
}

// Conform to the Equatable Protocol (I have to put this outside the class' scope)
func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.itemName == rhs.itemName &&
           lhs.serialNumber == rhs.serialNumber &&
           lhs.dateCreated == rhs.dateCreated &&
           lhs.valueInDollars == rhs.valueInDollars
}