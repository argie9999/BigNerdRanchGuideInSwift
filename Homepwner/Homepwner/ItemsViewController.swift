import UIKit

class ItemsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    convenience init() {
        self.init(style: .Plain)
        navigationItem.title = "Homepwner"

        // A button for adding new items
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
            target: self, action: "addNewItem")
    }

    func addNewItem() {
        let newItem = ItemStore.sharedStore.createItem()
        let dvc = DetailViewController(isNew: true)
        dvc.item = newItem
        dvc.dismissBlock = {
            self.tableView.reloadData()
            println("Saving Item and asking to dismiss DetailViewController")
        }

        let navController = UINavigationController(rootViewController: dvc)
        navController.modalPresentationStyle = .FormSheet
        presentViewController(navController, animated: true) { println("Showing DetailViewController via UINavigationController") }
    }

    // MARK: overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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

    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath!)
    {
        if editingStyle == .Delete {
            let items = ItemStore.sharedStore.allItems

            // Remove item
            ItemStore.sharedStore.removeItem(items[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            println("Removing item. Table currently has \(items.count - 1) item(s)")
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

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Selected row:\(indexPath.row)")
        let items = ItemStore.sharedStore.allItems
        let selectedItem = items[indexPath.row]
        let detailViewController = DetailViewController(isNew: false)
        detailViewController.item = selectedItem
        navigationController.pushViewController(detailViewController, animated: true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
