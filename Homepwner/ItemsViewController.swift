import UIKit

class ItemsViewController: UITableViewController {
    convenience init() {
        self.init(style: .Plain)
        for _ in 0..5 {
            let item = ItemStore.sharedStore
        }
    }
}