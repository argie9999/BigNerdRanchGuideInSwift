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
}