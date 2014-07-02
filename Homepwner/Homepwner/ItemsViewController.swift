import UIKit

class ItemsViewController: UITableViewController, UITableViewDelegate,
    UITableViewDataSource, UIPopoverControllerDelegate
{
    var imagePopover: UIPopoverController?

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
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ItemCell")
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allItems.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as ItemCell
        let items = ItemStore.sharedStore.allItems
        let item = items[indexPath.row]

        // Configure the cell with the Item
        cell.nameLabel.text = item.itemName
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = String(item.valueInDollars)
        cell.thumbnailView.image = item.thumbnail
        cell.actionBlock = {
            println("Going to show image for \(item)")
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                let itemKey = item.itemKey!

                // If there is no image, don't display anything
                if let img = ImageStore.sharedStore.imageForKey(itemKey) {
                    // Make a rectangle for the frame of the thumbnail relative to our tableView
                    let rect = self.view.convertRect(cell.thumbnailView.bounds, fromView: cell.thumbnailView)
                    // Create a new ImageViewController and set its image
                    let ivc = ImageViewController()
                    ivc.image = img

                    // Present a 600x600 popover from the rect
                    self.imagePopover = UIPopoverController(contentViewController: ivc)
                    self.imagePopover!.delegate = self
                    self.imagePopover!.popoverContentSize = CGSizeMake(600, 600)
                    self.imagePopover!.presentPopoverFromRect(rect, inView: self.view,
                        permittedArrowDirections: .Any, animated: true)
                }
            }
            else {
                println("Device is not an iPad, so not showing the popup view.")
            }
        }
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

    // MARK: UIPopoverController Delegate methods
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        imagePopover = nil
    }
}
