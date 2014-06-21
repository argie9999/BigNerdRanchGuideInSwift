import UIKit

class ItemsViewController: UITableViewController {
    convenience init() {
        self.init(style: .Plain)
        for _ in 0..5 {
            ItemStore.sharedStore.createItem()
        }
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allItems.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "UITableViewCell")
        let items = ItemStore.sharedStore.allItems
        cell.textLabel.text = items[indexPath.row].description()

        return cell
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}