import UIKit

class ItemsViewController: UITableViewController, UITableViewDelegate,
    UITableViewDataSource, UIPopoverControllerDelegate, UIViewControllerRestoration,
    UIDataSourceModelAssociation
{
    var imagePopover: UIPopoverController?

    override init() {
        super.init(style: .Plain)
        navigationItem.title = NSLocalizedString("Homepwner", comment:"Name of application")

        // Report itemsViewController's restoration identifier for state restoration
        restorationIdentifier = NSStringFromClass(classForCoder)
        restorationClass = classForCoder

        // A button for adding new items
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
            target: self, action: "addNewItem")

        // NOTE: Currently there is a bug which is preventing this notification from
        // being triggered.
        // Link: http://stackoverflow.com/questions/24090313/dynamic-type-notification-is-not-getting-triggered
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableViewForDynamicTypeSize",
            name: UIContentSizeCategoryDidChangeNotification, object: nil)

        // Register for locale change notifications
        // NOTE: Same bug from above exists here as well.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "localeChanged:",
            name: NSCurrentLocaleDidChangeNotification, object: nil)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        navController.restorationIdentifier = NSStringFromClass(navController.classForCoder)
        navController.modalPresentationStyle = .FormSheet
        presentViewController(navController, animated: true) { println("Showing DetailViewController via UINavigationController") }
    }

    // MARK: overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ItemCell")

        // Return to the previous scroll offset.
        tableView.restorationIdentifier = "ItemsViewControllerView"
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allItems.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as ItemCell
        let items = ItemStore.sharedStore.allItems
        let item = items[indexPath.row]

        // Configure the cell with the Item
        cell.nameLabel!.text = item.itemName
        cell.serialNumberLabel!.text = item.serialNumber

        struct Static {
            static var currencyFormatter: NSNumberFormatter? = nil
        }

        if Static.currencyFormatter != nil {
            Static.currencyFormatter = NSNumberFormatter()
            Static.currencyFormatter!.numberStyle = .CurrencyStyle
        }

        // Bronze challenge: Color coding
        // If Item is worth more than $50, value label text should be green, otherwise red.
        if (item.valueInDollars > 50) {
            // This is less harsh than UIColor.greenColor() 😊
            cell.valueLabel!.textColor = UIColor(red: 0.1, green: 0.7, blue: 0, alpha: 1)
        }
        else {
            cell.valueLabel!.textColor = UIColor.redColor()
        }
        cell.valueLabel?.text = Static.currencyFormatter?.stringFromNumber(
            NSNumber.numberWithInt(item.valueInDollars))

        let img = item.thumbnail as UIImage?

        if img != nil {
            cell.thumbnailView!.image = img
        }

        weak var weakCell = cell
        cell.actionBlock = {
            println("Going to show image for \(item)")

            let strongCell = weakCell
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                if item.itemKey != nil {
                    let itemKey = item.itemKey!

                    // If there is no image, don't display anything
                    if let img = ImageStore.sharedStore.imageForKey(itemKey) {
                        // Make a rectangle for the frame of the thumbnail relative to our tableView
                        let rect = self.view.convertRect(strongCell!.thumbnailView!.bounds, fromView: strongCell!.thumbnailView)
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
        let items = ItemStore.sharedStore.allItems
        println("Selected row:\(indexPath.row), item order: \(items[indexPath.row].orderingValue)")
        let selectedItem = items[indexPath.row]
        let detailViewController = DetailViewController(isNew: false)
        detailViewController.item = selectedItem
        navigationController.pushViewController(detailViewController, animated: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateTableViewForDynamicTypeSize()
    }

    func updateTableViewForDynamicTypeSize() {
        struct Static {
            static let cellHeightDictionary: Dictionary<NSString, Int> = [
                UIContentSizeCategoryExtraSmall: 44,
                UIContentSizeCategorySmall: 44,
                UIContentSizeCategoryMedium: 44,
                UIContentSizeCategoryLarge: 44,
                UIContentSizeCategoryExtraLarge: 55,
                UIContentSizeCategoryExtraExtraLarge: 65,
                UIContentSizeCategoryExtraExtraExtraLarge: 75,
            ]
        }

        let userSize = UIApplication.sharedApplication().preferredContentSizeCategory
        let cellHeight = Static.cellHeightDictionary[userSize]
        tableView.rowHeight = CGFloat(cellHeight!)
        tableView.reloadData()
    }

    func localeChanged(note: NSNotification!) {
        tableView.reloadData()
    }

    // MARK: UIPopoverController Delegate methods
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        imagePopover = nil
    }

    // MARK: UIViewControllerRestoration protocol methods
    class func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject]!,
        coder: NSCoder!) -> UIViewController!
    {
        return ItemsViewController()
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder!) {
        coder.encodeBool(editing, forKey: "TableViewEditing")

        super.encodeRestorableStateWithCoder(coder)
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder!) {
        editing = coder.decodeBoolForKey("TableViewEditing")

        super.decodeRestorableStateWithCoder(coder)
    }

    // MARK: UIDataSourceModelAssociation protocol methods
    func modelIdentifierForElementAtIndexPath(idx: NSIndexPath!,
        inView view: UIView!) -> String!
    {
        var identifier: String?

        // Build fails when testing two optionals in DP 2 :(, will test again in DP 3.
        if idx != nil && view != nil {
                let item = ItemStore.sharedStore.allItems[idx.row]
                identifier = item.itemKey
        }
        return identifier
    }

    func indexPathForElementWithModelIdentifier(identifier: String!,
        inView view: UIView!) -> NSIndexPath!
    {
        var indexPath: NSIndexPath?

        if identifier != nil && view != nil {
            let items = ItemStore.sharedStore.allItems

            for item in items {
                if identifier == item.itemKey {
                    let row = items.indexOf() { $0 === item }
                    indexPath = NSIndexPath(forRow: row!, inSection: 0)
                    break
                }
            }
        }

        return indexPath
    }
}
