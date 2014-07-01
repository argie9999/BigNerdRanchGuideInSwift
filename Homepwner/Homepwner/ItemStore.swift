import Foundation

class ItemStore {
    var privateItems = Item[]()
    var allItems: Item[] { return privateItems }

    // Thread safe Singleton
    // Bronze challenge: Make sharedStore thread-safe.
    class var sharedStore: ItemStore {
        struct Static {
            static let instance: ItemStore = ItemStore()
        }
        return Static.instance
    }

    init () {
        let archivedItems : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchivePath())

        if archivedItems {
            privateItems = archivedItems as Item[]
        }
        else {
            privateItems = Item[]()
        }
    }

    func createItem() -> Item {
        let item = Item()
        privateItems.append(item)

        return item
    }

    func removeItem(item: Item) {
        if let imageKey = item.itemKey {
            ImageStore.sharedStore.dictionary.removeValueForKey(imageKey)
        }

        let indexOfItem = privateItems.indexOf() { $0 == item }
        if let index = indexOfItem {
            privateItems.removeAtIndex(index)
            println("Removed item at index \(index)")
        }
    }

    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let item = privateItems[fromIndex]
        println("Moving item from row:\(fromIndex) to row:\(toIndex)")
        privateItems.removeAtIndex(fromIndex)
        privateItems.insert(item, atIndex: toIndex)
    }

    // MARK: Archiving related methods

    /**
    Constructs a path to the documents directory for storing instances of Item
    */
    func itemArchivePath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        return path.stringByAppendingPathComponent("items.archive")
    }

    func saveChanges() -> Bool {
        let path = itemArchivePath()

        return NSKeyedArchiver.archiveRootObject(privateItems, toFile: path)
    }
}
