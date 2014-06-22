import UIKit

// A couple of useful additions to Array
extension Array {
    func indexOf(fn: T -> Bool) -> Int? {
        for (i, element) in enumerate(self) {
            if fn(element) {
                return i
            }
        }
        return nil
    }

    func objectAtIndex(index: Int) -> T? {
        for (i, element) in enumerate(self) {
            if i == index {
                return element
            }
        }
        return nil
    }
}

class ItemsViewController: UITableViewController {
    // Since we can't have a strong optional type, this is a workaround.
    // Could be better?
    var _headerView: UIView? = nil
    @IBOutlet strong var headerView: UIView {
    get {
        if !_headerView {
            NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
        }
        return _headerView!
    }
    set {
        _headerView = newValue
    }
    }

    convenience init() {
        self.init(style: .Plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.tableHeaderView = headerView
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allItems.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let items = ItemStore.sharedStore.allItems
        cell.textLabel.text = items[indexPath.row].description()

        return cell
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath!)
    {
        if editingStyle == .Delete {
            let items = ItemStore.sharedStore.allItems

            // Remove item
            println("Removing item. Table currently has \(items.count - 1) item(s)")
            ItemStore.sharedStore.removeItem(items[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func tableView(tableView: UITableView!, moveRowAtIndexPath sourceIndexPath: NSIndexPath!,
        toIndexPath destinationIndexPath: NSIndexPath!)
    {
        ItemStore.sharedStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    // Bronze challenge: Change the label of the delete confirmation button
    override func tableView(tableView: UITableView!,
        titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath!) -> String!
    {
        return "Remove"
    }

    @IBAction func addNewItem(sender: AnyObject) {
        if let button = sender as? UIButton {
            // Add a new item to the store.
            let newItem = ItemStore.sharedStore.createItem()
            let allItems = ItemStore.sharedStore.allItems
            let rowNumber = allItems.indexOf() { $0 == newItem }

            if let lastRow = rowNumber {
                let indexPaths: NSIndexPath[] = [NSIndexPath(forRow: lastRow, inSection: 0)]
                println("Adding new item. Table currently has \(lastRow + 1) item(s) in total.")
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
            }
        }
    }

    @IBAction func toggleEditingMode(sender: AnyObject) {
        if let button = sender as? UIButton {
            // In objective-c this is self.isEditing
            if editing {
                button.setTitle("Edit", forState: .Normal)
                setEditing(false, animated: true)
            }
            else {
                button.setTitle("Done", forState: .Normal)
                setEditing(true, animated: true)
            }
        }
    }
}