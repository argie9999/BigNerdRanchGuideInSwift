import Foundation
import CoreData

extension Array {
    var last: T {
        get {
            return self[endIndex - 1]
        }
    }
}

class ItemStore: NSObject {

    // MARK: Stored properties
    var privateItems = [Item]()
    var allItems: [Item] { return privateItems }

    // MARK: Core Data related properties
    var context: NSManagedObjectContext?
    var model: NSManagedObjectModel
    var privateAssets = [AnyObject]()

    // MARK: Initializers

    // Thread safe Singleton
    // Bronze challenge: Make sharedStore thread-safe.
    class var sharedStore: ItemStore {
        struct Static {
            static let instance: ItemStore = ItemStore()
        }
        return Static.instance
    }

    override init() {
        // Read in Homepwner.xcdamamodeld
        model = NSManagedObjectModel.mergedModelFromBundles(nil)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        super.init()

        // Where does the SQLite file fo?
        let path = itemArchivePath()
        let storeURL = NSURL(fileURLWithPath: path)
        var error: NSError?

        if psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL,
            options: nil, error: &error) == nil
        {
            let ex = NSException(name: "OpenFailure", reason: error!.localizedDescription,
                userInfo: nil)
            ex.raise()
        }
        context = NSManagedObjectContext()
        context!.persistentStoreCoordinator = psc

        loadAllItems()
    }

    // MARK: Item methods

    func createItem() -> Item? {
        var order: Double

        if allItems.count == 0 {
            order = 1.0
        }
        else {
            order = privateItems.last.orderingValue + 1.0
        }
        println("Adding after \(privateItems.count) items. Order: \(order)")

        let result : AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context)

        if let item = result as? Item {
            item.orderingValue = order

            let defaults = NSUserDefaults.standardUserDefaults()
            item.valueInDollars = CInt(defaults.integerForKey(NEXT_ITEM_VALUE_PREFS_KEY))
            item.itemName = defaults.objectForKey(NEXT_ITEM_NAME_PREFS_KEY) as String
            item.serialNumber = ""

            // Log all the defaults
            println(defaults.dictionaryRepresentation())

            privateItems.append(item)
            return item
        }
        return nil
    }

    func removeItem(item: Item) {
        if let imageKey = item.itemKey {
            ImageStore.sharedStore.dictionary.removeValueForKey(imageKey)
        }

        let indexOfItem = privateItems.indexOf() { $0 === item }
        if let index = indexOfItem {
            context!.deleteObject(item)
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

        // Computing a new orderValue for the object that was moved
        var lowerBound = 0.0

        // Is there an object before it in the array?
        if toIndex > 0 {
            lowerBound = privateItems[toIndex - 1].orderingValue
        }
        else {
            lowerBound = privateItems[1].orderingValue - 2.0
        }

        var upperBound = 0.0

        // Is there an object after it in the array?
        if toIndex < privateItems.count - 1 {
            upperBound = privateItems[toIndex + 1].orderingValue
        }
        else {
            upperBound = privateItems[toIndex - 1].orderingValue + 2.0
        }

        let newOrderValue = (lowerBound + upperBound) / 2.0
        println("Moving to order: \(newOrderValue)")
        item.orderingValue = newOrderValue
    }

    // MARK: Archiving related methods

    /**
    Constructs a path to the documents directory for storing instances of Item
    */
    func itemArchivePath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        return path.stringByAppendingPathComponent("store.data")
    }

    func saveChanges() -> Bool {
        var error: NSError?
        let success = context!.save(&error)
        if !success {
            println("Error saving; \(error!.localizedDescription)")
        }

        return success
    }

    func loadAllItems() {
        println("In loadAllItems")
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)
        request.entity = entity

        let sd = [NSSortDescriptor(key: "orderingValue", ascending: true)]
        request.sortDescriptors = sd

        var error: NSError?
        let result = context!.executeFetchRequest(request, error: &error)
        if result == nil {
            let ex = NSException(name: "Fetch failed", reason: "\(error!.localizedDescription)", userInfo: nil)
            ex.raise()
        }

        privateItems = result as [Item]
    }

    func allAssetTypes() -> [AnyObject] {
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("AssetType", inManagedObjectContext: context)
        request.entity = entity

        var error: NSError?
        let result = context!.executeFetchRequest(request, error: &error)

        if !(result != nil) {
            let ex = NSException(name: "Fetch failed", reason: "\(error!.localizedDescription)",
                userInfo: nil)
            ex.raise()
        }

        privateAssets = result

        // Is this the first time the program is being run?
        if privateAssets.count == 0 {
            // Furniture asset
            var type : AnyObject! = NSEntityDescription.insertNewObjectForEntityForName("AssetType",
                inManagedObjectContext: context)
            type.setValue("Furniture", forKey: "label")
            privateAssets.append(type)

            // Jewelry asset
            type = NSEntityDescription.insertNewObjectForEntityForName("AssetType",
                inManagedObjectContext: context)
            type.setValue("Jewelry", forKey: "label")
            privateAssets.append(type)

            // Electronics asset
            type = NSEntityDescription.insertNewObjectForEntityForName("AssetType",
                inManagedObjectContext: context)
            type.setValue("Electronics", forKey: "label")
            privateAssets.append(type)
        }

        return privateAssets
    }
}
