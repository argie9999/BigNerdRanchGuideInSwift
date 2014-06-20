import UIKit

class ItemsViewController: UITableViewController {
    init() {
        super.init(style: UITableViewStyle.Plain)
    }

    convenience init(style: UITableViewStyle) {
        self.init()
    }

    convenience init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.init(nibName: nil, bundle: nil)
    }
}