import Foundation

let sharedStorage = ItemStore()

class ItemStore {
    class var sharedStore: ItemStore { return sharedStorage }
    var privateItems = Item[]()
    var allItems: Item[] { return privateItems }

    init () {
        NSException(name: "Singleton", reason: "Use ItemStore.sharedStore", userInfo: nil)
    }

    func createItem() -> Item {
        let item = Item.randomItem()
        privateItems += item

        return item
    }

    func removeItem(item: Item) {
        let indexOfItem = privateItems.indexOf() { $0 == item }
        if let index = indexOfItem {
            privateItems.removeAtIndex(index)
        }
    }
}